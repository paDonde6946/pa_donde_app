part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool? mapaListo;
  final bool? dibujarRecorrido;
  final bool? seguirUbicacion;
  // Polylines
  final Map<String, Polyline>? polylines;

  MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = true,
    Map<String, Polyline>? polylines,
  }) : polylines = polylines ?? Map();

  MapaState copyWith({
    bool? mapalisto,
    bool? dibujarRecorrido,
    bool? seguirUbicacion,
    Map<String, Polyline>? polylines,
  }) =>
      MapaState(
        mapaListo: mapaListo ?? this.mapaListo,
        polylines: polylines ?? this.polylines,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
      );
}
