import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void _displaySnackBar(
    {@required BuildContext? context, @required SnackBar? snackBar}) {
  Scaffold.of(context!).showSnackBar(snackBar!);
}

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

  _displaySnackBar(context: context, snackBar: snackBar);
}
