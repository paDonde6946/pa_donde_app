import 'package:google_maps_flutter/google_maps_flutter.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/response/busqueda_response.dart';
//---------------------------------------------------------------------

class RutaDestino {
  final List<LatLng> puntos;
  final double duracion;
  final double distancia;
  final Feature lugarFinal;

  RutaDestino({
    required this.puntos,
    required this.duracion,
    required this.distancia,
    required this.lugarFinal,
  });
}
