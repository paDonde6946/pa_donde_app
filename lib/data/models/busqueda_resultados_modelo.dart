import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class BusquedaResultado {
  // Valida si el usuario cancelo la busqueda
  final bool? cancelo;

  // Valida si el usuario va a buscar manualmente la direccion
  final bool? manual;

  final LatLng? posicion;
  final String? nombreDestino;
  final String? descripcion;

  BusquedaResultado({
    @required this.cancelo,
    this.manual,
    this.posicion,
    this.nombreDestino,
    this.descripcion,
  });
}
