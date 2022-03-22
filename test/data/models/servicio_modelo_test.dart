import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
//---------------------------------------------------------------------

void main() {
// SERVICIO MODELO PRUEBAS UNITARIAS - DE JSON A MODELO
  test("Servicio Modelo Pruebas - Método FromJson", () {
    // Se lee un archivo con un json de prueba
    final file =
        File("test/resources/servicio_modelo_json.json").readAsStringSync();

    /// Función a probar (fromJson)
    final servicio =
        Servicio.fromJson(jsonDecode(file) as Map<String, dynamic>);

    // Valores esperados
    expect(servicio.estado, 2);
    expect(servicio.nombreOrigen, "Tintal Plaza");
    expect(servicio.nombreDestino, "Hayuelos Centro Comercial");
    expect(servicio.polylineRuta,
        "acjzG`pbmlCwMkRfh@i^r|@zrArFpRvOfFxPiEjGmNsJiXin@_No}Gs`IurN{bOotFqxHkeFinEibEqsCiI}SvCsb@");
    expect(servicio.idVehiculo, "6190885bf803e870847c6e73");
    expect(servicio.fechayhora, "2022-03-07T18:00:00.000Z");
    expect(servicio.cantidadCupos, 2);
    expect(servicio.auxilioEconomico, "61f1f9e3d41447b8ea79d2e9");
    expect(servicio.distancia, "4451.591");
    expect(servicio.duracion, "775.477");
    expect(servicio.uid, "122345");
    expect(servicio.nombreConductor, "Hernan");
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
