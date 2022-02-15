import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/response/pre_agregar_servicio_response.dart';

part 'preservicios_event.dart';
part 'preservicios_state.dart';

class PreserviciosBloc extends Bloc<PreserviciosEvent, PreserviciosState> {
  PageController? controller;
  List<Vehiculo>? vehiculos;
  List<AuxilioEconomico>? precios;
  Servicio? servicio;

  PreserviciosBloc()
      : super(
          PreserviciosState(
            servicio: Servicio(),
            pageController: PageController(
                initialPage: 0, keepPage: true, viewportFraction: 1.0),
          ),
        ) {
    /// Agrega el controlador para cambiar entre las paginas de la creacion del servicio
    on<OnCambiarPagina>((event, emit) {
      emit(state.copyWith(pageController: event.pageController));
      controller = event.pageController;
    });

    /// Agrega los vehiculos
    on<OnAgregarVehiculo>((event, emit) {
      emit(state.copyWith(vehiculos: event.vehiculos));
      vehiculos = event.vehiculos;
    });

    /// Agrega los precios
    on<OnAgregarPrecios>((event, emit) {
      emit(state.copyWith(precios: event.precios));
      precios = event.precios;
    });

    on<OnCrearServicio>((event, emit) {
      emit(state.copyWith(servicio: event.servicio));
      servicio = event.servicio;
    });
  }
}
