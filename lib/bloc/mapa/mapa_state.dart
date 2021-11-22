part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool? mapaListo;
  final bool? dibujarRecorrido;
  final bool? seguirUbicacion;

  final LatLng? ubicacionCentral;

  // Polylines
  final Map<String, Polyline>? polylines;

  MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = true,
    this.ubicacionCentral,
    Map<String, Polyline>? polylines,
  }) : polylines = polylines ?? Map();

  MapaState copyWith({
    bool? mapalisto,
    bool? dibujarRecorrido,
    bool? seguirUbicacion,
    LatLng? ubicacionCentral,
    Map<String, Polyline>? polylines,
  }) =>
      MapaState(
        mapaListo: mapaListo ?? this.mapaListo,
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
        polylines: polylines ?? this.polylines,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
      );
}
