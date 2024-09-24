import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Card(
                  margin: EdgeInsets.all(25),
                  color: Colors.pink,
                ),
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
                        backgroundColor: WidgetStateProperty.all(Colors.amber)),
                    onPressed: () => print("SCAAAAAAAN"),
                    child: const Text("Scanner"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
