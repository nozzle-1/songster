import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:songster/ui/theme.dart';
import 'package:songster/views/game.dart';
import 'package:songster/views/home.dart';
import 'package:songster/views/widgets/gradient_background.dart';

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
