import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/response/vehiculo_response.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';

class VehiculoServicio {
  /// Create storage que permite almacenar el token en el dispositivo fisico
  final _storage = const FlutterSecureStorage();
  var vehiculoResponse;

  /// Obtiene todos los vehiculos
  Future<List<Vehiculo>> getVehiculos() async {
    String? token = await _storage.read(key: 'token');

    // URL para crear el prestador de servicios - conexion
    final url = Uri.http(EntornoVariable.host, '/app/vehiculosPorUid');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-token": token
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    final decodedData = json.decode(response.body);
    vehiculoResponse = VehiculosResponse.fromJson(decodedData);
    print(vehiculoResponse);

    return vehiculoResponse.vehiculos;
  }

  Future<bool> eliminarVehiculo({required placa}) async {
    String? token = await _storage.read(key: 'token');

    // URL para crear el prestador de servicios - conexion
    final url = Uri.http(EntornoVariable.host, '/app/eliminarVehiculo');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-token": token
    };

    final response = await http.delete(url,
        headers: headers, body: json.encode({'placa': placa}));

    final decodedData = json.decode(response.body);

    return decodedData['ok'];
  }
}
