import 'package:flutter/material.dart';

mostrarShowDialogCargando({@required BuildContext? context, String? titulo}) {
  final size = MediaQuery.of(context!).size;
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
              titulo!,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          elevation: 2,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.22),
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              strokeWidth: 8,
            ),
          ),
        );
      });
}
