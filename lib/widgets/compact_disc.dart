import 'dart:math';
import 'package:flutter/material.dart';

class CompactDisc extends StatelessWidget {
  const CompactDisc({
    super.key,
    required this.coverUrl,
  });

  final String? coverUrl;
  final Color diskColor = Colors.black;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
            clipper: const HoleClipper(holeRadiusRatio: 0.35),
            child: ClipOval(
              child: Container(
                height: 230,
                width: 230,
                color: Colors.grey.shade500,
              ),
            )),
        ClipPath(
            clipper: const HoleClipper(holeRadiusRatio: 0.35),
            child: ClipOval(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.grey.shade500,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipPath(
            clipper: const HoleClipper(holeRadiusRatio: 0.2),
            child: ClipOval(
              child: Builder(builder: (context) {
                if (coverUrl == null) {
                  return Container(
                    color: diskColor,
                    height: 225,
                    width: 225,
                  );
                }
                return Image.network(coverUrl!,
                    height: 225, width: 225, fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: diskColor,
                    height: 225,
                    width: 225,
                  );
                });
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class HoleClipper extends CustomClipper<Path> {
  const HoleClipper({
    this.holeRadiusRatio = 0.5,
  });

  final double holeRadiusRatio;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holeSize = min(size.width, size.height) * holeRadiusRatio;
    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: holeSize,
        height: holeSize,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant HoleClipper oldClipper) =>
      oldClipper.holeRadiusRatio != holeRadiusRatio;
}
