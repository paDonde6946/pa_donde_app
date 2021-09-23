import 'dart:convert';

import 'package:pa_donde_app/data/models/usuario_modelo.dart';

InicioSesionResponse inicioSesionResponseFromJson(String str) =>
    InicioSesionResponse.fromJson(json.decode(str));

String inicioSesionResponseToJson(InicioSesionResponse data) =>
    json.encode(data.toJson());

class InicioSesionResponse {
  InicioSesionResponse({
    this.ok = false,
    this.usuario = Usuario(),
    this.token,
  });

  bool ok;
  Usuario usuario;
  String token;

  factory InicioSesionResponse.fromJson(Map<String, dynamic> json) =>
      InicioSesionResponse(
        ok: json["ok"],
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
        "token": token,
      };
}
