import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/cargando_gps_pag.dart';
//---------------------------------------------------------------------

class AccesoGPSPag extends StatefulWidget {
  const AccesoGPSPag({Key? key}) : super(key: key);

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
    //Detectar cunado cambia el estado
    if (state == AppLifecycleState.resumed) {
      if (await Permission.location.isGranted) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context)
              .push(navegarMapaFadeIn(context, const CargandoGPSPag()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return !state.estaGpsHabilitado
              ? _habilitarGpsMensage()
              : _contenedorBody();
        },
      )
          // _contenedorBody(),
          // child: _habilitarGpsMensage(),
          ),
    );
  }

  /// Contiene el boton para poder solicitar acceso al GPS
  Widget _contenedorBody() {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "PaDonde recopila datos de ubicación para permitir el seguimiento del estado físico cuando el aplicativo esta en uso o en segundo plano. Para poder crear servicios y trazar rutas.",
          style: TextStyle(fontSize: size.width * 0.04),
        ),
        SizedBox(height: size.height * 0.04),
        SizedBox(
          width: size.width * 0.5,
          child: BtnAnaranja(
            titulo: "Solicitar Acceso",
            function: () async {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.preguntarGpsAcceso();
            },
          ),
        )
      ],
    );
  }

  Widget _habilitarGpsMensage() {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
            image: const AssetImage("img/logo/logo_PaDonde.png"),
            width: size.width * 0.5),
        SizedBox(height: size.height * 0.05),
        Text(
          "Debe de habilitar el GPS...",
          style: TextStyle(fontSize: size.width * 0.045),
        ),
      ],
    );
  }
}
