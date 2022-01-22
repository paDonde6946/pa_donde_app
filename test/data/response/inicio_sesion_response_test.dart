// Importa el paquete test
import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/response/inicio_sesion_response.dart';

class MockUsuario extends Mock implements Usuario {}

void main() {
  /// INICIO SESION MODELO PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Inicio Sesion Response Modelo Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file = File("test/resources/inicio_sesion_response_json.json")
        .readAsStringSync();

    /// Función a probar (fromJson)
    final inicioSesionResponse =
        InicioSesionResponse.fromJson(jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    Usuario usuarioTest = Usuario();
    usuarioTest.nombre = "Felipe";
    usuarioTest.apellido = "Martinez";
    usuarioTest.celular = 1234567;
    usuarioTest.correo = "felipe@unbosque.edu.co";
    usuarioTest.cambioContrasenia = 1;

    expect(inicioSesionResponse.ok, true);
    expect(inicioSesionResponse.usuario.correo, usuarioTest.correo);
    expect(inicioSesionResponse.usuario.nombre, usuarioTest.nombre);
    expect(inicioSesionResponse.usuario.apellido, usuarioTest.apellido);
    expect(inicioSesionResponse.usuario.celular, usuarioTest.celular);
    expect(inicioSesionResponse.usuario.cambio_contrasenia,
        usuarioTest.cambioContrasenia);

    expect(inicioSesionResponse.token,
        "2MTVkMWNiZTFiZGI3MzkyMTg4OTkxMDCpd5jb4i9LuXn6qQmx-k70x8");
  });
}
