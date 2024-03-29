import 'package:flutter/material.dart';

mostrarShowDialogValidar({
  required BuildContext context,
  required String titulo,
  required String contenido,
  required IconData icono,
  required void Function()? funtionContinuar,
  void Function()? funtionCancelar,
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: size.width * 0.25),
              Text(
                contenido,
                style: TextStyle(fontSize: size.width * 0.043),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: funtionCancelar ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(
                'CANCELAR',
                style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: funtionContinuar,
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
