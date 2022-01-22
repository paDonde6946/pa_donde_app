part of 'localizacion_bloc.dart';

abstract class LocalizacionEvent extends Equatable {
  const LocalizacionEvent();

  @override
  List<Object> get props => [];
}

class OnNuevaLocalizacionUsuarioEvent extends LocalizacionEvent {
  final LatLng nuevaLocalizacion;
  const OnNuevaLocalizacionUsuarioEvent(this.nuevaLocalizacion);
}

class OnComenzarSeguirUsuario extends LocalizacionEvent {}

class OnPararSeguirUsuario extends LocalizacionEvent {}
