import 'package:flutter/material.dart';

/// Para poner una animacion en la navegacion de un widget
navegarMapaFadeIn(BuildContext context, Widget page) {
  return PageRouteBuilder<Widget>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
            child: child,
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)));
      });
}
