part of 'preservicios_bloc.dart';

abstract class PreserviciosEvent extends Equatable {
  const PreserviciosEvent();

  @override
  List<Object> get props => [];
}

class OnCambiarPagina extends PreserviciosEvent {
  final PageController pageController;
  const OnCambiarPagina(this.pageController);
}

class OnAgregarVehiculo extends PreserviciosEvent {
  final List<Vehiculo> vehiculos;
  const OnAgregarVehiculo(this.vehiculos);
}

class OnAgregarPrecios extends PreserviciosEvent {
  final List<AuxilioEconomico> precios;
  const OnAgregarPrecios(this.precios);
}

class OnCrearServicio extends PreserviciosEvent {
  final Servicio servicio;
  const OnCrearServicio(this.servicio);
}

class OnBusquedaInicioServicio extends PreserviciosEvent {
  final String busquedaInicio;
  const OnBusquedaInicioServicio(this.busquedaInicio);
}
