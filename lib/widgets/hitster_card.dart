import 'package:flutter/material.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:songster/song/hitster_song.dart';

class HitsterCard extends StatefulWidget {
  final HitsterSong song;

  const HitsterCard({super.key, required this.song});

  @override
  State<HitsterCard> createState() => _HitsterCardState();
}

class _HitsterCardState extends State<HitsterCard>
    with TickerProviderStateMixin {
  final GlobalKey<PageFlipBuilderState> pageFlipKey =
      GlobalKey<PageFlipBuilderState>();

  late final AnimationController _controller;
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

    _controller.value = 0;
    _controller.forward();
    super.initState();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                      data: widget.song.hitsterUrl,
                      decoration: const PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(color: Colors.white),
                      ))),
            ),
          ),
          backBuilder: (_) => Card(
            margin: const EdgeInsets.all(25),
            // color: Color(0xAACE1CE8),
            color: Colors.white.withAlpha(70),

            child: Center(
              child: SizedBox(
                height: 220,
                width: 220,
                child: Builder(builder: (context) {
                  if (widget.song.picture.isNotEmpty) {
                    return Image.memory(
                      widget.song.picture,
                    );
                  }
                  return Container(
                    color: Colors.black,
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
