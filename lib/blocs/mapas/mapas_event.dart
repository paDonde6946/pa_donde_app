part of 'mapas_bloc.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object> get props => [];
}

/// Evento para saber cuando se inicia el mapa
class OnMapaInicializadoEvent extends MapsEvent {
  final GoogleMapController controller;
  const OnMapaInicializadoEvent(this.controller);
}

class OnDetenerSeguirUsuario extends MapsEvent {}

class OnIniciarSeguirUsuario extends MapsEvent {}

class ActualizarUsuarioPolylineEvent extends MapsEvent {
  final List<LatLng> usuarioLocalizaciones;

  const ActualizarUsuarioPolylineEvent(this.usuarioLocalizaciones);
}

class OnRutaAlternarUsuario extends MapsEvent {}

class OnMostrarPolylineEvent extends MapsEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  const OnMostrarPolylineEvent(this.polylines, this.markers);
}
