import 'dart:typed_data';

final class HitsterSong {
  final String fullPath;
  final String hitsterUrl;
  final String title;
  final String artist;
  final String year;
  final String album;
  final Uint8List picture;
  final String? songUrl;

  HitsterSong(
      {required this.fullPath,
      required this.title,
      required this.artist,
      required this.year,
      required this.album,
      required this.picture,
      required this.hitsterUrl,
      required this.songUrl});
}
