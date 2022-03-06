import 'package:flutter/material.dart';

class BtnNaranjaIcon extends StatelessWidget {
  final Widget? titulo;
  final double? tamanioLetra;
  final void Function()? function;

  const BtnNaranjaIcon(
      {Key? key, this.titulo, this.tamanioLetra = 18.0, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Crear un boton de color anaranjado personalizado
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColorLight,
      ),
      width: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: IconButton(
        icon: titulo!,
        color: Colors.black87,
        onPressed: function,
      ),
    );
  }
}
