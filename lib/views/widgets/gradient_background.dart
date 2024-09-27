import 'dart:math';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatefulWidget {
  final Widget child;
  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with TickerProviderStateMixin {
  Alignment begin = Alignment.bottomRight;
  Alignment end = Alignment.topLeft;
  late AnimationController _controller;

  final List<Color> primaryColors = const [
    Color.fromARGB(255, 27, 25, 43),
    Color(0xFF24213E),
    Color(0xFF39223F),
    Color(0xFF552441),
  ];

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: begin,
          end: end,
          transform: GradientRotation(_controller.value * 2 * pi),
          stops: const [
            0.0,
            0.33,
            0.88,
            1.0,
          ],
          colors: primaryColors,
        )),
        child: SafeArea(
          top: false,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
