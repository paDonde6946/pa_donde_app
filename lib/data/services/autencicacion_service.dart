import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/response/inicio_sesion_response.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';
//---------------------------------------------------------------------

class AutenticacionServicio with ChangeNotifier {
  Usuario usuarioServiciosActual = Usuario();
  bool _autenticado = false;

  /// Create storage que permite almacenar el token en el dispositivo fisico
  // final _storage = FlutterSecureStorage();

  /// Realiza el proceso de login y de verificacion con la base de datos
  Future<Usuario?> login(String correo, String contrasenia) async {
    _autenticado = true;

    String path = "/app/login/usuario/$correo/$contrasenia";

    final uri = Uri.http(EntornoVariable.host, path);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      final loginResponse = inicioSesionResponseFromJson(response.body);

      usuarioServiciosActual = loginResponse.usuario!;
      autenticando = false;
      // await this._guardarToken(loginResponse.token);
      return usuarioServiciosActual;
    } else {
      autenticando = false;
      return null;
    }
  }

  // ///
  // Future<bool> logeado() async {
  //   final token = await this._storage.read(key: 'token');

  //   if (token != null) {
  //     // Se crea la peticion GET para enviar al Backend
  //     final resp = await http.get(
  //       '${EntornoVariable.socketURL}/login/renovarJWT',
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'x-token': token,
  //       },
  //     );

  //     // Verificar si la informacion que viene del Backend es correcta y el status es 200
  //     if (resp.statusCode == 200) {
  //       // Se transforma el JSON de respuesta a una modelo dentro de Flutter
  //       final loginResponse = inicioSessionResponseFromJson(resp.body);
  //       this.usuarioServiciosActual = loginResponse.usuarioServiciosBD;

  //       await this._guardarToken(loginResponse.token);

  //       return true;
  //     } else {
  //       this._logout();
  //       return false;
  //     }
  //   }
  //   return false;
  // }

  // /// Almacena el token en el dispositivo fisico
  // Future _guardarToken(String token) async {
  //   return await _storage.write(key: 'token', value: token);
  // }

  // /// Borrar el token
  // Future _logout() async {
  //   // Delete value
  //   return await _storage.delete(key: 'token');
  // }

  // /// Elimina el token que se tine almacenado
  // /// Cierra la cesion creada y se elimina el token del dispoitivo
  // static Future<void> eliminarToken() async {
  //   final _storage = new FlutterSecureStorage();
  //   await _storage.delete(key: 'token');
  // }

  ///==========================================================================
  /// METODOS GET AND SET

  /// Getters del token de forma estatica
  // static Future<String> getToken() async {
  //   // final _storage = new FlutterSecureStorage();
  //   // final token = await _storage.read(key: 'token');
  //   // return token;
  // }

  /// Devuleve la variable atenticando
  bool get autenticando => _autenticado;

  ///Cambia el estado de la variable autenticando y notifica a los que lo esten escuchando
  set autenticando(bool valor) {
    _autenticado = valor;
    notifyListeners();
  }
}
