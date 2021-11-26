import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pa_donde_app/bloc/busqueda/busqueda_bloc.dart';

import 'package:pa_donde_app/bloc/mapa/mapa_bloc.dart';

import 'package:pa_donde_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:pa_donde_app/data/services/trafico_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_ubicacion.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/barra_busqueda_destino_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/barra_busqueda_inicio_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/marcador_manual_widget.dart';
import 'dart:async';

import 'package:polyline_do/polyline_do.dart' as Poly;

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
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context).state.historial;

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
              builder: (_, state) => crearMapa(state)),
          SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const BtnUbicacion())),
          MarcardorManual(),
          SlidingUpPanel(
            maxHeight: 200,
            minHeight: 150,
            parallaxEnabled: true,
            parallaxOffset: .5,
            panelBuilder: (sc) => Column(children: [
              BuscadorBarraInicio(
                  busquedaDireccion: (busquedaBloc.isEmpty)
                      ? 'Origen'
                      : busquedaBloc[0].nombreDestino!),
              const BuscadorBarraDestino(),
              btnContinuar()
            ]),
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

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, _) {
        return GoogleMap(
          mapType: MapType.terrain,
          initialCameraPosition: cameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: mapaBloc.iniMapa,
          polylines: mapaBloc.state.polylines!.values.toSet(),
          markers: mapaBloc.state.markers.values.toSet(),
          onCameraMove: (cameraPosition) {
            mapaBloc.add(OnMovioMapa(cameraPosition.target));
          },
        );
      },
    );
  }

  Widget btnContinuar() {
    final size = MediaQuery.of(context).size;

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    return Column(
      children: [
        SizedBox(height: size.height * 0.02),
        SizedBox(
          width: size.width * 0.9,
          child: BtnAnaranja(
              titulo: 'Continuar',
              function: () async {
                // final traficoServicio = TraficoServicio();
                // final inicio =
                //     BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
                // final destino = BlocProvider.of<MapaBloc>(context).state.ubicacionCentral;

                // final ruta = await traficoServicio.getCoordsInicioYFin(
                //     inicio!, destino!);

                // final geometry = ruta.routes![0].geometry;
                // final duracion = ruta.routes![0].duration;
                // final distancia = ruta.routes![0].distance;

                // final points =
                //     Poly.Polyline.Decode(encodedString: geometry!, precision: 6)
                //         .decodedCoords;

                // final List<LatLng> rutaCoords =
                //     points.map((point) => LatLng(point[0], point[1])).toList();

                // mapaBloc.add(OnCrearRutaInicioDestino(
                //     rutaCoords, distancia!, duracion!));
              }),
        ),
      ],
    );
  }
}
