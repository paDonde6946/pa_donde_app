// Importa el paquete test
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/mensaje_modelo.dart';
//---------------------------------------------------------------------

void main() {
  /// MENSAJE MODELO PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Mensaje Modelo Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file =
        File("test/resources/mensaje_modelo_json.json").readAsStringSync();

    /// Función a probar (fromJson)
    final mensaje = Mensaje.fromJson(jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    expect(mensaje.para, "615d1cbe1bdb739218899103");
    expect(mensaje.mensaje, "Esto es un mensaje de prueba");
    expect(mensaje.servicio, "620dcda50608a559d4c40232");
    expect(mensaje.de, "6154ad4c46197bee55be9bd3");
  });

  /// MENSAJE MODELO PRUEBAS UNITARIAS - DE MODELO A JSON
  test("Mensaje Modelo Pruebas - Método ToJson", () {
    Mensaje mensajeTest = Mensaje();
    mensajeTest.para = "615d1cbe1bdb739218899103";
    mensajeTest.mensaje = "Prueba";
    mensajeTest.servicio = "620dcda50608a559d4c40232";
    mensajeTest.de = "6154ad4c46197bee55be9bd3";

    /// Función a probar (fromJson)
    final mensaje = mensajeTest.toJson();

    // Valores esperados
    final jsonMensaje = <String, dynamic>{
      "para": "615d1cbe1bdb739218899103",
      "mensaje": "Prueba",
      "servicio": "620dcda50608a559d4c40232",
      "de": "6154ad4c46197bee55be9bd3",
    };

    expect(mensaje, jsonMensaje);
  });
}
