part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

// Evento para validar que el mapa esta listo para mostrar
class OnMapaListo extends MapaEvent {}

// Evento para disparar si se desea marcar el recorrido o no
class OnMarcarRecorrido extends MapaEvent {}

// Evento para seguir la ubicacion del usuario
class OnSeguirUbicacion extends MapaEvent {}

// Evento para validar cada que se cambia de la ubicacion
class OnNuevaUbicacion extends MapaEvent {
  final LatLng ubicacion;
  OnNuevaUbicacion(this.ubicacion);
}
