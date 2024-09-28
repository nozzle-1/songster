import 'package:flutter/material.dart';
import 'package:metadata_god/src/bridge_generated.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HitsterCard extends StatefulWidget {
  final String hitsterUrl;
  final Metadata? metadata;

  const HitsterCard(
      {super.key, required this.hitsterUrl, required this.metadata});

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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: 220,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15)),
                    child: PrettyQrView.data(
                        data: widget.hitsterUrl,
                        decoration: const PrettyQrDecoration(
                          shape: PrettyQrSmoothSymbol(color: Colors.white),
                        ))),
              ],
            ),
          ),
          backBuilder: (_) => Card(
            margin: EdgeInsets.all(25),
            color: Color(0xAACE1CE8),
            child: Center(
              child: Column(
                children: [
                  Text(widget.metadata?.artist ?? ""),
                  Text("${widget.metadata?.title}"),
                  Text("${widget.metadata?.year}"),
                  if (widget.metadata?.picture?.data != null)
                    Image.memory(widget.metadata!.picture!.data,
                        height: 100, width: 100)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
