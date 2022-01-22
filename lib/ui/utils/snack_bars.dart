import 'package:flutter/material.dart';

/// Método que va a conterenizar el Snackbar en la pantalla
void _displaySnackBar(
    {@required BuildContext? context, @required SnackBar? snackBar}) {
  // ignore: deprecated_member_use
  Scaffold.of(context!).showSnackBar(snackBar!);
}

/// Método para personalizar la notificación de error, es aparece en la parte inferior de la pantalla
void customShapeSnackBar({@required BuildContext? context, String? titulo}) {
  final snackBar = SnackBar(
    content: Text(titulo.toString()),
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.red,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
    ),
    behavior: SnackBarBehavior.floating,
  );

  /// Método para tener el contexto del SnackBar donde se va a mostrar
  _displaySnackBar(context: context, snackBar: snackBar);
}
