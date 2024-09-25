import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:songster/widgets/qr_code_scanner.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Game> {
  final flipController = FlipCardController();
  final pageFlipKey = GlobalKey<PageFlipBuilderState>();
  bool _isScanning = false;

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
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.amber)),
                      onPressed: () {
                        setState(() {
                          _isScanning = true;
                        });
                      },
                      child: const Text("Scanner"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
