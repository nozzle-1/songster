import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';

abstract class HitsterSongPlayer {
  Future<HitsterSong> setSong(HitsterSongUrl hitsterSong);

  Future<void> play();

  Future<void> pause();

  Future<void> backward();

  Future<void> forward();

  Stream<HitsterSongPlayerState> get state;
  Stream<Duration> get currentPosition;
  Duration get duration;

  Future<void> dispose();
}

enum HitsterSongPlayerState {
  empty,
  loading,
  ready,
  playing,
  pause,
}
