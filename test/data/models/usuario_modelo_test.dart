// Importa el paquete test
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
//---------------------------------------------------------------------

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
    expect(usuario.cambioContrasenia, 1);
    expect(usuario.uid, "1cbe1bdb7392188991");
    expect(usuario.calificacionUsuario, 2.0);
    expect(usuario.calificacionConductor, 3.4);
    expect(usuario.ultimoServicioCalificar, null);
  });

  /// USUARIO MODELO PRUEBAS UNITARIAS - DE MODELO A JSON
  test("Usuario Modelo Pruebas - Método ToJson", () {
    Usuario usuarioTest = Usuario();
    usuarioTest.nombre = "Felipe";
    usuarioTest.apellido = "Martinez";
    usuarioTest.celular = 123455;
    usuarioTest.cedula = 124578900;
    usuarioTest.correo = "felipe@unbosque.edu.co";
    usuarioTest.contrasenia = "asdfwa43";
    usuarioTest.cambioContrasenia = 0;
    usuarioTest.calificacionUsuario = 2.0;
    usuarioTest.calificacionConductor = 3.4;
    usuarioTest.ultimoServicioCalificar = null;

    /// Función a probar (fromJson)
    final usuario = usuarioTest.toJson();

    // Valores esperados
    final jsonUsuario = <String, dynamic>{
      "correo": "felipe@unbosque.edu.co",
      "nombre": "Felipe",
      "apellido": "Martinez",
      "celular": 123455,
      "cedula": 124578900,
      "contrasenia": "asdfwa43",
      "cambio_contrasenia": 0,
      "calificacionConductor": 3.4,
      "calificacionUsuario": 2.0,
      "ultimoServicioSinCalificar": null,
    };

    expect(usuario, jsonUsuario);
  });
}
