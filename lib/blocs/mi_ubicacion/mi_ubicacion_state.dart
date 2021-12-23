part of 'mi_ubicacion_bloc.dart';

@immutable
class MiUbicacionState {
  final bool? siguiendo;
  final bool? existeUbicacion;
  final LatLng? ubicacion;

  MiUbicacionState({
    this.siguiendo = true,
    this.existeUbicacion = false,
    this.ubicacion,
  });

  MiUbicacionState copyWith({
    bool? siguiendo,
    bool? existeUbicacion,
    LatLng? ubicacion,
  }) =>
      MiUbicacionState(
          siguiendo: siguiendo ?? siguiendo,
          existeUbicacion: existeUbicacion ?? existeUbicacion,
          ubicacion: ubicacion ?? ubicacion);
}
