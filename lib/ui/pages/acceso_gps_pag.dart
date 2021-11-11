import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/cargando_gps_pag.dart';
import 'package:pa_donde_app/ui/pages/ruta_pag.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGPSPag extends StatefulWidget {
  @override
  State<AccesoGPSPag> createState() => _AccesoGPSPagState();
}

class _AccesoGPSPagState extends State<AccesoGPSPag>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // Pendiente de los cambios de los estados de la misma APK
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // Pendiente de los cambios de los estados de la misma APK
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //Detectar cunado cambia el estado y
    if (state == AppLifecycleState.resumed) {
      if (await Permission.location.isGranted) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context)
              .push(navegarMapaFadeIn(context, CargandoGPSPag()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: contenedorBody()),
    );
  }

  Widget contenedorBody() {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Es necesario el GPS para usar esta app !"),
        SizedBox(height: size.height * 0.04),
        SizedBox(
          width: size.width * 0.5,
          child: BtnAnaranja(
            titulo: "Solicitar Acceso",
            function: () async {
              final status = await Permission.location.request();
              accesoGPS(status);
            },
          ),
        )
      ],
    );
  }

  // Valida que el APK tenga permisos de localizacion para poder usar el GPS
  void accesoGPS(PermissionStatus status) {
    switch (status) {
      //  Si tiene los permisos permitidos
      case PermissionStatus.granted:
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context).push(navegarMapaFadeIn(context, RutaPag()));
        });
        break;
      //Si no cumple con los permisos
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}
