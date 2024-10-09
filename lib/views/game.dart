import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:songster/bloc/game_bloc.dart';
import 'package:songster/song/hitster_song_url.dart';
import 'package:songster/widgets/buttons.dart';
import 'package:songster/widgets/hitster_card.dart';
import 'package:songster/widgets/hitster_card_scanner.dart';
import 'package:songster/widgets/layout/scaffold.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  Future<void> launchScan(BuildContext context) async {
    context.read<GameBloc>().add(ScanEvent());
  }

  Future<void> onDetectSong({
    required BuildContext context,
    required HitsterSongUrl hitsterSongUrl,
  }) async {
    context.read<GameBloc>().add(
          DownloadEvent(
            songUrl: hitsterSongUrl,
          ),
        );
  }

  Future<void> pressMusicStatusButton(BuildContext context) async {
    context.read<GameBloc>().add(ToggleEvent());
  }

  Future<void> pressGoForwadButton(BuildContext context) async {
    context.read<GameBloc>().add(GoForward());
  }

  Future<void> pressGoBackwardButton(BuildContext context) async {
    context.read<GameBloc>().add(GoBackward());
  }

  @override
  Widget build(BuildContext context) {
    return SongsterScaffold(
      body: BlocProvider(
        create: (context) => GameBloc()..add(InitialEvent()),
        child: Padding(
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
                        child: BlocBuilder<GameBloc, GameState>(
                            builder: (context, state) {
                          if (state.status == Status.scanning) {
                            return Card(
                              margin: const EdgeInsets.all(25),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: HitsterCardScanner(
                                    onDetect: (hitsterSongUrl) async =>
                                        await onDetectSong(
                                      context: context,
                                      hitsterSongUrl: hitsterSongUrl,
                                    ),
                                  )),
                            );
                          }

                          if (state.songUrl != null) {
                            return HitsterCard(
                                hitsterUrl: state.songUrl!.url,
                                song: state.song);
                          }
                          return const SizedBox();
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: BlocBuilder<GameBloc, GameState>(
                            builder: (context, state) {
                          return TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(
                              begin: 0,
                              end: state.percentageSongPlayed,
                            ),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(25),
                                    minHeight: 10,
                                    backgroundColor:
                                        state.playerButtonIsDisabled
                                            ? const Color.fromRGBO(72, 30, 138,
                                                70) // TODO find disabled color
                                            : Colors.white.withAlpha(70),
                                    color: Colors.white,
                                    value: state.status == Status.scanning
                                        ? 0
                                        : value),
                          );
                        }),
                      ),
                      BlocBuilder<GameBloc, GameState>(
                          builder: (context, state) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AirPlayRoutePickerView(
                              tintColor: Colors.white,
                              activeTintColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              onClosePickerView: () {
                                print('PICKER CLOSE');
                              },
                              onShowPickerView: () {
                                print('PICKER SHOW');
                              },
                            ),
                            RoundIconButton(
                              icon: Icons.replay_10,
                              onPressed: state.playerButtonIsDisabled
                                  ? null
                                  : () async =>
                                      await pressGoBackwardButton(context),
                            ),
                            RoundIconButton(
                              icon: state.status == Status.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: state.playerButtonIsDisabled
                                  ? null
                                  : () async =>
                                      await pressMusicStatusButton(context),
                              size: ButtonSize.big,
                              isLoading: state.status == Status.loading,
                            ),
                            RoundIconButton(
                              icon: Icons.forward_10,
                              onPressed: state.playerButtonIsDisabled
                                  ? null
                                  : () async =>
                                      await pressGoForwadButton(context),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                BlocBuilder<GameBloc, GameState>(builder: (context, state) {
                  return MainButton(
                    label:
                        state.status != Status.scanning ? "Suivant" : "Scan...",
                    onPressed: state.status == Status.loading ||
                            state.status == Status.scanning
                        ? null
                        : () async => await launchScan(context),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
