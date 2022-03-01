part of 'servicio_bloc.dart';

abstract class ServicioEvent extends Equatable {
  const ServicioEvent();

  @override
  List<Object> get props => [];
}

class OnActualizarServiciosPostulados extends ServicioEvent {
  final List<Servicio> serviciosPostulados;

  const OnActualizarServiciosPostulados(this.serviciosPostulados);
}

class OnActualizarServiciosGenerales extends ServicioEvent {
  final List<Servicio> serviciciosGenerales;

  const OnActualizarServiciosGenerales(this.serviciciosGenerales);
}

class OnActualizarServiciosDelUsuario extends ServicioEvent {
  final List<Servicio> serviciosDelUsuario;

  const OnActualizarServiciosDelUsuario(this.serviciosDelUsuario);
}

class OnServicioSeleccionado extends ServicioEvent {
  final Servicio servicioSeleccionado;

  const OnServicioSeleccionado(this.servicioSeleccionado);
}
