// Importa el paquete test
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'package:pa_donde_app/data/models/usuario_modelo.dart';

void main() {
  /// USUARIO MODELO PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Usuario Modelo Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file =
        File("test/resources/usuario_modelo_json.json").readAsStringSync();

    /// Función a probar (fromJson)
    final usuario = Usuario.fromJson(jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    expect(usuario.correo, "juan@unbosque.edu.co");
    expect(usuario.tipoUsuario, 1);
    expect(usuario.nombre, "Juan");
    expect(usuario.apellido, "Perez");
    expect(usuario.celular, 3004503102);
    expect(usuario.cambio_contrasenia, 1);
    expect(usuario.uid, "1cbe1bdb7392188991");
  });

  /// USUARIO MODELO PRUEBAS UNITARIAS - DE MODELO A JSON
  test("Usuario Modelo Pruebas - Método ToJson", () {
    Usuario usuarioTest = Usuario();
    usuarioTest.nombre = "Felipe";
    usuarioTest.apellido = "Martinez";
    usuarioTest.celular = 123455;
    usuarioTest.correo = "felipe@unbosque.edu.co";
    usuarioTest.contrasenia = "asdfwa43";
    usuarioTest.cambio_contrasenia = 0;

    /// Función a probar (fromJson)
    final usuario = usuarioTest.toJson();

    // Valores esperados
    final jsonUsuario = <String, dynamic>{
      "correo": "felipe@unbosque.edu.co",
      "nombre": "Felipe",
      "apellido": "Martinez",
      "celular": 123455,
      "contrasenia": "asdfwa43",
      "cambio_contrasenia": 0,
    };

    expect(usuario, jsonUsuario);
  });
}
