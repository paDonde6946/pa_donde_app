part of 'mapas_bloc.dart';

class MapsState extends Equatable {
  final bool estaMapaInicializado;
  final bool seguirUsuario;
  final bool mostrarMiRuta;

  // Polylines
  final Map<String, Polyline> polylines;
  /*
    'mi_ruta': {
      id: polylineId Google,
      points: [ [latLng], [latLang].....],
      width: 3,
      color: black87,
    }
  */

  final Map<String, Marker> markers;

  const MapsState({
    this.estaMapaInicializado = false,
    this.seguirUsuario = true,
    this.mostrarMiRuta = false,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapsState copyWith({
    bool? estaMapaInicializado,
    bool? seguirUsuario,
    bool? mostrarMiRuta,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapsState(
        estaMapaInicializado: estaMapaInicializado ?? this.estaMapaInicializado,
        seguirUsuario: seguirUsuario ?? this.seguirUsuario,
        mostrarMiRuta: mostrarMiRuta ?? this.mostrarMiRuta,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );

  @override
  List<Object> get props =>
      [estaMapaInicializado, seguirUsuario, mostrarMiRuta, polylines, markers];
}
