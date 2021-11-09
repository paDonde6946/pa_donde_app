import 'dart:ui';
import 'package:flutter/material.dart';

class CardBackground extends StatelessWidget {
  final Widget child;
  final bool color;

  const CardBackground({Key? key, required this.child, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: color ? Colors.grey : Colors.transparent,
              offset: const Offset(0.7, 1.0), //(x,y)
              blurRadius: 9.0,
            ),
          ],
          color: color ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SizedBox(
            height: 160,
            child: child,
          ),
        ),
      ),
    );
  }
}
