import 'package:flutter/material.dart';

mostrarShowDialogConfirmar({
  required BuildContext context,
  required String titulo,
  required String contenido,
  required String paginaRetorno,
}) {
  final size = MediaQuery.of(context).size;

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Text(
              titulo,
              style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: Theme.of(context).primaryColorLight),
            ),
          ),
          elevation: 2,
          content: Text(
            contenido,
            style: TextStyle(fontSize: size.width * 0.043),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, paginaRetorno);
              },
              child: Text(
                'CONTINUAR',
                style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      });
}
