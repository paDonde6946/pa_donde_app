import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/response/inicio_sesion_response.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';
//---------------------------------------------------------------------

class AutenticacionServicio with ChangeNotifier {
  Usuario usuarioServiciosActual = Usuario();

  bool _autenticando = false;

  /// Create storage que permite almacenar el token en el dispositivo fisico
  final _storage = const FlutterSecureStorage();

  /// Realiza el proceso de login y de verificacion con el backend
  Future<Usuario?> login(
      String correo, String contrasenia, String tokenMensaje) async {
    autenticando = true;

    String path =
        "/app/login/usuario/${correo.trim()}/$contrasenia/$tokenMensaje";

    final uri = Uri.http(EntornoVariable.host, path);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final loginResponse = inicioSesionResponseFromJson(response.body);
      usuarioServiciosActual = loginResponse.usuario;

      autenticando = false;
      await _guardarToken(loginResponse.token);
      return usuarioServiciosActual;
    } else {
      autenticando = false;
      return null;
    }
  }

  /// Valida que el token que se guardo por ultima vez en el dispositivo para dar automaticamente acceso al usuario
  Future<bool> logeado() async {
    String? token = await _storage.read(key: 'token');

    String path = "/app/login/renovarToken";

    final uri = Uri.http(EntornoVariable.host, path);
    final headers = {
      "x-token": token,
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    final response = await http.get(uri, headers: headers);

    // Verificar si la informacion que viene del Backend es correcta y el status es 200
    if (response.statusCode == 200) {
      // Se transforma el JSON de respuesta a una modelo dentro de Flutter
      final loginResponse = inicioSesionResponseFromJson(response.body);
      usuarioServiciosActual = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      _logout();
      return false;
    }
  }

  /// Petición para poder recuperar la contraseña y validar la autenticacion del usuario
  Future<bool> recuperarContrasenia(String correo) async {
    String path = "app/login/olvidarContrasenia";
    final uri = Uri.http(EntornoVariable.host, path);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(uri,
        headers: headers, body: json.encode({"correo": correo}));

    // Se transforma el JSON de respuesta a un mapa
    final resp = jsonDecode(response.body)["ok"];

    // Verificar si la informacion que viene del Backend es correcta y el status es 200
    if (response.statusCode == 200 && resp) {
      return true;
    }
    return false;
  }

  /// Almacena el token en el dispositivo fisico
  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  /// Borrar el token
  Future _logout() async {
    // Delete value
    return await _storage.delete(key: 'token');
  }

  /// Elimina el token que se tine almacenado
  /// Cierra la cesion creada y se elimina el token del dispoitivo
  static Future<void> eliminarToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  ///==========================================================================
  /// METODOS GET AND SET
  ///==========================================================================

  /// Getters del token de forma estatica
  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  /// Devuleve la variable atenticando
  bool get autenticando => _autenticando;

  ///Cambia el estado de la variable autenticando y notifica a los que lo esten escuchando
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }
}
