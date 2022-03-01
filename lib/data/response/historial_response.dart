import 'dart:convert';

import 'package:pa_donde_app/data/models/servicio_modelo.dart';

HistorialResponse historialResponseFromJson(String str) => HistorialResponse.fromJson(json.decode(str));

String historialResponseToJson(HistorialResponse data) => json.encode(data.toJson());

class HistorialResponse {
    HistorialResponse({
        this.ok,
        this.serviciosComoConductor,
        this.serviciosComoUsuario,
    });

    bool? ok;
    List<Servicio>? serviciosComoConductor;
    List<Servicio>? serviciosComoUsuario;

    factory HistorialResponse.fromJson(Map<String, dynamic> json) => HistorialResponse(
        ok: json["ok"],
        serviciosComoConductor: List<Servicio>.from(json["serviciosComoConductor"].map((x) => Servicio.fromJson(x))),
        serviciosComoUsuario: List<Servicio>.from(json["serviciosComoUsuario"].map((x) => Servicio.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "serviciosComoConductor": List<dynamic>.from(serviciosComoConductor!.map((x) => x.toJson())),
        "serviciosComoUsuario": List<dynamic>.from(serviciosComoUsuario!.map((x) => x.toJson())),
    };
}