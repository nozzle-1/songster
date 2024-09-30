part of 'game_bloc.dart';

class GameState {
  final Status status;
  final HitsterSongUrl? songUrl;
  final HitsterSong? song;
  final Duration currentPosition;
  final Duration duration;

  GameState(
      {required this.status,
      required this.songUrl,
      required this.song,
      this.currentPosition = const Duration(),
      this.duration = const Duration()});

  GameState copyWith(
      {Status? status,
      HitsterSongUrl? songUrl,
      HitsterSong? song,
      Duration? currentPosition,
      Duration? duration}) {
    return GameState(
        status: status ?? this.status,
        songUrl: songUrl ?? this.songUrl,
        song: song ?? this.song,
        duration: duration ?? this.duration,
        currentPosition: currentPosition ?? this.currentPosition);
  }
}

enum Status {
  scanning,
  loading,
  playing,
  paused;
}
