import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';

class SongsterScaffold extends StatelessWidget {
  final Widget body;

  const SongsterScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(actions: [
          if (Platform.isIOS)
            const Padding(
                padding: EdgeInsets.only(right: 10),
                child: AirPlayRoutePickerView(
                  tintColor: Colors.white,
                  activeTintColor: Colors.white,
                  backgroundColor: Colors.transparent,
                ))
        ]),
        body: body);
  }
}
