import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:pa_donde_app/blocs/blocs.dart';

part 'localizacion_event.dart';
part 'localizacion_state.dart';

class LocalizacionBloc extends Bloc<LocalizacionEvent, LocalizacionState> {
  StreamSubscription? posicionStream;
  final GpsBloc gpsBloc;

  LocalizacionBloc({required this.gpsBloc}) : super(const LocalizacionState()) {
    /// Evento para comenzar a seguir usuario
    on<OnComenzarSeguirUsuario>(
        (event, emit) => {emit(state.copyWith(seguirUsuario: true))});

    /// Evento para comenzar a parar de seguir usuario
    on<OnPararSeguirUsuario>(
        (event, emit) => {emit(state.copyWith(seguirUsuario: false))});

    /// Evento para obtener la nueva localizacion del usuario
    on<OnNuevaLocalizacionUsuarioEvent>((event, emit) {
      emit(state.copyWith(ultimaLocalizacion: event.nuevaLocalizacion,

          /// Esos ... significa que tome todo lo que tiene anteriormente y agrege el ultimo objeto
          miLocalizacionHistoria: [
            ...state.miLocalizacionHistoria,
            event.nuevaLocalizacion
          ]));
    });
  }

  Future getPosicioActual() async {
    try {
      final posicion = await Geolocator.getCurrentPosition();

      add(OnNuevaLocalizacionUsuarioEvent(
          LatLng(posicion.latitude, posicion.longitude)));
    } catch (e) {
      gpsBloc.preguntarGpsAcceso();
    }
  }

  void comenzarSeguirUsuario() {
    add(OnComenzarSeguirUsuario());

    // Emite posiciones
    posicionStream = Geolocator.getPositionStream().listen((event) {
      final posicion = event;
      add(OnNuevaLocalizacionUsuarioEvent(
          LatLng(posicion.latitude, posicion.longitude)));
    });
  }

  void pararSeguirUsuario() {
    // Finaliza el listen de la emicion de las posiciones
    posicionStream?.cancel();
    add(OnPararSeguirUsuario());
  }

  @override
  Future<void> close() {
    pararSeguirUsuario();
    return super.close();
  }
}
