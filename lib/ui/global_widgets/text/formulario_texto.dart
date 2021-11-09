import 'package:flutter/material.dart';

Text textoRegular(
    {required String texto,
    bool negrilla = false,
    required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  return Text(
    texto,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        color: Colors.black,
        // fontFamily: Tipografia.regular,
        fontSize: size.width * 0.045,
        fontWeight: (negrilla) ? FontWeight.bold : FontWeight.normal),
  );
}
