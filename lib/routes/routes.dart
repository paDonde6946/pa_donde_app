import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/pages/agregar_vehiculo_pag.dart';
import 'package:pa_donde_app/ui/pages/editar_perfil_pag.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/pages/inicio_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_sesion_pag.dart';
import 'package:pa_donde_app/ui/pages/recuperar_contrasenia_pag.dart';
import 'package:pa_donde_app/ui/pages/validar_inicio_sesion_pag.dart';
//---------------------------------------------------------------------

Map<String, WidgetBuilder> generarRutas() {
  final _rutas = <String, WidgetBuilder>{
    'login': (_) => InicioSesionPag(),
    'inicio': (_) => const InicioPag(),
    'recuperarContrasenia': (_) => const RecuperarContraseniaPag(),
    'validarInicioSesion': (_) => ValidarInicioSesion(),
    'editarPerfil': (_) => EditarPerfilPag(),
    'agregarVehiculo': (_) => const AgregarVehiculo(),
  };

  return _rutas;
}
