import 'package:flutter/material.dart';

class BtnSinContorno extends StatelessWidget {
  final String? titulo;
  final double? tamanioLetra;
  final void Function()? function;
  final IconData? icon;

  const BtnSinContorno({
    Key? key,
    this.titulo,
    this.tamanioLetra = 18.0,
    this.function,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Crear un boton de color anaranjado personalizado
    return GestureDetector(
      onTap: function,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          // const SizedBox(width: 3),
          Text(
            titulo.toString(),
            style: TextStyle(fontSize: tamanioLetra, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
