import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';

import '../song/player/hitster_song_player.dart';
import '../song/player/just_audio_song_player.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final HitsterSongPlayer _player = JustAudioSongPlayer();

  GameBloc()
      : super(GameState(
          status: Status.scanning,
          songUrl: null,
          song: null,
        )) {
    on<InitialEvent>(onInitialEvent);
    on<ScanEvent>(onScanEvent);
    on<DownloadEvent>(onDownloadEvent);
    on<ToggleEvent>(onToggleEvent);
    on<GoForward>(onGoForwardEvent);
    on<GoBackward>(onGoBackwardEvent);
  }

  void onInitialEvent(InitialEvent event, Emitter<GameState> emit) {
    // TODO attention à ne pas le déclencher plusieurs fois (plusieurs souscriptions)
    _player.state.listen(
      (playerState) => emit(
        state.copyWith(
          status: playerState == HitsterSongPlayerState.playing
              ? Status.playing
              : Status.paused,
        ),
      ),
    );
  }

  Future<void> onScanEvent(ScanEvent event, Emitter<GameState> emit) async {
    await _player.pause();

    emit(state.copyWith(
      status: Status.scanning,
      song: null,
      songUrl: null,
    ));
  }

  Future<void> onDownloadEvent(
      DownloadEvent event, Emitter<GameState> emit) async {
    emit(state.copyWith(
      status: Status.loading,
      songUrl: event.songUrl,
    ));

    final song = await _player.setSong(event.songUrl);

    await _player.play();

    emit(state.copyWith(
      status: Status.playing,
      song: song,
    ));
  }

  Future<void> onToggleEvent(ToggleEvent event, Emitter<GameState> emit) async {
    if (state.status == Status.loading) {
      return;
    }
    if (state.status == Status.playing) {
      await _player.play();
    }
    if (state.status == Status.paused) {
      await _player.pause();
    }
  }

  Future<void> onGoForwardEvent(
      GoForward event, Emitter<GameState> emit) async {
    if (state.status == Status.loading) {
      return;
    }
    await _player.forward();
  }

  Future<void> onGoBackwardEvent(
      GoBackward event, Emitter<GameState> emit) async {
    if (state.status == Status.loading) {
      return;
    }
    await _player.backward();
  }
}
