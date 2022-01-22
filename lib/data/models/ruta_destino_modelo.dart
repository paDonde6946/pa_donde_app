import 'package:google_maps_flutter/google_maps_flutter.dart';

class RutaDestino {
  final List<LatLng> puntos;
  final double duracion;
  final double distancia;

  RutaDestino({
    required this.puntos,
    required this.duracion,
    required this.distancia,
  });
}
