import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/theme/estilo_mapa_theme..dart';
import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

part 'mapas_event.dart';
part 'mapas_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  final LocalizacionBloc localizacionBloc;

  GoogleMapController? _googleMapController;
  LatLng? centroMapa;

  StreamSubscription<LocalizacionState>? localizacionStateSubscricion;

  MapsBloc({required this.localizacionBloc}) : super(const MapsState()) {
    on<OnMapaInicializadoEvent>(_onInitMapa);
    on<OnIniciarSeguirUsuario>(_onComenzarSeguirUsuario);
    on<ActualizarUsuarioPolylineEvent>(_onPolylineNuevoPunto);

    on<OnDetenerSeguirUsuario>(
        (event, emit) => emit(state.copyWith(seguirUsuario: false)));

    on<OnRutaAlternarUsuario>((event, emit) =>
        emit(state.copyWith(mostrarMiRuta: !state.mostrarMiRuta)));

    on<OnMostrarPolylineEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));
    //
    localizacionStateSubscricion =
        localizacionBloc.stream.listen((localizacionState) {
      if (localizacionState.ultimaLocalizacion != null) {
        add(ActualizarUsuarioPolylineEvent(
            localizacionState.miLocalizacionHistoria));
      }
      if (!state.seguirUsuario) return;

      if (localizacionState.ultimaLocalizacion == null) return;

      moverCamara(localizacionState.ultimaLocalizacion!);
    });
  }

  /// Evento para poder controlar el mapa cuando inicia y establecer el estilo del mismo
  void _onInitMapa(OnMapaInicializadoEvent event, Emitter<MapsState> emit) {
    _googleMapController = event.controller;
    _googleMapController!.setMapStyle(jsonEncode(estiloMapaTheme));
    emit(state.copyWith(estaMapaInicializado: true));
  }

  /// Evento que permite ubicar al usuario en el mapa
  void moverCamara(LatLng nuevaLocalizacion) {
    final camaraActualizar = CameraUpdate.newLatLng(nuevaLocalizacion);
    _googleMapController?.animateCamera(camaraActualizar);
  }

  /// Evento que permite seguir el usuario
  void _onComenzarSeguirUsuario(
      OnIniciarSeguirUsuario event, Emitter<MapsState> emit) {
    emit(state.copyWith(seguirUsuario: true));

    if (localizacionBloc.state.ultimaLocalizacion == null) return;
    moverCamara(localizacionBloc.state.ultimaLocalizacion!);
  }

  ///  Ruta propia para poder trazar una ruta manualmente
  void _onPolylineNuevoPunto(
      ActualizarUsuarioPolylineEvent event, Emitter<MapsState> emit) {
    final miRuta = Polyline(
      polylineId: const PolylineId("miRuta"),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.usuarioLocalizaciones,
    );

    final polylineActual = Map<String, Polyline>.from(state.polylines);
    polylineActual['miRuta'] = miRuta;

    emit(state.copyWith(polylines: polylineActual));
  }

  Future dibujarRutaPolyline(
      BuildContext context, RutaDestino rutaDestino) async {
    final ruta = Polyline(
      polylineId: const PolylineId("ruta"),
      color: Theme.of(context).primaryColor,
      points: rutaDestino.puntos,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    /// Transformacion de la informacion para mostrar la distancia y duracion
    double distanciaKM = rutaDestino.distancia / 1000;
    distanciaKM = (distanciaKM * 100).floorToDouble();
    distanciaKM /= 100;

    double duracionViaje = (rutaDestino.duracion / 60).floorToDouble();

    /// Marcodor Personalizado
    final marcadorPersonalizado = await getNetworkImagenMarker();
    final marcadorPersonalizadoFinal = await getFinalMarkerPersonalizado(
        rutaDestino.lugarFinal.text!,
        distanciaKM.toInt(),
        context,
        duracionViaje.toInt());

    /// Marcador Inicial de la ruta
    final marcadorInicial = Marker(
      markerId: const MarkerId('inicial'),
      position: rutaDestino.puntos[0],
      icon: marcadorPersonalizado,
    );

    /// Marcador Final de la ruta
    final marcadorFinal = Marker(
      markerId: const MarkerId('final'),
      position: rutaDestino.puntos[rutaDestino.puntos.length - 1],
      icon: marcadorPersonalizadoFinal,
    );

    final polylineActual = Map<String, Polyline>.from(state.polylines);
    polylineActual['ruta'] = ruta;

    final marcadorActual = Map<String, Marker>.from(state.markers);
    marcadorActual['inicial'] = marcadorInicial;
    marcadorActual['final'] = marcadorFinal;

    add(OnMostrarPolylineEvent(polylineActual, marcadorActual));
  }

  @override
  Future<void> close() {
    localizacionStateSubscricion?.cancel();
    return super.close();
  }
}
