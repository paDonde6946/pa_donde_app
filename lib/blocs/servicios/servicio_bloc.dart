import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

part 'servicio_event.dart';
part 'servicio_state.dart';

class ServicioBloc extends Bloc<ServicioEvent, ServicioState> {
  ServicioBloc() : super(ServicioState(servicioSeleccionado: Servicio())) {
    on<OnActualizarServiciosDelUsuario>((event, emit) {
      emit(state.copyWith(serviciosDelUsuario: event.serviciosDelUsuario));
    });

    on<OnActualizarServiciosGenerales>((event, emit) {
      emit(state.copyWith(serviciosGenerales: event.serviciciosGenerales));
    });

    on<OnActualizarServiciosPostulados>((event, emit) {
      emit(state.copyWith(serviciosPostulados: event.serviciosPostulados));
    });

    on<OnActualizarHistorialConductor>((event, emit) {
      emit(
          state.copyWith(historialComoConductor: event.historialComoConductor));
    });

    on<OnActualizarHistorialUsuario>((event, emit) {
      emit(state.copyWith(historialComoUsuario: event.historialComoUsuario));
    });

    on<OnServicioSeleccionado>((event, emit) {
      emit(state.copyWith(servicioSeleccionado: event.servicioSeleccionado));
    });
  }
}
