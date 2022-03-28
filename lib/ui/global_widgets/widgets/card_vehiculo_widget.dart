import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/widgets/card_background_widget.dart';
//---------------------------------------------------------------------

class CardVehiculo extends StatelessWidget {
  final Widget? icon;
  final Color color;
  final String marca;
  final bool validar;
  final String placa;

  const CardVehiculo(
      {Key? key,
      this.icon,
      required this.color,
      required this.marca,
      required this.validar,
      required this.placa})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardBackground(
      color: validar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(height: 10),
          Text(
            placa,
            style: TextStyle(color: color, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            marca,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
