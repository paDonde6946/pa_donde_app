// Importa el paquete test
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/auxilio_economico_modelo.dart';
//---------------------------------------------------------------------

void main() {
  /// AUXILIO ECONOMICO MODELO PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Auxilio Economico Modelo Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file = File("test/resources/auxilio_economico_modelo_json.json")
        .readAsStringSync();

    /// Función a probar (fromJson)
    final auxilioEconomico =
        AuxilioEconomico.fromJson(jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    expect(auxilioEconomico.estado, 1);
    expect(auxilioEconomico.valor, 0);
    expect(auxilioEconomico.uid, "61f1f9a0d41447b8ea79d2e8");
  });

  /// AUXILIO ECONOMICO MODELO PRUEBAS UNITARIAS - DE MODELO A JSON
  test("Auxilio Economico Modelo Pruebas - Método ToJson", () {
    AuxilioEconomico auxilioEconomicoTest = AuxilioEconomico();
    auxilioEconomicoTest.estado = 1;
    auxilioEconomicoTest.valor = 1000;
    auxilioEconomicoTest.uid = "61f1f9a0d41447b8ea79d2e8";

    /// Función a probar (fromJson)
    final auxilioEconomico = auxilioEconomicoTest.toJson();

    // Valores esperados
    final jsonAuxilioEconomico = <String, dynamic>{
      "estado": 1,
      "valor": 1000,
      "uid": "61f1f9a0d41447b8ea79d2e8"
    };

    expect(auxilioEconomico, jsonAuxilioEconomico);
  });
}
