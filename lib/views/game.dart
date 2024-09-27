import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:songster/widgets/buttons.dart';
import 'package:songster/widgets/qr_code_scanner.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  final flipController = FlipCardController();
  final pageFlipKey = GlobalKey<PageFlipBuilderState>();
  bool _isScanning = false;

  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    setState(() {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Builder(builder: (context) {
                    if (_isScanning) {
                      return Card(
                        margin: const EdgeInsets.all(25),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: QrCodeScanner(
                              onDetect: (qrCodeValue) {
                                setState(() {
                                  _isScanning = false;
                                  _controller.value = 0;
                                  _controller.forward();
                                });
                                print("BARCODE VALUE $qrCodeValue");
                              },
                            )),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        pageFlipKey.currentState?.flip();
                      },
                      child: ScaleTransition(
                        scale: _animation,
                        child: PageFlipBuilder(
                          key: pageFlipKey,
                          frontBuilder: (_) => Card(
                            margin: const EdgeInsets.all(25),
                            color: Colors.white,
                            child: QrImageView(
                              data: 'www.hitstergame.com/fr/00001',
                              version: QrVersions.auto,
                            ),
                          ),
                          backBuilder: (_) => const Card(
                            margin: EdgeInsets.all(25),
                            color: Colors.green,
                            child: Center(
                              child: Text("Test"),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: MainButton(
                label: "Scanner",
                onPressed: () {
                  setState(() {
                    //_controller.value = 1;

                    // _controller.reverse();
                    _isScanning = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
