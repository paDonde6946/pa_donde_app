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
    'login': (_) => const InicioSesionPag(),
    'inicio': (_) => InicioPag(),
    'recuperarContrasenia': (_) => const RecuperarContraseniaPag(),
    'valiarInicioSesion': (_) => const ValidarInicioSesion(),
    'editarPerfil': (_) => EditarPerfilPag(),
  };

  return _rutas;
}
