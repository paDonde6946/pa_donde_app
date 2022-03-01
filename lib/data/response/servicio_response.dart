import 'dart:convert';

import 'package:pa_donde_app/data/models/servicio_modelo.dart';

ServicioResponse servicioResponseFromJson(String str) =>
    ServicioResponse.fromJson(json.decode(str));

String servicioResponseToJson(ServicioResponse data) =>
    json.encode(data.toJson());

class ServicioResponse {
  ServicioResponse({
    this.ok,
    this.servicios,
  });

  bool? ok;
  List<Servicio>? servicios;

  factory ServicioResponse.fromJson(Map<String, dynamic> json) =>
      ServicioResponse(
        ok: json["ok"],
        servicios: List<Servicio>.from(
            json["servicios"].map((x) => Servicio.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "servicios": List<dynamic>.from(servicios!.map((x) => x.toJson())),
      };
}

class Pasajero {
  Pasajero({
    this.id,
    this.pasajero,
  });

  String? id;
  String? pasajero;

  factory Pasajero.fromJson(Map<String, dynamic> json) => Pasajero(
        id: json["_id"],
        pasajero: json["pasajero"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "pasajero": pasajero,
      };
}
