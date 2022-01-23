import 'dart:async';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/data/response/rutas_response.dart';
import 'package:pa_donde_app/data/services/lugares_interceptor_servicio.dart';
import 'package:pa_donde_app/data/services/trafico_interceptor_servicio.dart';
import 'package:pa_donde_app/ui/helpers/debouncer.dart';
//---------------------------------------------------------------------

class TraficoServicio {
  // Singleton
  TraficoServicio._privateConsstructor();

  static final TraficoServicio _intance =
      TraficoServicio._privateConsstructor();

  factory TraficoServicio() {
    return _intance;
  }

  final _dio = Dio()..interceptors.add(TraficoInterceptor());
  final _dioLugares = Dio()..interceptors.add(LugararesInterceptor());

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5/mapbox';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  /// INSTANCIA PARA PODER CONTROLAR LAS PETICIONES AL SERVICIO
  final debouncer =
      Debouncer<String>(duration: const Duration(milliseconds: 400));

  /// SE CREA UNA STREAM MULTI CAST PARA CONTROLAR LAS PETICIONES
  final StreamController<BusquedaResponse> _sugerenciasStreamController =
      StreamController<BusquedaResponse>.broadcast();

  /// METODO GET PARA CONTROLAR LAS SUGERENCIAS DE LOS RESULTADOS
  Stream<BusquedaResponse> get sugerenciasStream =>
      _sugerenciasStreamController.stream;

  /// Metodo que se conectar para obtener las rutas entre dos puntos
  Future<RutasResponse> getCoordsInicioYFin(
      LatLng? inicio, LatLng? destino) async {
    final coordString =
        '${inicio!.longitude},${inicio.latitude};${destino!.longitude},${destino.latitude}';
    final path = '$_baseUrlDir/driving/$coordString';

    final response = await _dio.get(path);

    final data = RutasResponse.fromJson(response.data);

    return data;
  }

  /// Metodo que consulta a MapBox para realizar una peticion por medio del nombre de una consulta de un lugar.
  Future<List<Feature>> getResultadosPorQuery(
      String busqueda, LatLng proximidad) async {
    if (busqueda.isEmpty) return [];

    final url = '$_baseUrlGeo/$busqueda.json';
    try {
      final response = await _dioLugares.get(url, queryParameters: {
        'proximity': '${proximidad.longitude}, ${proximidad.latitude}',
        'limit': 9,
      });

      final busquedaResponse = busquedaResponseFromJson(response.data);

      return busquedaResponse.features!;
    } catch (e) {
      return [];
    }
  }

  /// Metodo que conuslta a MapBox para realizar una peticion por medio de las coordenas de un lugar.
  Future<Feature> getInformacionPorCoordenas(LatLng coordenadas) async {
    final url =
        '$_baseUrlGeo/${coordenadas.longitude},${coordenadas.latitude}.json';
    try {
      final response =
          await _dioLugares.get(url, queryParameters: {'limit': 1});

      final busquedaResponse = busquedaResponseFromJson(response.data);

      return busquedaResponse.features![0];
    } catch (e) {
      return Feature();
    }
  }

  //// METODO QUE GUARDA LAS BUSQUEDAS REALIZADAS POR EL USUARIO
  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    /// NOTA: Se realiza uso de STREAM para controlar las peticiones que se envian al servicio
    /// y asi mismo controlar el uso del internet entre otros parametros.
    debouncer.value = '';
    debouncer.onValue = (value) async {
      await getResultadosPorQuery(value, proximidad);
      // _sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(const Duration(milliseconds: 201))
        .then((_) => timer.cancel());
  }
}
