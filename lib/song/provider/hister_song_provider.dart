import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';

abstract class HisterSongProvider {
  Future<HitsterSong> download(HitsterSongUrl hitsterUrl);
  Future<void> delete(HitsterSong path);
}
