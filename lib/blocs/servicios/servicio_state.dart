part of 'servicio_bloc.dart';

class ServicioState extends Equatable {
  /// Lista de servicios postulados
  final List<Servicio> serviciosPostulados;

  /// Lita dee servicios generales (el usuario puede postularse)
  final List<Servicio> serviciciosGenerales;

  /// Lista de servicios creados por el usuario
  final List<Servicio> serviciosDelUsuario;

  /// Servicio que es seleccionado por el usuario.
  final Servicio servicioSeleccionado;

  const ServicioState({
    this.serviciosPostulados = const [],
    this.serviciciosGenerales = const [],
    this.serviciosDelUsuario = const [],
    required this.servicioSeleccionado,
  });

  ServicioState copyWith({
    List<Servicio>? serviciosPostulados,
    List<Servicio>? serviciciosGenerales,
    List<Servicio>? serviciosDelUsuario,
    Servicio? servicioSeleccionado,
  }) =>
      ServicioState(
        serviciosPostulados: serviciosPostulados ?? this.serviciosPostulados,
        serviciciosGenerales: serviciciosGenerales ?? this.serviciciosGenerales,
        serviciosDelUsuario: serviciosDelUsuario ?? this.serviciosDelUsuario,
        servicioSeleccionado: servicioSeleccionado ?? this.servicioSeleccionado,
      );

  @override
  List<Object> get props => [
        serviciosPostulados,
        serviciciosGenerales,
        serviciosDelUsuario,
        servicioSeleccionado
      ];
}
