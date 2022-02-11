import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_donde_app/data/response/pre_agregar_servicio_response.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';
import 'package:http/http.dart' as http;

//------------------IMPORTACIONES LOCALES------------------------------

//---------------------------------------------------------------------

class ServicioRServicio {
  // Singleton
  ServicioRServicio._privateConsstructor();

  static final ServicioRServicio _intance =
      ServicioRServicio._privateConsstructor();

  factory ServicioRServicio() {
    return _intance;
  }

  /// Create storage que permite almacenar el token en el dispositivo fisico
  final _storage = const FlutterSecureStorage();

  final _dio = Dio();

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5/mapbox';

  Future<PreAgregarServicioResponse> getPreServicio() async {
    String? token = await _storage.read(key: 'token');

    final uri = Uri.http(EntornoVariable.host, '/app/preAgregarServicio');

    final response = await http.get(uri, headers: {"x-token": token});

    final data = preAgregarServicioResponseFromJson(response.body);

    return data;
  }
}
