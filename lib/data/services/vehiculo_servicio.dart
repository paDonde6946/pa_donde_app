import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/response/vehiculo_response.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';

class VehiculoServicio {
  /// Create storage que permite almacenar el token en el dispositivo fisico
  final _storage = const FlutterSecureStorage();

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
    VehiculosResponse vehiculoResponse =
        VehiculosResponse.fromJson(decodedData);

    return vehiculoResponse.vehiculos!;
  }

  Future eliminarVehiculo({required Vehiculo vehiculo}) async {
    String? token = await _storage.read(key: 'token');

    // URL para crear el prestador de servicios - conexion
    final url =
        Uri.http(EntornoVariable.host, '/app/eliminarVehiculo/' + vehiculo.uid);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-token": token
    };

    final response = await http.delete(url, headers: headers);

    final decodedData = json.decode(response.body);

    return decodedData;
  }

  Future agregarVehiculo({required Vehiculo vehiculo}) async {
    String? token = await _storage.read(key: 'token');

    // URL para crear el prestador de servicios - conexion
    final url = Uri.http(EntornoVariable.host, '/app/agregarVehiculo');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-token": token
    };
    var data = {
      'placa': vehiculo.placa,
      'tipoVehiculo': vehiculo.tipoVehiculo,
      'color': vehiculo.color,
      'marca': vehiculo.marca,
      'anio': vehiculo.anio,
      'modelo': vehiculo.modelo
    };
    final response =
        await http.post(url, headers: headers, body: json.encode(data));

    final decodedData = json.decode(response.body);

    return decodedData;
  }

  Future editarServicio({required Vehiculo vehiculo}) async {
    String? token = await _storage.read(key: 'token');

    // URL para crear el prestador de servicios - conexion
    final url = Uri.http(
        EntornoVariable.host, '/app/actualizarVehiculo/' + vehiculo.uid);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-token": token
    };
    var data = {
      'placa': vehiculo.placa,
      'color': vehiculo.color,
      'marca': vehiculo.marca,
      'anio': vehiculo.anio,
      'modelo': vehiculo.modelo
    };
    final response =
        await http.post(url, headers: headers, body: json.encode(data));

    final decodedData = json.decode(response.body);

    return decodedData;
  }

  Future cargarLicenciaConduccion(dynamic imageFile) async {
    String? token = await _storage.read(key: 'token');

    final url = Uri.http(EntornoVariable.host, "/app/cargarLicenciaConduccion");

    var imageUplodReques = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imageFile.path);

    imageUplodReques.fields['tipoDocumento'] = '1';

    imageUplodReques.files.add(file);

    imageUplodReques.headers["x-token"] = token;

    final streamResponse = await imageUplodReques.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    return true;
  }
}
