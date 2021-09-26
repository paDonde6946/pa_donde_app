import 'dart:convert';

import 'package:pa_donde_app/data/models/usuario_modelo.dart';

InicioSesionResponse inicioSesionResponseFromJson(String str) =>
    InicioSesionResponse.fromJson(json.decode(str));

String inicioSesionResponseToJson(InicioSesionResponse data) =>
    json.encode(data.toJson());

class InicioSesionResponse {
  InicioSesionResponse({
    bool? pOk,
    Usuario? pUsuario,
    String? pToken,
  }) {
    ok = pOk;
    usuario = pUsuario;
    token = pToken;
  }

  bool? _ok;
  Usuario? _usuario;
  String? _token;

  factory InicioSesionResponse.fromJson(Map<String, dynamic> json) =>
      InicioSesionResponse(
        pOk: json["ok"],
        pUsuario: Usuario.fromJson(json["usuario"]),
        pToken: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario?.toJson(),
        "token": token,
      };

  // MÉTODOS GET AND SET

  /// Método que retorna el valor del ok del servicio
  get ok => _ok;

  set ok(pOk) => _ok = pOk;

  get usuario => _usuario;

  set usuario(pUsuario) => _usuario = pUsuario;

  get token => _token;

  set token(pToken) => _token = pToken;
}
