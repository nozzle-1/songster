final class HitsterSong {
  final String hitsterUrl;
  final String title;
  final String artist;
  final String year;
  final String album;
  final String coverUrl;
  final String? songUrl;

  HitsterSong(
      {required this.title,
      required this.artist,
      required this.year,
      required this.album,
      required this.coverUrl,
      required this.hitsterUrl,
      required this.songUrl});
}
