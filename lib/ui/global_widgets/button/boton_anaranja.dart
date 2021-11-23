import 'package:flutter/material.dart';

class BtnAnaranja extends StatelessWidget {
  final String? titulo;
  final double? tamanioLetra;
  final void Function()? function;

  const BtnAnaranja({this.titulo, this.tamanioLetra = 18.0, this.function});

  @override
  Widget build(BuildContext context) {
    /// Crear un boton de color anaranjado personalizado
    return 
    
    Container(
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
