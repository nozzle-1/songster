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

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.size = ButtonSize.small,
    this.isLoading = false,
  });
  final void Function()? onPressed;
  final IconData icon;
  final ButtonSize size;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton.filled(
        iconSize: size == ButtonSize.big ? 48 : 24,
        onPressed: onPressed,
        icon: Builder(builder: (context) {
          if (isLoading) {
            return const CircularProgressIndicator(
              color: Colors.white,
            );
          }
          return Icon(
            icon,
          );
        }),
        style: ElevatedButton.styleFrom(
          fixedSize: Size.square(size == ButtonSize.big ? 64 : 48),
          shape: const CircleBorder(),
          backgroundColor: Colors.white.withAlpha(70),
        ),
      ),
    );
  }
}

enum ButtonSize { small, big }
