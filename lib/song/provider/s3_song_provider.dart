import 'dart:convert';

import 'package:minio/minio.dart';
import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';
import 'package:songster/song/provider/hister_song_provider.dart';
import 'package:http/http.dart' as http;

class S3SongProvider implements HisterSongProvider {
  static const mp3Ext = "mp3";
  static const m4aExt = "m4a";

  final Map<HitsterGameVersion, List<SongMetadata>> metadatas = {};

  final minio = Minio(
      endPoint: const String.fromEnvironment("S3_ENDPOINT"),
      accessKey: const String.fromEnvironment("S3_ACCESS_KEY"),
      secretKey: const String.fromEnvironment("S3_SECRET_KEY"));

  final bucket = const String.fromEnvironment("S3_BUCKET");

  S3SongProvider();

  static String get _currentSongExt => mp3Ext;

  @override
  Future<HitsterSong> download(HitsterSongUrl url) async {
    return await _buildSong(url);
  }

  @override
  Future<void> delete(HitsterSong path) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<HitsterSong> _buildSong(
    HitsterSongUrl url,
  ) async {
    final presignedSongUrl = await minio.presignedGetObject(bucket,
        '${url.regionCode}/${getVersionPath(url)}/$_currentSongExt/${url.id}.$_currentSongExt');
    final presignedCoverUrl = await minio.presignedGetObject(bucket,
        '${url.regionCode}/${getVersionPath(url)}/cover/${url.id}.jpg');

    var metadata = await getMetadata(url);

    return HitsterSong(
        title: metadata.title,
        artist: metadata.artist,
        year: metadata.year.toString(),
        album: metadata.album,
        coverUrl: presignedCoverUrl,
        hitsterUrl: url.url,
        songUrl: presignedSongUrl);
  }

  Future<SongMetadata> getMetadata(HitsterSongUrl url) async {
    if (!metadatas.containsKey(url.version)) {
      metadatas[url.version] = await fetchMetadata(url);
    }
    var allMetadata = metadatas[url.version]!;

    return allMetadata.firstWhere((song) => song.id == url.id);
  }

  Future<List<SongMetadata>> fetchMetadata(HitsterSongUrl url) async {
    final presignedUrl = await minio.presignedGetObject(
        bucket, '${url.regionCode}/${getVersionPath(url)}/metadata.json');

    var response = await http.get(Uri.parse(presignedUrl));

    var metadatas = jsonDecode(utf8.decode(response.bodyBytes)) as List;

    var metadata = metadatas.map((v) => SongMetadata.fromJson(v)).toList();

    return metadata;
  }

  String getVersionPath(HitsterSongUrl url) => switch (url.version) {
        HitsterGameVersion.frV1 => "v1",
        HitsterGameVersion.frV2 => "v2",
      };
}

class SongMetadata {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int year;

  SongMetadata._(
      {required this.id,
      required this.title,
      required this.artist,
      required this.album,
      required this.year});

  factory SongMetadata.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'title': String title,
        'artist': String artist,
        'album': String album,
        'year': int year
      } =>
        SongMetadata._(
            id: id, title: title, artist: artist, album: album, year: year),
      _ => throw const FormatException('Failed to load metadata.'),
    };
  }
}