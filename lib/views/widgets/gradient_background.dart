import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
        duration: const Duration(seconds: 10),
        primaryBeginGeometry: const AlignmentDirectional(0, 4),
        primaryEndGeometry: const AlignmentDirectional(0, 4),
        secondaryBeginGeometry: const AlignmentDirectional(2, 0),
        secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
        textDirectionForGeometry: TextDirection.rtl,
        reverse: true,
        primaryColors: const [
          Color(0xFF000000),
          Color(0xFF24213E),
          Color(0xFF39223F),
          Color(0xFF552441),
          Color(0xFFBC6538),
          Color(0xFFA9345D),
          Color(0xFFBF4487),
        ],
        secondaryColors: const [
          Color(0xFFC7267D),
          Color(0xFFA6397C),
          Color(0xFF943A6E),
          Color(0xFF943A6E),
          Color(0xFF3C0F38),
          Color(0xFF270D30),
          Color(0xFF110729),
        ],
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ));
  }
}
