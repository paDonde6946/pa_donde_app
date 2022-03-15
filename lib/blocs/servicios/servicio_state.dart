part of 'servicio_bloc.dart';

class ServicioState extends Equatable {
  /// Lista de servicios postulados
  final List<Servicio> serviciosPostulados;

  /// Lita dee servicios generales (el usuario puede postularse)
  final List<Servicio> serviciosGenerales;

  /// Lista de servicios creados por el usuario
  final List<Servicio> serviciosDelUsuario;

  //  Lista de historial del conductor
  final List<Servicio>? historialComoConductor;

  //  Lista de historial del usuario
  final List<Servicio>? historialComoUsuario;

  final int? calificacionAUsurio;

  /// Servicio que es seleccionado por el usuario.
  final Servicio servicioSeleccionado;

  const ServicioState({
    this.serviciosPostulados = const [],
    this.serviciosGenerales = const [],
    this.serviciosDelUsuario = const [],
    this.historialComoConductor,
    this.historialComoUsuario,
    required this.servicioSeleccionado,
    this.calificacionAUsurio = 0,
  });

  ServicioState copyWith({
    List<Servicio>? serviciosPostulados,
    List<Servicio>? serviciosGenerales,
    List<Servicio>? serviciosDelUsuario,
    List<Servicio>? historialComoConductor,
    List<Servicio>? historialComoUsuario,
    Servicio? servicioSeleccionado,
    int? calificacionAUsurio,
  }) =>
      ServicioState(
        serviciosPostulados: serviciosPostulados ?? this.serviciosPostulados,
        serviciosGenerales: serviciosGenerales ?? this.serviciosGenerales,
        serviciosDelUsuario: serviciosDelUsuario ?? this.serviciosDelUsuario,
        historialComoConductor:
            historialComoConductor ?? this.historialComoConductor,
        historialComoUsuario: historialComoUsuario ?? this.historialComoUsuario,
        servicioSeleccionado: servicioSeleccionado ?? this.servicioSeleccionado,
        calificacionAUsurio: calificacionAUsurio ?? this.calificacionAUsurio,
      );

  @override
  List<Object?> get props => [
        serviciosPostulados,
        serviciosGenerales,
        serviciosDelUsuario,
        servicioSeleccionado,
        historialComoConductor,
        historialComoUsuario,
        calificacionAUsurio,
      ];
}
