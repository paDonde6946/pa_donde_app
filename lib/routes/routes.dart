import 'package:flutter/material.dart';

import 'package:pa_donde_app/ui/inicio_sesion_pag.dart';

Map<String, WidgetBuilder> generarRutas() {
  final _rutas = <String, WidgetBuilder>{
    'login': (_) => InicioSesionPag(),
  };

  return _rutas;
}
