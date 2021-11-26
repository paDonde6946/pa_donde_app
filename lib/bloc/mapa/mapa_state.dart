part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool? mapaListo;
  final bool? dibujarRecorrido;
  final bool? seguirUbicacion;

  final LatLng? ubicacionCentral;

  // Polylines
  final Map<String, Polyline>? polylines;

  // Manejo de los marcadores
  final Map<String, Marker> markers;

  MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = true,
    this.ubicacionCentral,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  })  : polylines = polylines ?? {},
        markers = markers ?? {};

  MapaState copyWith({
    bool? mapalisto,
    bool? dibujarRecorrido,
    bool? seguirUbicacion,
    LatLng? ubicacionCentral,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapaState(
        // ignore: unnecessary_this
        mapaListo: mapaListo ?? this.mapaListo,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
      );
}
