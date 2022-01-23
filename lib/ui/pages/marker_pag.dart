import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/markers/markers.dart';
//---------------------------------------------------------------------

class MarkerPage extends StatelessWidget {
  const MarkerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        color: Colors.red,
        height: 150,
        width: 350,
        child: CustomPaint(
          painter: FinallMarkerPainter(
            destino: 'Mi casa hola mundo la igleseiA resto biend',
            kilometros: 80,
            context: context,
            duracion: 5,
          ),
        ),
      ),
    ));
  }
}
