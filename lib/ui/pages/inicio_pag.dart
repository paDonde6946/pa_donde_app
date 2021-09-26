import 'package:flutter/material.dart';

class InicioPag extends StatefulWidget {
  InicioPag({Key? key}) : super(key: key);

  @override
  _InicioPagState createState() => _InicioPagState();
}

class _InicioPagState extends State<InicioPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("INICIO"),
      ),
    );
  }
}
