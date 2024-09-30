part of 'game_bloc.dart';

class GameState {
  final Status status;
  final HitsterSongUrl? songUrl;
  final HitsterSong? song;

  GameState({
    required this.status,
    required this.songUrl,
    required this.song,
  });

  GameState copyWith({
    Status? status,
    HitsterSongUrl? songUrl,
    HitsterSong? song,
  }) {
    return GameState(
      status: status ?? this.status,
      songUrl: songUrl ?? this.songUrl,
      song: song ?? this.song,
    );
  }
}

enum Status {
  scanning,
  loading,
  playing,
  paused;
}
