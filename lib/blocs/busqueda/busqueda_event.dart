part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class OnActivarMarcadorManual extends BusquedaEvent {}

class OnDesactivarMarcadorManual extends BusquedaEvent {}

class OnAgregarHistorialOrigenEvent extends BusquedaEvent {
  final Feature lugarOrigen;
  OnAgregarHistorialOrigenEvent(this.lugarOrigen);
}

class OnAgregarHistorialDestionoEvent extends BusquedaEvent {
  final Feature lugarDestino;
  OnAgregarHistorialDestionoEvent(this.lugarDestino);
}

class OnNuevosLugaresEncontradosEvent extends BusquedaEvent {
  final List<Feature> lugares;
  OnNuevosLugaresEncontradosEvent(this.lugares);
}
