import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';

import 'package:pa_donde_app/global/entorno_variable_global.dart';
//---------------------------------------------------------------------

class UsuarioServicio {
  final _storage = const FlutterSecureStorage();

  /// Enviar la informacion al backend con todos los datos del nuevo usuario.
  Future crearUsuarioServicio(Usuario usuario, BuildContext context) async {
    // URL para crear el prestador de servicios - conexion
    final url = Uri.http(EntornoVariable.host, '/app/login/usuario/registrar');

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    usuario.cambioContrasenia = 0;
    final jsonUser = usuarioToJson(usuario);
    final response = await http.put(url, headers: headers, body: jsonUser);

    if (response.statusCode != 200 && response.statusCode != 201) {
      return response.body;
    }

    return response.body;
  }

  /// Petición para poder cambiar contrasenia
  Future<bool> cambiarContrasenia(String password) async {
    String? token = await _storage.read(key: 'token');
    String path = "app/cambiarContrasenia";
    final uri = Uri.http(EntornoVariable.host, path);
    final headers = {
      "x-token": token,
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    final response = await http.post(uri,
        headers: headers, body: json.encode({"contrasenia": password}));

    // Se transforma el JSON de respuesta a un mapa
    final resp = jsonDecode(response.body)["ok"];

    // Verificar si la informacion que viene del Backend es correcta y el status es 200
    if (response.statusCode == 200 && resp) {
      return true;
    }
    return false;
  }

  Future<Usuario> editarPerfil(Usuario usuario) async {
    String? token = await _storage.read(key: 'token');
    String path = "app/actualizarPerfil";
    final uri = Uri.http(EntornoVariable.host, path);
    final headers = {
      "x-token": token,
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    final response = await http.post(uri,
        headers: headers,
        body: json.encode({
          "uid": usuario.uid,
          "nombre": usuario.nombre,
          "apellido": usuario.apellido,
          "celular": usuario.celular
        }));

    // Se transforma el JSON de respuesta a un mapa
    final resp = jsonDecode(response.body)["usuario"];
    final usuarioResp = Usuario.fromJson(resp);

    // Verificar si la informacion que viene del Backend es correcta y el status es 200
    if (response.statusCode == 200) {
      return usuarioResp;
    }
    return Usuario();
  }
}
