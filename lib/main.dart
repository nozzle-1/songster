import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:minio/minio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:songster/ui/page_transition.dart';
import 'package:songster/ui/theme.dart';
import 'package:songster/views/game.dart';
import 'package:songster/views/home.dart';
import 'package:songster/views/widgets/gradient_background.dart';

final minio = Minio(
    endPoint: const String.fromEnvironment("S3_ENDPOINT"),
    accessKey: const String.fromEnvironment("S3_ACCESS_KEY"),
    secretKey: const String.fromEnvironment("S3_SECRET_KEY"));

const bucket = String.fromEnvironment("S3_BUCKET");

void main() {
  MetadataGod.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Songster',
      theme: theme,
      routes: {
        '/': (context) => Home(),
        '/game': (context) => const Game(),
      },
      builder: (context, child) {
        return GradientBackground(
          child: child!,
        );
      },
    );
  }
}
