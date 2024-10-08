import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomShaderBuilder extends StatefulWidget {
  final Widget? child;
  const CustomShaderBuilder({super.key, this.child});

  @override
  State<CustomShaderBuilder> createState() => _CustomShaderBuilderState();
}

class _CustomShaderBuilderState extends State<CustomShaderBuilder> {
  late Timer timer;
  double delta = 0;
  FragmentShader? shader;

  void loadMyShader() async {
    var program = await FragmentProgram.fromAsset('shaders/test.frag');
    shader = program.fragmentShader();
    setState(() {
      print('TEST');
      // trigger a repaint
    });

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        delta += 1 / 60;
        // print('DELTA $delta');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyShader();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return CustomPaint(
          willChange: true, painter: ShaderPainter(shader!, delta));
    }
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;

  ShaderPainter(FragmentShader fragmentShader, this.time)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
