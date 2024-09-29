import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';
import 'package:songster/song/player/hitster_song_player.dart';
import 'package:songster/song/provider/hister_song_provider.dart';
import 'package:songster/song/provider/s3_song_provider.dart';

class JustAudioSongPlayer implements HitsterSongPlayer {
  static final AudioPlayer _player = AudioPlayer();
  static final HisterSongProvider _songProvider = S3SongProvider();

  final StreamController<HitsterSongPlayerState> _stateStream =
      StreamController.broadcast();

  JustAudioSongPlayer() {
    _player.playerStateStream.listen((state) {
      if (state.playing) {
        _stateStream.sink.add(HitsterSongPlayerState.playing);
      } else {
        _stateStream.sink.add(HitsterSongPlayerState.pause);
      }
    });
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

    await _player.setFilePath(song.fullPath);

    _stateStream.sink.add(HitsterSongPlayerState.ready);
    return song;
  }

  @override
  Stream<HitsterSongPlayerState> get state => _stateStream.stream;
}
