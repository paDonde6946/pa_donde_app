import 'package:flutter/material.dart';

/// Método auxiliar para darle estilo al input
InputDecoration inputDecoration(
    String label, String hint, BuildContext context, Color color, Icon? icon) {
  final size = MediaQuery.of(context).size;
  return InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: color),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: color),
    ),
    labelStyle: TextStyle(
        // fontFamily: Tipografia.light,
        color: color,
        fontSize: size.height * 0.02),
    labelText: label,
    suffixIcon: icon,
    hintStyle: TextStyle(color: color),
    hintText: hint,
  );
}
