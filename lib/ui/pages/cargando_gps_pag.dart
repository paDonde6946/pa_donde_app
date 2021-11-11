import 'package:flutter/material.dart';

class CargandoGPSPag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: validarGpsyLocalizacion(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).primaryColor,
              ));
            }));
  }

  Future validarGpsyLocalizacion(BuildContext context) async {
    //TODO: PERMISO GPS
    //TODO: GPS ESTA ACTIVO

    await Future.delayed(Duration(microseconds: 1000));

    Navigator.pushReplacementNamed(context, 'ruta');
  }
}
