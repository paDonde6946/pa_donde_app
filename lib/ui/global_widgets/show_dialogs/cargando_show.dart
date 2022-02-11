import 'package:flutter/material.dart';

mostrarShowDialogCargando({@required BuildContext? context, String? titulo}) {
  final size = MediaQuery.of(context!).size;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          content: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        child: SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 8,
                              color: Theme.of(context).primaryColor,
                            ),
                            width: size.height * 0.08,
                            height: size.height * 0.08),
                        padding: const EdgeInsets.only(bottom: 16)),
                    Padding(
                        child: Text(
                          'Porfavor espere ...',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColorLight),
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.only(bottom: 4)),
                    Text(
                      titulo!,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    )
                  ])),
        );
      });
}
