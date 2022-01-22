import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/pages/acceso_gps_pag.dart';
import 'package:pa_donde_app/ui/pages/ruta_pag.dart';
//---------------------------------------------------------------------

class LoadingGPSPag extends StatefulWidget {
  const LoadingGPSPag({Key? key}) : super(key: key);

  @override
  State<LoadingGPSPag> createState() => _LoadingGPSPagState();
}

class _LoadingGPSPagState extends State<LoadingGPSPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.todoTienePermiso ? const RutaPag() : const AccesoGPSPag();
      },
    ));
  }
}
