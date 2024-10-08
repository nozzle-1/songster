import 'package:flutter/material.dart';
import 'package:neon/neon.dart';
import 'package:songster/ui/navigator_context.dart';
import 'package:songster/views/game.dart';
import 'package:songster/widgets/buttons.dart';
import 'package:songster/widgets/layout/scaffold.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<String> titleParts = ["Bienvenue", "sur", "Songster"];

  bool isTitle(String word) {
    return titleParts.indexOf(word) == titleParts.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return SongsterScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 4,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String part in titleParts)
                        Neon(
                          text: part,
                          color: Colors.pink,
                          fontSize: isTitle(part) ? 50 : 30,
                          font: NeonFont.Beon,
                          flickeringText: isTitle(part),
                        ),
                    ],
                  ))),
              MainButton(
                  label: "Jouer", onPressed: () => context.push(const Game()))
            ],
          ),
        ),
      ),
    );
  }
}
