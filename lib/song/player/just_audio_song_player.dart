import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';
import 'package:songster/song/player/hitster_song_player.dart';
import 'package:songster/song/provider/hister_song_provider.dart';
import 'package:songster/song/provider/s3_song_provider.dart';

class JustAudioSongPlayer implements HitsterSongPlayer {
  static final HisterSongProvider _songProvider = S3SongProvider();
  final AudioPlayer _player = AudioPlayer();

  final StreamController<HitsterSongPlayerState> _stateStream =
      StreamController.broadcast();

  final StreamController<Duration> _currentPosition =
      StreamController.broadcast();

  Duration _duration = const Duration();

  StreamSubscription<PlayerState>? _playerStateSubscription;

  StreamSubscription<Duration?>? _playerDurationSubscription;

  StreamSubscription<Duration>? _playerPositionSubscription;

  JustAudioSongPlayer() {
    _player.setAllowsExternalPlayback(true);
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.idle) {
        _stateStream.sink.add(HitsterSongPlayerState.empty);
      } else if (state.processingState == ProcessingState.loading) {
        _stateStream.sink.add(HitsterSongPlayerState.loading);
      } else if (state.playing) {
        _stateStream.sink.add(HitsterSongPlayerState.playing);
      } else {
        _stateStream.sink.add(HitsterSongPlayerState.pause);
      }
    });

    _playerDurationSubscription = _player.durationStream.listen((duration) {
      _duration = duration ?? const Duration();
    });

    _playerPositionSubscription = _player.positionStream.listen((duration) {
      _currentPosition.sink.add(duration);
    });

    _stateStream.sink.add(HitsterSongPlayerState.empty);
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> play() async {
    await _player.setVolume(1.0);
    await _player.play();
  }

  @override
  Future<HitsterSong> setSong(HitsterSongUrl hitsterUrl) async {
    _stateStream.sink.add(HitsterSongPlayerState.loading);

    final song = await _songProvider.download(hitsterUrl);

    await _player.setUrl(song.songUrl!);

    _stateStream.sink.add(HitsterSongPlayerState.ready);
    return song;
  }

  @override
  Future<void> backward() async {
    final position = _player.position;
    final nextPosition = position.inSeconds - 10;
    await _player.seek(Duration(seconds: nextPosition));
  }

  @override
  Future<void> forward() async {
    final position = _player.position;
    final nextPosition = position.inSeconds + 10;
    await _player.seek(Duration(seconds: nextPosition));
  }

  @override
  Stream<HitsterSongPlayerState> get state => _stateStream.stream;

  @override
  Duration get duration => _duration;

  @override
  Stream<Duration> get currentPosition => _currentPosition.stream;

  @override
  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    await _playerDurationSubscription?.cancel();
    await _playerPositionSubscription?.cancel();
    await _player.dispose();
  }
}
