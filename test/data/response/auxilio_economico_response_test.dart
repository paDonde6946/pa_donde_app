// Importa el paquete test
import 'dart:convert';
import 'dart:io';

import 'package:pa_donde_app/data/response/auxilio_economico_response.dart';
import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/auxilio_economico_modelo.dart';
//---------------------------------------------------------------------

void main() {
  /// AUXILIO ECONOMICO Response PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Auxilio Economico Response Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file = File("test/resources/auxilio_economico_response_json.json")
        .readAsStringSync();

    /// Función a probar (fromJson)
    final auxilioEconomicoRes = AuxilioEconomicoResponse.fromJson(
        jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    AuxilioEconomico auxilioEconomico = AuxilioEconomico();
    auxilioEconomico.estado = 1;
    auxilioEconomico.valor = 0;
    auxilioEconomico.uid = "61f1f9a0d41447b8ea79d2e8";

    expect(auxilioEconomicoRes.auxilioEconomico![0].estado,
        auxilioEconomico.estado);
    expect(
        auxilioEconomicoRes.auxilioEconomico![0].valor, auxilioEconomico.valor);
    expect(auxilioEconomicoRes.auxilioEconomico![0].uid, auxilioEconomico.uid);
  });

  /// AUXILIO ECONOMICO MODELO PRUEBAS UNITARIAS - DE MODELO A JSON
  test("Auxilio Economico Modelo Pruebas - Método ToJson", () {
    //// Datos de prueba
    AuxilioEconomico auxilioEconomicoTest1 = AuxilioEconomico();
    auxilioEconomicoTest1.estado = 1;
    auxilioEconomicoTest1.valor = 0;
    auxilioEconomicoTest1.uid = "61f1f9a0d41447b8ea79d2e8";

    AuxilioEconomico auxilioEconomicoTest2 = AuxilioEconomico();
    auxilioEconomicoTest2.estado = 1;
    auxilioEconomicoTest2.valor = 1000;
    auxilioEconomicoTest2.uid = "61f1f9e3d41447b8ea79d2e9";

    AuxilioEconomico auxilioEconomicoTest3 = AuxilioEconomico();
    auxilioEconomicoTest3.estado = 1;
    auxilioEconomicoTest3.valor = 2000;
    auxilioEconomicoTest3.uid = "61f1f9e5d41447b8ea79d2ea";

    ///===============================

    AuxilioEconomicoResponse auxilioEconomicoResponse =
        AuxilioEconomicoResponse();

    auxilioEconomicoResponse.ok = true;

    auxilioEconomicoResponse.auxilioEconomico = [
      auxilioEconomicoTest1,
      auxilioEconomicoTest2,
      auxilioEconomicoTest3
    ];

    /// Función a probar (fromJson)
    final auxilioEconomico = auxilioEconomicoResponse.toJson();

    // Valores esperados
    final jsonAuxilioEconomico = <String, dynamic>{
      "ok": true,
      "auxilioEconomico": [
        {"estado": 1, "valor": 0, "uid": "61f1f9a0d41447b8ea79d2e8"},
        {"estado": 1, "valor": 1000, "uid": "61f1f9e3d41447b8ea79d2e9"},
        {"estado": 1, "valor": 2000, "uid": "61f1f9e5d41447b8ea79d2ea"}
      ]
    };

    expect(auxilioEconomico, jsonAuxilioEconomico);
  });
}
