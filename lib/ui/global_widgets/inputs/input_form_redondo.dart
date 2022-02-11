import 'package:flutter/material.dart';

/* Método auxiliar para darle estilo al input */
InputDecoration inputDecorationRedondo(
    String label, String hint, BuildContext context, Color color) {
  final size = MediaQuery.of(context).size;
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color),
    ),
    hintStyle: TextStyle(
        color: Theme.of(context).primaryColor, fontSize: size.width * 0.04),
    hintText: hint,
  );
}
