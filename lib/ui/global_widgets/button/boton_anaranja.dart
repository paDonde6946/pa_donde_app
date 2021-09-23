import 'package:flutter/material.dart';

class BtnAnaranja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColorLight,
      ),
      width: 150,
      margin: EdgeInsets.only(bottom: 10),
      child: IconButton(
        icon: Text(
          "INICIAR SESIÓN",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.black87,
        onPressed: () {},
      ),
    );
  }
}
