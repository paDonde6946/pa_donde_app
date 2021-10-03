import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/pages/inicio_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_sesion_pag.dart';
import 'package:pa_donde_app/ui/pages/recuperar_contrasenia_pag.dart';
//---------------------------------------------------------------------

Map<String, WidgetBuilder> generarRutas() {
  final _rutas = <String, WidgetBuilder>{
    'login': (_) => InicioSesionPag(),
    'inicio': (_) => InicioPag(),
    'recuperarContrasenia': (_) => RecuperarContraseniaPag()
  };

  return _rutas;
}
