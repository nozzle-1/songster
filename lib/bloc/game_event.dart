part of 'game_bloc.dart';

abstract class GameEvent {}

class InitialEvent extends GameEvent {}

class ScanEvent extends GameEvent {}

// TODO rename
class DownloadEvent extends GameEvent {
  final HitsterSongUrl songUrl;

  DownloadEvent({required this.songUrl});
}

class ToggleEvent extends GameEvent {}

class GoForward extends GameEvent {}

class GoBackward extends GameEvent {}
