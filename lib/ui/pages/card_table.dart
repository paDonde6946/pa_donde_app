import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';

class CardTable extends StatelessWidget {
  List<Vehiculo> vehiculos = [
    Vehiculo(pPlaca: "JVR342", pMarca: "RENAULT"),
    Vehiculo(pPlaca: "LHK864", pMarca: "HYUNDAI"),
    Vehiculo(pPlaca: "WQF298", pMarca: "FORD"),
    // Vehiculo(pPlaca: "UYV469", pMarca: "MERCEDEZ"),
  ];

  @override
  Widget build(BuildContext context) {
    return Table(children: funcionPrueba());
  }

  List<TableRow> funcionPrueba() {
    int count = 0;
    List<TableRow> arreglo = [];
    List<Widget> arreglo2 = [];

    for (int i = 0; i < vehiculos.length; i++) {
      arreglo2.add(_SigleCard(
        color: Colors.black,
        text: vehiculos[i].placa,
        validar: true,
      ));
      count++;
      if (count == 2) {
        arreglo.add(TableRow(children: arreglo2));
        count = 0;
        arreglo2 = [];
      }
    }

    if (arreglo2.isNotEmpty) {
      arreglo2.add(_SigleCard(
        color: Colors.black,
        text: "",
        validar: false,
      ));

      arreglo.add(TableRow(children: arreglo2));
    }

    return arreglo;
  }
}

class _SigleCard extends StatelessWidget {
  final IconData? icon;
  final Color color;
  final String text;
  final bool validar;

  const _SigleCard(
      {Key? key,
      this.icon,
      required this.color,
      required this.text,
      required this.validar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
        color: validar,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 55,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(color: color, fontSize: 18),
            )
          ],
        ));
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;
  final bool color;

  const _CardBackground({Key? key, required this.child, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: color ? Colors.grey : Colors.transparent,
              offset: const Offset(0.7, 1.0), //(x,y)
              blurRadius: 9.0,
            ),
          ],
          color: color ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 180,
            child: child,
          ),
        ),
      ),
    );
  }
}
