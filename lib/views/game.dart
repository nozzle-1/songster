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
  bool _isScanning = true;
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
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
                        return HitsterCard(
                            hitsterUrl: _songUrl!.url, song: _song);
                      }
                      return const SizedBox();
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: StreamBuilder<Duration>(
                        stream: _player.currentPosition,
                        builder: (context, snapshot) {
                          final songDuration = _player.duration;
                          final currentPosition =
                              snapshot.data ?? const Duration();
                          final percentage = songDuration.inSeconds <= 0
                              ? 0
                              : (currentPosition.inSeconds /
                                      songDuration.inSeconds) *
                                  100;

                          return TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(
                              begin: 0,
                              end: percentage / 100,
                            ),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(25),
                                    minHeight: 10,
                                    backgroundColor: _isScanning
                                        ? const Color.fromRGBO(72, 30, 138,
                                            70) // TODO find disabled color
                                        : Colors.white.withAlpha(70),
                                    color: Colors.white,
                                    value: _isScanning ? 0 : value),
                          );
                        }),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundIconButton(
                        icon: Icons.replay_10,
                        onPressed: _isScanning
                            ? null
                            : () async => await _player.backward(),
                      ),
                      RoundIconButton(
                        icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                        onPressed: _isScanning
                            ? null
                            : () async => await pressMusicStatusButton(),
                        size: ButtonSize.big,
                        isLoading: !_isScanning && _isDownloading,
                      ),
                      RoundIconButton(
                        icon: Icons.forward_10,
                        onPressed: _isScanning
                            ? null
                            : () async => await _player.forward(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MainButton(
              label: _showCard ? "Suivant" : "Scan...",
              onPressed: _isScanning ? null : () async => await launchScan(),
            ),
          ],
        ),
      ),
    );
  }
}
