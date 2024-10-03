import 'package:flutter/material.dart';

class PageTransition {
  static Route<T> material<T extends Widget>(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
    );
  }

  static Route<T> fadeIn<T extends Widget>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}
