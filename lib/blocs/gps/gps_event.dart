part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

/// Permite tener un evento para validar el GPS del dispositivo
class GpsYPermisoEvent extends GpsEvent {
  final bool estaGpsHabilitado;
  final bool tieneGpsPerimisoOtorgados;

  const GpsYPermisoEvent({
    required this.estaGpsHabilitado,
    required this.tieneGpsPerimisoOtorgados,
  });
}
