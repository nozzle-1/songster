part of 'game_bloc.dart';

class GameState {
  final Status status;
  final HitsterSongUrl? songUrl;
  final HitsterSong? song;
  final Duration currentPosition;
  final Duration duration;
  final String? error;

  GameState(
      {required this.status,
      required this.songUrl,
      required this.song,
      this.currentPosition = const Duration(),
      this.duration = const Duration(),
      this.error});

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
    final state = copyWith(
      status: Status.scanning,
      duration: const Duration(),
      currentPosition: const Duration(),
      removeSong: true,
      removeUrl: true,
    );

    return state;
  }

  GameState toLoadingState({required HitsterSongUrl songUrl}) {
    return copyWith(
        status: Status.loading,
        duration: const Duration(),
        currentPosition: const Duration(),
        removeSong: true,
        songUrl: songUrl);
  }

  GameState toErrorState({required String errorMessage}) {
    return copyWith(
        status: Status.error,
        duration: const Duration(),
        currentPosition: const Duration(),
        removeSong: true,
        songUrl: songUrl,
        error: errorMessage);
  }

  GameState toPlayingState({required HitsterSong song}) {
    return copyWith(status: Status.playing, song: song);
  }

  GameState copyWith(
      {Status? status,
      HitsterSongUrl? songUrl,
      bool removeUrl = false,
      HitsterSong? song,
      bool removeSong = false,
      Duration? currentPosition,
      Duration? duration,
      String? error}) {
    return GameState(
        status: status ?? this.status,
        songUrl: removeUrl ? null : songUrl ?? this.songUrl,
        song: removeSong ? null : song ?? this.song,
        duration: duration ?? this.duration,
        currentPosition: currentPosition ?? this.currentPosition,
        error: error ?? this.error);
  }
}

enum Status { scanning, loading, playing, paused, ready, error }
