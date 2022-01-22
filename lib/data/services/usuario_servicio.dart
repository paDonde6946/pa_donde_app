import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';

class UsuarioServicio {
  /// Enviar la informacion al backend con todos los datos del nuevo usuario.
  Future<Usuario?> crearUsuarioServicio(Usuario usuario) async {
    // URL para crear el prestador de servicios - conexion
    final url = Uri.http(EntornoVariable.host, '/app/login/usuario/registrar');

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    usuario.cambioContrasenia = 0;
    final response =
        await http.put(url, headers: headers, body: usuarioToJson(usuario));

    final decodedData = json.decode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      return Usuario();
    }
    AutenticacionServicio autenticacionServicio = AutenticacionServicio();
    autenticacionServicio.usuarioServiciosActual =
        Usuario.fromJson(decodedData['usuario']);

    return autenticacionServicio.usuarioServiciosActual;
  }
}
