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
