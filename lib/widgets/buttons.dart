import 'package:flutter/material.dart';
import 'package:neon/neon.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    this.onPressed,
    required this.label,
  });
  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: ButtonStyle(
                elevation: WidgetStateProperty.all(2),
                backgroundColor:
                    WidgetStateProperty.all(Colors.white.withAlpha(70))),
            onPressed: onPressed,
            child: Neon(
              color: Colors.orange,
              fontSize: 20,
              font: NeonFont.Beon,
              flickeringText: false,
              text: label,
            ),
          ),
        ),
      ],
    );
  }
}
