import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/global/entorno_variable_global.dart';

import 'package:pa_donde_app/data/models/auxilio_economico_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

import 'package:pa_donde_app/data/response/auxilio_economico_response.dart';
import 'package:pa_donde_app/data/response/historial_response.dart';
import 'package:pa_donde_app/data/response/servicio_response.dart';
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

  /// Obtiene los precios establecidos que puede tener un servicio
  Future<List<AuxilioEconomico>> getAuxiliosEconomicos() async {
    String? token = await _storage.read(key: 'token');

    final uri = Uri.http(EntornoVariable.host, '/app/listarAuxilioEconomico');

    final response = await http.get(uri, headers: {"x-token": token});

    final data = auxilioEconomicoResponseFromJson(response.body);

    return data.auxilioEconomico!;
  }

  /// Se envian los datos correspondientes para poder crear un servicio y guardarlo en la BD
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

  Future<HistorialResponse> getHistorial() async {
    String? token = await _storage.read(key: 'token');

    final uri = Uri.http(EntornoVariable.host, '/app/darHistorial');

    final response = await http.get(uri, headers: {"x-token": token});

    final data = historialResponseFromJson(response.body);

    return data;
  }

  /// Obtine la lista de servicios creados por el usuario
  Future<List<Servicio>> darServiciosCreadosPorUsuario() async {
    // EndPoint para crear el servicio
    final uri = Uri.http(EntornoVariable.host, '/app/darServiciosCreados');

    String? token = await _storage.read(key: 'token');

    final response = await http.get(uri, headers: {"x-token": token});

    final data = servicioResponseFromJson(response.body);

    return data.servicios!;
  }

  /// Obtiene la lista de servicios que el usuario se postulo
  Future<List<Servicio>> darServiciosPostuladosPorUsuario() async {
    // EndPoint para crear el servicio
    final uri = Uri.http(EntornoVariable.host, '/app/darServiciosPostulados');

    String? token = await _storage.read(key: 'token');

    final response = await http.get(uri, headers: {"x-token": token});

    final data = servicioResponseFromJson(response.body);

    return data.servicios!;
  }

  /// Obtiene la lista de servicios generales en la que el usuario puede postularse
  Future<List<Servicio>> darServiciosGenerales() async {
    // EndPoint para crear el servicio
    final uri = Uri.http(EntornoVariable.host, '/app/darServiciosDisponibles');

    String? token = await _storage.read(key: 'token');

    final response = await http.get(uri, headers: {"x-token": token});

    final data = servicioResponseFromJson(response.body);

    return data.servicios!;
  }

  /// Actualiza el servicio creado por el usuario
  Future<bool> actualizarServicio(Servicio servicio) async {
    // EndPoint para crear el servicio
    final uri =
        Uri.http(EntornoVariable.host, "/app/editarServicio/${servicio.uid}");

    String? token = await _storage.read(key: 'token');

    final data = {
      "fechayhora": servicio.fechayhora,
      "cantidadCupos": servicio.cantidadCupos,
    };

    final response = await http.put(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-token": token,
      },
      body: json.encode(data),
    );

    final res = json.decode(response.body);

    return res["ok"];
  }

  /// Se elimina el servicio del usuario que lo creo
  Future<bool> eliminarServicio(Servicio servicio) async {
    // EndPoint para crear el servicio
    final uri =
        Uri.http(EntornoVariable.host, "/app/eliminarServicio/${servicio.uid}");

    String? token = await _storage.read(key: 'token');

    final response = await http.delete(uri, headers: {"x-token": token});

    final res = json.decode(response.body);

    return res["ok"];
  }

  /// El usuario que se postulo para poder tomar un servicio puede cancelar el servicio con esta peticion
  Future<bool> cancelarServicio(String uid) async {
    // EndPoint para crear el servicio
    final uri = Uri.http(EntornoVariable.host, "/app/desPostularse");

    String? token = await _storage.read(key: 'token');

    final data = {
      "uidServicio": uid,
    };

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-token": token,
      },
      body: json.encode(data),
    );

    final res = json.decode(response.body);

    return res["ok"];
  }

  /// el usuario que este interesado en postularse para poder tomar un servicio con esta peticion
  Future<bool> postularseServicio(String uid) async {
    // EndPoint para crear el servicio
    final uri = Uri.http(EntornoVariable.host, "/app/separaCupo");

    String? token = await _storage.read(key: 'token');

    final data = {
      "idServicio": uid,
    };

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-token": token,
      },
      body: json.encode(data),
    );

    final res = json.decode(response.body);

    return res["ok"];
  }

  Future<bool> iniciarServicio(String uid) async {
    // EndPoint para crear el servicio
    final uri = Uri.http(EntornoVariable.host, "/app/iniciarServicio");

    String? token = await _storage.read(key: 'token');

    final data = {
      "uidServicio": uid,
    };

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-token": token,
      },
      body: json.encode(data),
    );

    final res = json.decode(response.body);

    return res["ok"];
  }

  Future<bool> finalizarServicio(String uid) async {
    // EndPoint para crear el servicio
    final uri = Uri.http(EntornoVariable.host, "/app/finalizarServicio");

    String? token = await _storage.read(key: 'token');

    final data = {
      "uidServicio": uid,
    };

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-token": token,
      },
      body: json.encode(data),
    );

    final res = json.decode(response.body);

    return res["ok"];
  }

  Future<bool> calificarUsuario(
      String uidServicio, String uidPasajero, String calificacion) async {
    final uri = Uri.http(EntornoVariable.host, "/app/calificarPasajero");

    String? token = await _storage.read(key: 'token');

    final data = {
      "uidServicio": uidServicio,
      "uidPasajero": uidPasajero,
      "calificacion": calificacion,
    };

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-token": token,
      },
      body: json.encode(data),
    );

    final res = json.decode(response.body);

    return res["ok"];
  }

  Future<bool> calificarConductor(
      String uidServicio, String calificacion) async {
    final uri = Uri.http(EntornoVariable.host, "/app/calificarConductor");

    String? token = await _storage.read(key: 'token');

    final data = {
      "uidServicio": uidServicio,
      "calificacion": calificacion,
    };

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-token": token,
      },
      body: json.encode(data),
    );

    final res = json.decode(response.body);

    return res["ok"];
  }
}
