//     final preAgregarServicioResponse = preAgregarServicioFromJson(jsonString);

import 'dart:convert';

import 'package:pa_donde_app/data/models/auxilio_economico_modelo.dart';

AuxilioEconomicoResponse auxilioEconomicoResponseFromJson(String str) =>
    AuxilioEconomicoResponse.fromJson(json.decode(str));

String auxilioEconomicoResponseToJson(AuxilioEconomicoResponse data) =>
    json.encode(data.toJson());

class AuxilioEconomicoResponse {
  AuxilioEconomicoResponse({
    this.ok,
    this.auxilioEconomico,
  });

  bool? ok;
  List<AuxilioEconomico>? auxilioEconomico;

  factory AuxilioEconomicoResponse.fromJson(Map<String, dynamic> json) =>
      AuxilioEconomicoResponse(
        ok: json["ok"],
        auxilioEconomico: List<AuxilioEconomico>.from(
            json["auxilioEconomico"].map((x) => AuxilioEconomico.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "auxilioEconomico":
            List<dynamic>.from(auxilioEconomico!.map((x) => x.toJson())),
      };
}
