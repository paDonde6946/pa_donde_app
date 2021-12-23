part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

// Evento para validar que el mapa esta listo para mostrar
class OnMapaListo extends MapaEvent {}

// Evento para disparar si se desea marcar el recorrido o no
class OnMarcarRecorrido extends MapaEvent {}

// Evento para seguir la ubicacion del usuario
class OnSeguirUbicacion extends MapaEvent {}

// Evento que valida si el mapa esta siendo movido por el usuario
class OnMovioMapa extends MapaEvent {
  final LatLng centroMapa;
  OnMovioMapa(this.centroMapa);
}

// Evento para poder crear la ruta entre dos puntos
class OnCrearRutaInicioDestino extends MapaEvent {
  final List<LatLng> rutaCoordenadas;
  final double distancia;
  final double duracion;

  OnCrearRutaInicioDestino(this.rutaCoordenadas, this.distancia, this.duracion);
}

// Evento para validar cada que se cambia de la ubicacion
class OnNuevaUbicacion extends MapaEvent {
  final LatLng ubicacion;
  OnNuevaUbicacion(this.ubicacion);
}
