import 'package:flutter/material.dart';

/* Método auxiliar para darle estilo al input */
InputDecoration inputDecorationElevado(
    String label, String hint, BuildContext context, Color color) {
  final size = MediaQuery.of(context).size;
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    ),
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(
        color: Theme.of(context).primaryColor, fontSize: size.width * 0.03),
    hintText: hint,
  );
}
