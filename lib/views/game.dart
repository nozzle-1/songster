import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:just_audio/just_audio.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:minio/minio.dart';
import 'package:songster/widgets/buttons.dart';
import 'package:songster/widgets/hitster_card.dart';
import 'package:songster/widgets/qr_code_scanner.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

//TODO: exporter dans un repository
final minio = Minio(
    endPoint: const String.fromEnvironment("S3_ENDPOINT"),
    accessKey: const String.fromEnvironment("S3_ACCESS_KEY"),
    secretKey: const String.fromEnvironment("S3_SECRET_KEY"));
const bucket = String.fromEnvironment("S3_BUCKET");

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  final flipController = FlipCardController();
  bool _isScanning = false;
  bool _isPlaying = false;
  final _player = AudioPlayer(); // Create a player

  String _qrCodeValue = "";

  Metadata? _metadata;

  @override
  void initState() {
    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
    super.initState();
  }

  bool get _showCard => _qrCodeValue.isNotEmpty;

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
                                //TODO: checker ici qu'il s'agit d'une URL valide
                                setState(() {
                                  _isScanning = false;
                                  _qrCodeValue = qrCodeValue;
                                });
                                print("BARCODE VALUE $qrCodeValue");
                              },
                            )),
                      );
                    }
                    if (_showCard) {
                      return HitsterCard(
                          hitsterUrl: _qrCodeValue, metadata: _metadata);
                    }

                    return const SizedBox();
                  }),
                ),
              ),
            ),
            if (_showCard)
              IconButton.filled(
                onPressed: () async {
                  if (_isPlaying) {
                    await _player.stop();
                    return;
                  }

                  final splitted = _qrCodeValue.split("/");
                  final c = int.parse(splitted[2]);
                  var padded = "$c".padLeft(5, "0");
                  var fileName = "$padded.m4a";
                  var val = await minio.presignedGetObject(
                      bucket, 'fr/$fileName',
                      expires: 60 * 15);

                  final appDir = await syspaths.getTemporaryDirectory();
                  final filePath = '${appDir.path}/$fileName';
                  File file = File(filePath);
                  var songStream =
                      await minio.getObject(bucket, 'fr/$fileName');

                  var songBytes = await songStream.toList();
                  for (var songByte in songBytes) {
                    await file.writeAsBytes(songByte, mode: FileMode.append);
                  }

                  _metadata = await MetadataGod.readMetadata(file: filePath);

                  final duration = await _player.setUrl(val);
                  await _player.setVolume(1.0);
                  await _player.play();
                },
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white.withAlpha(70),
                ),
              ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: MainButton(
                label: "Scanner",
                onPressed: () async {
                  await _player.stop();
                  setState(() {
                    _isScanning = true;
                    _qrCodeValue = "";
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
