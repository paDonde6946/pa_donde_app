part of 'preservicios_bloc.dart';

class PreserviciosState extends Equatable {
  // Atributo para controlar el pageView de las paginas para crear el servicio
  final PageController pageController;

  /// Vehiculos que tiene el usuario
  final List<Vehiculo> vehiculos;

  // Precios que puede tener el servicio
  final List<AuxilioEconomico> precios;

  const PreserviciosState({
    required this.pageController,
    this.vehiculos = const [],
    this.precios = const [],
  });

  PreserviciosState copyWith({
    PageController? pageController,
    List<Vehiculo>? vehiculos,
    List<AuxilioEconomico>? precios,
  }) =>
      PreserviciosState(
        pageController: pageController ?? this.pageController,
        vehiculos: vehiculos ?? this.vehiculos,
        precios: precios ?? this.precios,
      );

  @override
  List<Object> get props => [pageController, vehiculos, precios];
}
