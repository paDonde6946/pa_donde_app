import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pa_donde_app/bloc/mapa/mapa_bloc.dart';
import 'package:pa_donde_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_ubicacion.dart';
import 'dart:async';

import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';

class RutaPag extends StatefulWidget {
  RutaPag({Key? key}) : super(key: key);

  @override
  _RutaPagState createState() => _RutaPagState();
}

class _RutaPagState extends State<RutaPag> {
  @override
  void initState() {
    // Acceso al bloc
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _fabHeight = 0;
  final double _initFabHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
              builder: (_, state) => crearMapa(state)),
          SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const BtnUbicacion())),
          SlidingUpPanel(
            maxHeight: 300,
            minHeight: 100,
            parallaxEnabled: false,
            parallaxOffset: .5,
            panelBuilder: (sc) => Center(
              child: SizedBox(
                width: 200,
                child: BtnAnaranja(
                  titulo: "Marcar Recorrido",
                  function: () {
                    mapaBloc.add(OnMarcarRecorrido());
                    mapaBloc.add(OnSeguirUbicacion());
                  },
                ),
              ),
            ),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (300 - 100) + _initFabHeight;
            }),
          ),
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion!) return const Text("Ubicando...");

    final cameraPosition = CameraPosition(target: state.ubicacion!, zoom: 15);

    var mapaBloc = BlocProvider.of<MapaBloc>(context);

    // Emite cada vez que recibe una nueva ubicacion
    mapaBloc.add(OnNuevaUbicacion(state.ubicacion!));

    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: cameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: mapaBloc.iniMapa,
      polylines: mapaBloc.state.polylines!.values.toSet(),
    );
  }
}
