import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/pages/acceso_gps_pag.dart';
import 'package:pa_donde_app/ui/pages/agregar_vehiculo_pag.dart';
import 'package:pa_donde_app/ui/pages/cargando_gps_pag.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';
import 'package:pa_donde_app/ui/pages/editar_perfil_pag.dart';
import 'package:pa_donde_app/ui/pages/editar_vehiculo_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_sesion_pag.dart';
import 'package:pa_donde_app/ui/pages/marker_pag.dart';
import 'package:pa_donde_app/ui/pages/market.dart';
import 'package:pa_donde_app/ui/pages/recuperar_contrasenia_pag.dart';
import 'package:pa_donde_app/ui/pages/ruta_pag.dart';
import 'package:pa_donde_app/ui/pages/validar_inicio_sesion_pag.dart';
//---------------------------------------------------------------------

Map<String, WidgetBuilder> generarRutas() {
  final _rutas = <String, WidgetBuilder>{
    'login': (_) => const InicioSesionPag(),
    'inicio': (_) => const InicioPag(),
    'recuperarContrasenia': (_) => const RecuperarContraseniaPag(),
    'validarInicioSesion': (_) => const ValidarInicioSesion(),
    'editarPerfil': (_) => EditarPerfilPag(
          callbackFunction: () {},
        ),
    'agregarVehiculo': (_) => const AgregarVehiculo(),
    'ruta': (_) => const RutaPag(),
    'accesoGPS': (_) => const AccesoGPSPag(),
    'cargandpGPS': (_) => const CargandoGPSPag(),
    'editarVehiculo': (_) => const EditarVehiculo(vehiculo: null),
    'marker': (_) => const MarkerPage(),
    'prueba': (_) => const PruebaPag(),
    'chat': (_) => ChatPag()
  };

  return _rutas;
}
