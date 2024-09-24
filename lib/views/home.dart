import 'package:flutter/material.dart';
import 'package:songster/views/game.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 4, child: Center(child: Text("Songster"))),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.amber)),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Game(),
                    ),
                  ),
                  child: const Text("Jouer"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
