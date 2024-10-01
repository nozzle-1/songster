import 'dart:math';

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

  Future<void> onInitialEvent(
      InitialEvent event, Emitter<GameState> emit) async {
    await Future.wait([
      emit.forEach(_player.state, onData: (playerState) {
        // print('PlayerState: $playerState');
        final status = switch (playerState) {
          HitsterSongPlayerState.empty => Status.scanning,
          HitsterSongPlayerState.ready => Status.ready,
          HitsterSongPlayerState.loading => Status.loading,
          HitsterSongPlayerState.pause => Status.paused,
          HitsterSongPlayerState.playing => Status.playing
        };

        return state.copyWith(
            status: status,
            duration: status == Status.playing ? _player.duration : null);
      }),
      emit.forEach(_player.currentPosition, onData: (currentPosition) {
        return state.copyWith(currentPosition: currentPosition);
      })
    ]);

    emit(state.toScanningState());
  }

  Future<void> onScanEvent(ScanEvent event, Emitter<GameState> emit) async {
    await _player.pause();

    emit(state.toScanningState());
  }

  Future<void> onDownloadEvent(
      DownloadEvent event, Emitter<GameState> emit) async {
    emit(state.toLoadingState(
      songUrl: event.songUrl,
    ));

    final song = await _player.setSong(event.songUrl);

    emit(state.copyWith(
      song: song,
    ));

    await _player.play();
  }

  Future<void> onToggleEvent(ToggleEvent event, Emitter<GameState> emit) async {
    if (state.status == Status.loading) {
      return;
    }

    if (state.status == Status.playing) {
      await _player.pause();
    } else if (state.status == Status.paused) {
      await _player.play();
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
