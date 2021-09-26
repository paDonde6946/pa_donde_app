import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/services/autencicacion_service.dart';

class BtnAnaranja extends StatelessWidget {
  final String? titulo;
  final double? tamanioLetra;
  final void Function()? function;

  BtnAnaranja({Key? key, this.titulo, this.tamanioLetra = 18.0, this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColorLight,
      ),
      width: 150,
      margin: const EdgeInsets.only(bottom: 10),
      child: IconButton(
        icon: Text(
          titulo.toString(),
          style: TextStyle(fontSize: tamanioLetra, color: Colors.white),
        ),
        color: Colors.black87,
        onPressed: function,
      ),
    );
  }
}
