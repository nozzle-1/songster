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

  double get percentageSongPlayed {
    final percentage = duration.inSeconds <= 0
        ? 0
        : (currentPosition.inSeconds / duration.inSeconds) * 100;

    //For LinearProgressIndicator :
    //The [value] argument can either be null for an indeterminate progress indicator, or a non-null value between 0.0 and 1.0 for a determinate progress indicator.
    return percentage / 100;
  }

  bool get playerButtonIsDisabled =>
      status == Status.scanning || status == Status.loading;

  GameState toScanningState() {
    return copyWith(
        status: Status.scanning,
        duration: const Duration(),
        currentPosition: const Duration(),
        song: null,
        songUrl: null);
  }

  GameState toLoadingState({required HitsterSongUrl songUrl}) {
    return copyWith(
        status: Status.loading,
        duration: const Duration(),
        currentPosition: const Duration(),
        song: null,
        songUrl: songUrl);
  }

  GameState toPlayingState({required HitsterSong song}) {
    return copyWith(status: Status.playing, song: song);
  }

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

enum Status { scanning, loading, playing, paused, ready }
