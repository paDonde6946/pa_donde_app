part of 'servicio_bloc.dart';

class ServicioState extends Equatable {
  /// Lista de servicios postulados
  final List<Servicio> serviciosPostulados;

  /// Lita dee servicios generales (el usuario puede postularse)
  final List<Servicio> serviciciosGenerales;

  /// Lista de servicios creados por el usuario
  final List<Servicio> serviciosDelUsuario;

  const ServicioState(
      {this.serviciosPostulados = const [],
      this.serviciciosGenerales = const [],
      this.serviciosDelUsuario = const []});

  ServicioState copyWith({
    List<Servicio>? serviciosPostulados,
    List<Servicio>? serviciciosGenerales,
    List<Servicio>? serviciosDelUsuario,
  }) =>
      ServicioState(
        serviciosPostulados: serviciosPostulados ?? this.serviciosPostulados,
        serviciciosGenerales: serviciciosGenerales ?? this.serviciciosGenerales,
        serviciosDelUsuario: serviciosDelUsuario ?? this.serviciosDelUsuario,
      );

  @override
  List<Object> get props =>
      [serviciosPostulados, serviciciosGenerales, serviciosDelUsuario];
}
