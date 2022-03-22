// Importa el paquete test
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/pasajeros_modelo.dart';
//---------------------------------------------------------------------

void main() {
  /// PASAJERO MODELO PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Pasajero Modelo Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file =
        File("test/resources/pasajero_modelo_json.json").readAsStringSync();

    /// Función a probar (fromJson)
    final pasajero =
        Pasajero.fromJson(jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    expect(pasajero.id, "235235");
    expect(pasajero.nombre, "Hernan");
  });

  /// USUARIO MODELO PRUEBAS UNITARIAS - DE MODELO A JSON
  test("Usuario Modelo Pruebas - Método ToJson", () {
    Pasajero pasajeroTest = Pasajero();
    pasajeroTest.id = "235235";
    pasajeroTest.nombre = "Felipe";

    /// Función a probar (fromJson)
    final pasajero = pasajeroTest.toJson();

    // Valores esperados
    final jsonPasajero = <String, dynamic>{"nombre": "Felipe", "_id": "235235"};

    expect(pasajero, jsonPasajero);
  });
}
