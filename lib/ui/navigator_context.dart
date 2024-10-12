import 'package:flutter/material.dart';
import 'package:songster/ui/page_transition.dart';

extension NavigatorContext on BuildContext {
  Future<T?> push<T extends Object?>(Widget page) {
    return Navigator.of(this).push(PageTransition.material(page));
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop();
  }
}
