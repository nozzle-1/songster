import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:songster/song/hitster_song.dart';
import 'package:songster/widgets/compact_disc.dart';

class HitsterCard extends StatefulWidget {
  final HitsterSong? song;
  final String hitsterUrl;

  const HitsterCard({super.key, required this.hitsterUrl, required this.song});

  @override
  State<HitsterCard> createState() => _HitsterCardState();
}

class _HitsterCardState extends State<HitsterCard>
    with TickerProviderStateMixin {
  final GlobalKey<PageFlipBuilderState> pageFlipKey =
      GlobalKey<PageFlipBuilderState>();

  late final AnimationController _controller;
  late final AnimationController _discRotationController;

  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    );

    _discRotationController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();

    _controller.value = 0;
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _discRotationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          pageFlipKey.currentState?.flip();
        },
        child: ScaleTransition(
            scale: _animation,
            child: PageFlipBuilder(
              key: pageFlipKey,
              frontBuilder: (_) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 0,
                margin: const EdgeInsets.all(25),
                color: Colors.white.withAlpha(70),
                child: Center(
                  child: Container(
                      height: 220,
                      width: 220,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15)),
                      child: PrettyQrView.data(
                          data: widget.hitsterUrl,
                          decoration: const PrettyQrDecoration(
                            shape: PrettyQrSmoothSymbol(color: Colors.white),
                          ))),
                ),
              ),
              backBuilder: (_) {
                return Card(
                  margin: const EdgeInsets.all(25),
                  // color: Color(0xAACE1CE8),
                  color: Colors.white.withAlpha(70),

                  child: Builder(builder: (context) {
                    if (widget.song == null) {
                      return const SizedBox();
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24, left: 16, right: 16),
                          child: AutoSizeText(
                            widget.song?.artist ?? "",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: AutoSizeText(widget.song?.title ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white)),
                        ),
                        ClipRect(
                          child: Align(
                            heightFactor: 0.5,
                            widthFactor: 1,
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: AnimatedBuilder(
                                  animation: _discRotationController,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: _discRotationController.value *
                                          2 *
                                          pi,
                                      child: CompactDisc(
                                          coverUrl: widget.song?.coverUrl),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                );
              },
            )));
  }
}
