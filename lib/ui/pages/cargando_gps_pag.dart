import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/acceso_gps_pag.dart';
import 'package:pa_donde_app/ui/pages/ruta_pag.dart';
import 'package:permission_handler/permission_handler.dart';

class CargandoGPSPag extends StatefulWidget {
  const CargandoGPSPag({Key? key}) : super(key: key);

  @override
  State<CargandoGPSPag> createState() => _CargandoGPSPagState();
}

class _CargandoGPSPagState extends State<CargandoGPSPag>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //Detectar cunado cambia el estado y valida que el GPS este activo
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context).push(navegarMapaFadeIn(context, RutaPag()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder(
            future: validarGpsyLocalizacion(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data),
                    const SizedBox(height: 20),
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ));
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Theme.of(context).primaryColor,
                ));
              }
            }));
  }

  Future validarGpsyLocalizacion(BuildContext context) async {
    final permisoGPS = await Permission.location.isGranted;

    final gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (permisoGPS && gpsActivo) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(navegarMapaFadeIn(context, RutaPag()));
      });
      return "";
    } else if (!permisoGPS) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(navegarMapaFadeIn(context, AccesoGPSPag()));
      });
      return "Es necesario el permiso de la localización";
    } else {
      return "Active el GPS";
    }
  }
}
