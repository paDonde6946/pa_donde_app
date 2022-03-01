part of 'servicio_bloc.dart';

class ServicioState extends Equatable {
  /// Lista de servicios postulados
  final List<Servicio> serviciosPostulados;

  /// Lita dee servicios generales (el usuario puede postularse)
  final List<Servicio> serviciciosGenerales;

  /// Lista de servicios creados por el usuario
  final List<Servicio> serviciosDelUsuario;

  //  Lista de historial del conductor
  final List<Servicio>? historialComoConductor;

  //  Lista de historial del usuario
  final List<Servicio>? historialComoUsuario;

  const ServicioState(
      {this.serviciosPostulados = const [],
      this.serviciciosGenerales = const [],
      this.serviciosDelUsuario = const [],
      this.historialComoConductor,
      this.historialComoUsuario});

  ServicioState copyWith({
    List<Servicio>? serviciosPostulados,
    List<Servicio>? serviciciosGenerales,
    List<Servicio>? serviciosDelUsuario,
    List<Servicio>? historialComoConductor,
    List<Servicio>? historialComoUsuario
  }) =>
      ServicioState(
        serviciosPostulados: serviciosPostulados ?? this.serviciosPostulados,
        serviciciosGenerales: serviciciosGenerales ?? this.serviciciosGenerales,
        serviciosDelUsuario: serviciosDelUsuario ?? this.serviciosDelUsuario,
        historialComoConductor: historialComoConductor ?? this.historialComoConductor,
        historialComoUsuario: historialComoUsuario ?? this.historialComoUsuario
      );

  @override
  List<Object?> get props =>
      [serviciosPostulados, serviciciosGenerales, serviciosDelUsuario, historialComoConductor, historialComoUsuario];
}
