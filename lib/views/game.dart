import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:songster/song/hitster_song.dart';
import 'package:songster/song/hitster_song_url.dart';
import 'package:songster/song/player/hitster_song_player.dart';
import 'package:songster/song/player/just_audio_song_player.dart';
import 'package:songster/widgets/buttons.dart';
import 'package:songster/widgets/hitster_card.dart';
import 'package:songster/widgets/hitster_card_scanner.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  final flipController = FlipCardController();
  bool _isScanning = false;
  bool _isPlaying = false;
  bool _isDownloading = false;
  final HitsterSongPlayer _player = JustAudioSongPlayer();

  HitsterSong? _song;
  HitsterSongUrl? _songUrl;

  @override
  void initState() {
    _player.state.listen((state) {
      setState(() {
        _isPlaying = state == HitsterSongPlayerState.playing;
      });
    });
    super.initState();
  }

  bool get _showCard => _songUrl != null;

  Future<void> launchScan() async {
    await _player.pause();
    setState(() {
      _isScanning = true;
      _song = null;
      _songUrl = null;
    });
  }

  Future<void> onDetectSong(HitsterSongUrl hitsterSongUrl) async {
    setState(() {
      _isScanning = false;
      _isDownloading = true;
      _songUrl = hitsterSongUrl;
    });

    final song = await _player.setSong(hitsterSongUrl);

    setState(() {
      _isDownloading = false;
      _song = song;
    });

    await _player.play();
  }

// TODO rename
  Future<void> pressMusicStatusButton() async {
    if (_isDownloading) {
      return;
    }
    if (_isPlaying) {
      await _player.pause();
      return;
    }
    await _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Builder(builder: (context) {
                  if (_isScanning) {
                    return Card(
                      margin: const EdgeInsets.all(25),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: HitsterCardScanner(
                            onDetect: (hitsterSongUrl) async =>
                                await onDetectSong(hitsterSongUrl),
                          )),
                    );
                  }
                  if (_showCard) {
                    return HitsterCard(hitsterUrl: _songUrl!.url, song: _song);
                  }
                  return const SizedBox();
                }),
              ),
            ),
            if (_showCard)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    onPressed: () async {
                      await _player.backward();
                    },
                    icon: Builder(builder: (context) {
                      return const Icon(Icons.replay_10);
                    }),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white.withAlpha(70),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () async => await pressMusicStatusButton(),
                    icon: Builder(builder: (context) {
                      if (_isDownloading) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                      return Icon(_isPlaying ? Icons.stop : Icons.play_arrow);
                    }),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white.withAlpha(70),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () async {
                      await _player.forward();
                    },
                    icon: Builder(builder: (context) {
                      return const Icon(Icons.forward_10);
                    }),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white.withAlpha(70),
                    ),
                  ),
                ],
              ),
            StreamBuilder<Duration>(
                stream: _player.currentPosition,
                builder: (context, snapshot) {
                  final songDuration = _player.duration;
                  final currentPosition = snapshot.data ?? const Duration();
                  final percentage = songDuration.inSeconds <= 0
                      ? 0
                      : (currentPosition.inSeconds / songDuration.inSeconds) *
                          100;

                  return TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: percentage / 100,
                    ),
                    builder: (context, value, _) => LinearProgressIndicator(
                        backgroundColor: Colors.white.withAlpha(70),
                        color: Colors.white,
                        value: value),
                  );
                }),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: MainButton(
                label: "Scanner",
                onPressed: () async => await launchScan(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
