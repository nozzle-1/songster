import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';

abstract class HitsterSongPlayer {
  Future<HitsterSong> setSong(HitsterSongUrl hitsterSong);

  Future<void> play();

  Future<void> pause();

  Stream<HitsterSongPlayerState> get state;
}

enum HitsterSongPlayerState {
  loading,
  ready,
  playing,
  pause,
}
