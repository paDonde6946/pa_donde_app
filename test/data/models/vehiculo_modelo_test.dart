import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
//---------------------------------------------------------------------

void main() {
// VEHICULO MODELO PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Vehiculo Modelo Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file =
        File("test/resources/vehiculo_modelo_json.json").readAsStringSync();

    /// Función a probar (fromJson)
    final vehiculo =
        Vehiculo.fromJson(jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    expect(vehiculo.placa, "JNS909");
    expect(vehiculo.tipoVehiculo, 2);
    expect(vehiculo.color, "Azul");
    expect(vehiculo.marca, "Hyunday 3");
    expect(vehiculo.anio, "2021");
    expect(vehiculo.modelo, "Accent");
    expect(vehiculo.estado, 1);
    expect(vehiculo.uid, "6190885bf803e870847c6e73");
  });

  /// VEHICULO  MODELO PRUEBAS UNITARIAS - MODELO A JSON
  test("Vehiculo Modelo Pruebas - Método constructor completo", () {
    /// Función a probar (toJson)
    final vehiculo = Vehiculo();
    vehiculo.uid = "1234555";
    vehiculo.placa = "JVR323";
    vehiculo.tipoVehiculo = 2;
    vehiculo.color = "Negro";
    vehiculo.marca = "Renault";
    vehiculo.anio = "2021";
    vehiculo.modelo = "KWID";
    vehiculo.estado = 1;

    // Valores esperados
    expect(vehiculo.uid, "1234555");
    expect(vehiculo.placa, "JVR323");
    expect(vehiculo.tipoVehiculo, 2);
    expect(vehiculo.color, "Negro");
    expect(vehiculo.marca, "Renault");
    expect(vehiculo.anio, "2021");
    expect(vehiculo.modelo, "KWID");
    expect(vehiculo.estado, 1);
  });
}
