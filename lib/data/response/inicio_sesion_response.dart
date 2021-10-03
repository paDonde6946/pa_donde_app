import 'dart:convert';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
//---------------------------------------------------------------------

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

  /// ATRIBUTOS DE LA CLASE
  bool? _ok;
  Usuario? _usuario;
  String? _token;

  /// Constructor para transformar de un Mapa dinamico a json
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

  // MÉTODOS GET AND SET DE LOS ATRIBUTOS

  /// Método que retorna el valor del ok del servicio que valida  que la
  /// petición halla  salido correctamente
  get ok => _ok;

  /// Método que cambia el valor de Ok de la petición
  set ok(pOk) => _ok = pOk;

  /// Método que retorna el usuario con toda la información que trae la petición
  get usuario => _usuario;

  /// Método que cambia el usuario de la petición
  set usuario(pUsuario) => _usuario = pUsuario;

  /// Método que retorna el token para la autencitación del servicio
  get token => _token;

  /// Método que cambia el token para la autenticación del servicio
  set token(pToken) => _token = pToken;
}
