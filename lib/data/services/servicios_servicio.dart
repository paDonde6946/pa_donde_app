import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pa_donde_app/data/models/auxilio_economico_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/global/entorno_variable_global.dart';
import 'package:pa_donde_app/data/response/auxilio_economico_response.dart';
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

  Future<List<AuxilioEconomico>> getAuxiliosEconomicos() async {
    String? token = await _storage.read(key: 'token');

    final uri = Uri.http(EntornoVariable.host, '/app/listarAuxilioEconomico');

    final response = await http.get(uri, headers: {"x-token": token});

    final data = auxilioEconomicoResponseFromJson(response.body);

    return data.auxilioEconomico!;
  }

  Future<bool> crearServicio(Servicio servicio) async {
    // EndPoint para crear el servicio
    final url = Uri.http(EntornoVariable.host, '/app/agregarServicio');

    /// Obtener el token
    String? token = await _storage.read(key: 'token');

    final headers = {
      "x-token": token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final body = servicioToJson(servicio);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
