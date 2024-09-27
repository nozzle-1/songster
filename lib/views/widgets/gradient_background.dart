import 'dart:math';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

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
  late MeshGradientController _meshGradientController;

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

    _meshGradientController = MeshGradientController(points: [
      MeshGradientPoint(
        position: const Offset(
          0.2,
          0.6,
        ),
        color: const Color.fromARGB(255, 251, 0, 105),
      ),
      MeshGradientPoint(
        position: const Offset(
          0.4,
          0.5,
        ),
        color: const Color.fromARGB(255, 69, 18, 255),
      ),
      MeshGradientPoint(
        position: const Offset(
          0.7,
          0.4,
        ),
        color: const Color.fromARGB(255, 0, 255, 198),
      ),
      MeshGradientPoint(
        position: const Offset(
          0.4,
          0.9,
        ),
        color: const Color.fromARGB(255, 64, 255, 0),
      ),
    ], vsync: this)
      ..animateSequence(
        duration: const Duration(seconds: 5),
        sequences: [
          AnimationSequence(
            pointIndex: 0,
            newPoint: MeshGradientPoint(
              position: const Offset(0.9, 0.9),
              color: Colors.purple,
            ),
            interval: const Interval(
              0,
              0.7,
              curve: Curves.easeInOut,
            ),
          ),
          AnimationSequence(
            pointIndex: 1,
            newPoint: MeshGradientPoint(
              position: const Offset(0.1, 0.1),
              color: Colors.red,
            ),
            interval: const Interval(
              0,
              0.4,
              curve: Curves.ease,
            ),
          ),
        ],
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = SafeArea(
      top: false,
      child: widget.child,
    );

    return AnimatedMeshGradient(
      colors: primaryColors,
      options: AnimatedMeshGradientOptions(speed: 0.01),
      child: child,
    );
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
          child: child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
