import 'dart:typed_data';

import 'package:metadata_god/metadata_god.dart';
import 'package:minio/minio.dart';
import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';
import 'package:songster/song/provider/hister_song_provider.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:io' as io;

class S3SongProvider implements HisterSongProvider {
  static const mp3Ext = "mp3";
  static const m4aExt = "m4a";

  final minio = Minio(
      endPoint: const String.fromEnvironment("S3_ENDPOINT"),
      accessKey: const String.fromEnvironment("S3_ACCESS_KEY"),
      secretKey: const String.fromEnvironment("S3_SECRET_KEY"));

  final bucket = const String.fromEnvironment("S3_BUCKET");

  S3SongProvider() {
    MetadataGod.initialize();
  }

  static String get _currentFileExt => m4aExt;

  @override
  Future<HitsterSong> download(HitsterSongUrl url) async {
    final fullPath = await _buildSongPath(url);
    final alreadyExists = await _checkIfExists(fullPath);
    if (alreadyExists) {
      return await _buildSong(fullPath, url);
    }

    await _downloadAndSave(fullPath, url);
    return await _buildSong(fullPath, url);
  }

  Future<void> _downloadAndSave(String fullPath, HitsterSongUrl url) async {
    io.File file = io.File(fullPath);
    var songStream = await minio.getObject(bucket, _buildS3Path(url));

    var songBytes = await songStream.toList();
    for (var songByte in songBytes) {
      await file.writeAsBytes(songByte, mode: io.FileMode.append);
    }
  }

  String _buildS3Path(HitsterSongUrl url) =>
      '${url.regionCode}/$_currentFileExt/${_buildFileName(url)}';

  @override
  Future<void> delete(HitsterSong path) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  String _buildFileName(HitsterSongUrl url) {
    return "${url.id}.$_currentFileExt";
  }

  Future<String> _buildSongPath(HitsterSongUrl url) async {
    var fileName = _buildFileName(url);
    final appDir = await syspaths.getTemporaryDirectory();

    return '${appDir.path}/$fileName';
  }

  Future<bool> _checkIfExists(String path) async {
    return await io.File(path).exists();
  }

  Future<HitsterSong> _buildSong(
    String path,
    HitsterSongUrl url,
  ) async {
    final presignedUrl =
        await minio.presignedGetObject(bucket, _buildS3Path(url));

    Metadata? metadata = null;
    try {
      metadata = await MetadataGod.readMetadata(file: path);
    } catch (err) {
      print(err);
    } finally {
      io.File file = io.File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    }

    return HitsterSong(
        fullPath: path,
        title: metadata?.title ?? "",
        artist: metadata?.artist ?? "",
        year: metadata?.year?.toString() ?? "",
        album: metadata?.album ?? "",
        picture: metadata?.picture?.data ?? Uint8List.fromList([]),
        hitsterUrl: url.url,
        songUrl: presignedUrl);
  }
}
