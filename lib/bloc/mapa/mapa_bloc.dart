// ignore: import_of_legacy_library_into_null_safe
import 'package:bloc/bloc.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pa_donde_app/ui/theme/estilo_mapa_theme..dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  /// Controlador del mapa
  GoogleMapController? _mapController;

  /// Polylines
  Polyline _miRuta = Polyline(
      polylineId: PolylineId("mi_ruta"),
      color: Color.fromRGBO(94, 153, 45, 1),
      width: 4);

  Polyline _miRutaDestino = Polyline(
      polylineId: PolylineId("mi_ruta_destino"),
      color: Color.fromRGBO(94, 153, 45, 1),
      width: 4);

  void iniMapa(GoogleMapController controller) {
    if (!state.mapaListo!) {
      _mapController = controller;
      //CAMBIAR EL ESTILO DEL MAPA
      _mapController!.setMapStyle(jsonEncode(estiloMapaTheme));

      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapalisto: true);
    } else if (event is OnNuevaUbicacion) {
      yield* _onNuevaUbicacion(event);
    } else if (event is OnMarcarRecorrido) {
      yield* _onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* _onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCrearRutaInicioDestino) {
      yield* _onCrearRutaInicioDestino(event);
    }
  }

  // Metodo que monitorea la nueva ubicacion
  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {
    if (state.seguirUbicacion!) {
      moverCamara(event.ubicacion);
    }

    // Extracion de los points
    List<LatLng> points = [..._miRuta.points, event.ubicacion];

    //Copia Lista
    _miRuta = _miRuta.copyWith(pointsParam: points);

    // Recupera los currentPolylines
    final currentPolylines = state.polylines;

    // Sobreescribe los nuevos  valors
    currentPolylines!['mi_ruta'] = _miRuta;

    // Emision
    yield state.copyWith(polylines: currentPolylines);
  }

  // Metodo que monitorea para poder dibuer el recorrido del usuario
  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    // Valiada para cambiar el color del recorrido
    if (state!.dibujarRecorrido == false) {
      _miRuta =
          _miRuta.copyWith(colorParam: const Color.fromRGBO(94, 153, 45, 1));
    } else {
      _miRuta = _miRuta.copyWith(colorParam: Colors.transparent);
    }
    // Recupera los currentPolylines
    final currentPolylines = state.polylines;
    // Sobreescribe los nuevos  valors
    currentPolylines!['mi_ruta'] = _miRuta;

    //Emision
    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido!,
        polylines: currentPolylines);
  }

  /// Metodo que monitora el seguimiento de la ubicacion del usuario actualizar la camara con la ubicacion
  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion!) {
      moverCamara(_miRuta.points[_miRuta.points.length - 1]);
    }

    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion!);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event) async* {
    _miRutaDestino =
        _miRutaDestino.copyWith(pointsParam: event.rutaCoordenadas);

    final currentPolylines = state.polylines;
    currentPolylines!["mi_ruta_destino"] = _miRutaDestino;

    // Marcadores
    final markerInicio = Marker(
        markerId: const MarkerId('inicio'), position: event.rutaCoordenadas[0]);

    // Marcadores
    final markerFinal = Marker(
        markerId: const MarkerId('final'),
        position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1]);

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['final'] = markerFinal;

    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }
}
