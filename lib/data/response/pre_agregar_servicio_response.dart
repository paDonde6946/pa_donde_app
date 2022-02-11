//     final preAgregarServicioResponse = preAgregarServicioFromJson(jsonString);

import 'dart:convert';

import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';

PreAgregarServicioResponse preAgregarServicioResponseFromJson(String str) =>
    PreAgregarServicioResponse.fromJson(json.decode(str));

String preAgregarServicioResponseToJson(PreAgregarServicioResponse data) =>
    json.encode(data.toJson());

class PreAgregarServicioResponse {
  PreAgregarServicioResponse({
    this.ok,
    this.vehiculos,
    this.auxilioEconomico,
  });

  bool? ok;
  List<Vehiculo>? vehiculos;
  List<AuxilioEconomico>? auxilioEconomico;

  factory PreAgregarServicioResponse.fromJson(Map<String, dynamic> json) =>
      PreAgregarServicioResponse(
        ok: json["ok"],
        vehiculos: List<Vehiculo>.from(
            json["vehiculos"].map((x) => Vehiculo.fromJson(x))),
        auxilioEconomico: List<AuxilioEconomico>.from(
            json["auxilioEconomico"].map((x) => AuxilioEconomico.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "vehiculos": List<dynamic>.from(vehiculos!.map((x) => x.toJson())),
        "auxilioEconomico":
            List<dynamic>.from(auxilioEconomico!.map((x) => x.toJson())),
      };
}

class AuxilioEconomico {
  AuxilioEconomico({
    this.estado,
    this.valor,
    this.uid,
  });

  int? estado;
  int? valor;
  String? uid;

  factory AuxilioEconomico.fromJson(Map<String, dynamic> json) =>
      AuxilioEconomico(
        estado: json["estado"],
        valor: json["valor"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "valor": valor,
        "uid": uid,
      };
}
