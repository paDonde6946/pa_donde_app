import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';

class UsuarioServicio {
  /// Enviar la informacion al servidor con todos los datos del nuevo usario.
  /// Primero sube todas las imagenes y luego si envia toda la información
  Future<Usuario?> crearUsuarioServicio(Usuario usuario) async {
    // URL para crear el prestador de servicios - conexion
    final url = Uri.http(EntornoVariable.host, '/app/login/usuario/registrar');

    print(usuarioToJson(usuario));

    final response = await http.put(url,
        body: usuarioToJson(usuario),
        headers: {"Content-Type": "application/json"});

    // final decodedData = json.decode(response.body);

    print(response.body);
    return null;

    // if (response.statusCode != 200 && response.statusCode != 201) {
    //   return Usuario();
    // }
    // return Usuario.fromJson(decodedData['usuario']);
  }
}
