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
    // labelStyle: TextStyle(
    //     color: Theme.of(context).primaryColor, fontSize: size.height * 0.015),
    // labelText: label,
    hintStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
    hintText: hint,
  );
}
