import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';

class ChatServicio {
  /// Create storage que permite almacenar el token en el dispositivo fisico
  final _storage = const FlutterSecureStorage();

  /// Obtiene el chat
  Future obtenerChat() async {
    String? token = await _storage.read(key: 'token');

    // URL - conexion
    final url = Uri.http(EntornoVariable.host, '/app/obtenerChat');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-token": token
    };

    final response = await http.post(url, headers: headers);

    final decodedData = json.decode(response.body);

    return decodedData;
  }
}
