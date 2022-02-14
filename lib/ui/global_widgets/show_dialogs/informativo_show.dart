import 'package:flutter/material.dart';

mostrarShowDialogInformativo({
  required BuildContext context,
  required String titulo,
  required String contenido,
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
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.yellow,
                  size: size.width * 0.3,
                ),
                const SizedBox(height: 20),
                Text(
                  titulo,
                  style: TextStyle(fontSize: size.width * 0.05),
                ),
              ],
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
              },
              child: Text(
                'ENTENDIDO',
                style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      });
}
