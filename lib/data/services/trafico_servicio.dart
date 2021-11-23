import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/data/response/rutas_response.dart';
import 'package:pa_donde_app/ui/helpers/debouncer.dart';

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

  /// INSTANCIA PARA PODER CONTROLAR LAS PETICIONES AL SERVICIO
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  /// SE CREA UNA STREAM MULTI CAST PARA CONTROLAR LAS PETICIONES
  final StreamController<BusquedaResponse> _sugerenciasStreamController =
      StreamController<BusquedaResponse>.broadcast();

  /// METODO GET PARA CONTROLAR LAS SUGERENCIAS DE LOS RESULTADOS
  Stream<BusquedaResponse> get sugerenciasStream =>
      _sugerenciasStreamController.stream;

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
      final response = await _dio.get(url, queryParameters: {
        'access_token': _apyKey,
        'autocomplete': 'true',
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': "es",
        'country': 'co',
      });

      final busquedaResponse = busquedaResponseFromJson(response.data);

      return busquedaResponse;
    } catch (e) {
      return BusquedaResponse(features: []);
    }
  }

  //// METODO QUE GUARDA LAS BUSQUEDAS REALIZADAS POR EL USUARIO
  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    /// NOTA: Se realiza uso de STREAM para controlar las peticiones que se envian al servicio
    /// y asi mismo controlar el uso del internet entre otros parametros.
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await getResultadosPorQuery(value, proximidad);
      _sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(const Duration(milliseconds: 201))
        .then((_) => timer.cancel());
  }
}
