import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/pages/editar_perfil_pag.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/pages/inicio_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_sesion_pag.dart';
import 'package:pa_donde_app/ui/pages/recuperar_contrasenia_pag.dart';
import 'package:pa_donde_app/ui/pages/validar_inicio_sesion_pag.dart';
//---------------------------------------------------------------------

Map<String, WidgetBuilder> generarRutas() {
  final _rutas = <String, WidgetBuilder>{
    'login': (BuildContext context) => InicioSesionPag(),
    'inicio': (BuildContext context) => InicioPag(),
    'recuperarContrasenia': (BuildContext context) => RecuperarContraseniaPag(),
    'validarInicioSesion': (BuildContext context) => ValidarInicioSesion(),
    'editarPerfil': (BuildContext context) => EditarPerfilPag(),
  };

  return _rutas;
}
