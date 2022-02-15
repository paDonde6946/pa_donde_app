part of 'preservicios_bloc.dart';

class PreserviciosState extends Equatable {
  // Atributo para controlar el pageView de las paginas para crear el servicio
  final PageController pageController;

  /// Vehiculos que tiene el usuario
  final List<Vehiculo> vehiculos;

  // Precios que puede tener el servicio
  final List<AuxilioEconomico> precios;

  /// Variable para guardar los datos del servicio.
  final Servicio servicio;

  const PreserviciosState({
    required this.pageController,
    required this.servicio,
    this.vehiculos = const [],
    this.precios = const [],
  });

  PreserviciosState copyWith({
    PageController? pageController,
    List<Vehiculo>? vehiculos,
    List<AuxilioEconomico>? precios,
    Servicio? servicio,
    String? busquedaInicio,
    int? controlarIndex,
  }) =>
      PreserviciosState(
        pageController: pageController ?? this.pageController,
        servicio: servicio ?? this.servicio,
        vehiculos: vehiculos ?? this.vehiculos,
        precios: precios ?? this.precios,
      );

  @override
  List<Object> get props => [
        pageController,
        servicio,
        vehiculos,
        precios,
      ];
}
