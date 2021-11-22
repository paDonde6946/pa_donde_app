import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/data/response/rutas_response.dart';

class TraficoServicio {
  // Singleton
  TraficoServicio._privateConsstructor();

  static final TraficoServicio _intance =
      TraficoServicio._privateConsstructor();

  factory TraficoServicio() {
    return _intance;
  }

  final _dio = Dio();
  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';

  final _apyKey =
      'pk.eyJ1IjoicGFkb25kZSIsImEiOiJja3cwMnhhaGo5cDNrMm9xcHZ1aHp3MG5sIn0.xK7J4icnMawVN-_Qx0t_9g';

  Future<RutasResponse> getCoordsInicioYFin(
      LatLng? inicio, LatLng? destino) async {
    final coordString =
        '${inicio!.longitude},${inicio.latitude};${destino!.longitude},${destino.latitude}';
    final path = '$_baseUrlDir/mapbox/driving/$coordString';

    final response = await _dio.get(path, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': 'false',
      'access_token': _apyKey,
      'language': 'es',
    });

    final data = RutasResponse.fromJson(response.data);

    return data;
  }

  Future<BusquedaResponse> getResultadosPorQuery(
      String busqueda, LatLng proximidad) async {
    final url = '$_baseUrlGeo/mapbox.places/$busqueda.json';

    try {
      final response = await _dio
          .get(url, options: Options(followRedirects: false), queryParameters: {
        'country': 'co',
        'autocomplete': 'true'
            'proximity'
            '${proximidad.longitude},${proximidad.latitude}',
        'language': "es",
        'access_token': _apyKey,
      });

      final busquedaResponse = busquedaResponseFromJson(response.data);

      return busquedaResponse;
    } catch (e) {
      return BusquedaResponse(features: []);
    }
  }
}
