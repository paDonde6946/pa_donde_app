import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:google_maps_flutter/google_maps_flutter.dart';
//---------------------------------------------------------------------

class MapaView extends StatelessWidget {
  final LatLng initialLocalizacion;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapaView({
    Key? key,
    required this.initialLocalizacion,
    required this.polylines,
    required this.markers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapsBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocalizacion,
      zoom: 15,
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (pointerMoveEvent) =>
            mapaBloc.add(OnDetenerSeguirUsuario()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          polylines: polylines,
          onMapCreated: (controller) =>
              mapaBloc.add(OnMapaInicializadoEvent(controller)),
          onCameraMove: (position) => mapaBloc.centroMapa = position.target,
          markers: markers,
        ),
      ),
    );
  }
}
