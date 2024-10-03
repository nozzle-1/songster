import 'package:flutter/material.dart';
import 'package:songster/views/widgets/gradient_background.dart';

class SongsterScaffold extends StatelessWidget {
  final Widget body;

  const SongsterScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false, appBar: AppBar(), body: body);
  }
}
