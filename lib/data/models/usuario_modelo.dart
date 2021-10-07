import 'dart:convert';

import 'package:flutter/cupertino.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario with ChangeNotifier {
  Usuario(
      {String? pCorreo,
      int? pTipoUsuario,
      String? pNombre,
      String? pApellido,
      int? pCelular,
      String? pConstrasenia,
      int? pCambioContrasenia,
      String? pUid}) {
    correo = pCorreo;
    tipoUsuario = pTipoUsuario;
    nombre = pNombre;
    apellido = pApellido;
    celular = pCelular;
    contrasenia = pConstrasenia;
    cambio_contrasenia = pCambioContrasenia;
    uid = pUid;
  }

  /// ATRIBUTOS DE LA CLASE
  String? _nombre;
  String? _apellido;
  int? _celular;
  String? _correo;
  int? _tipoUsuario;
  String? _contrasenia;
  int? _cambio_contrasenia;
  String? _uid;

  /// Constructor para transformar de un Mapa dinamico a json
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        pCorreo: json["correo"],
        pTipoUsuario: json["tipoUsuario"],
        pNombre: json["nombre"],
        pApellido: json["apellido"],
        pCelular: json["celular"],
        pConstrasenia: json["contrasenia"],
        pCambioContrasenia: json["cambio_contrasenia"],
        pUid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "nombre": nombre,
        "apellido": apellido,
        "celular": celular,
        "contrasenia": contrasenia,
        "cambio_contrasenia": cambio_contrasenia
      };

  // MÉTODOS GET AND SET DE LOS ATRIBUTOS

  /// Método que retorna el valor nombre del usuario
  get nombre => _nombre;

  /// Método que cambia el valor nombre del usuario
  set nombre(value) {
    _nombre = value;
    notifyListeners();
  }

  /// Método que retorna el valor del apellido del usuario
  get apellido => _apellido;

  /// Método que cambia el valor del apellido del usuario
  set apellido(value) {
    _apellido = value;
    notifyListeners();
  }

  /// Método que retorna el valor del número celular
  get celular => _celular;

  /// Método que cambia el valor del número celular
  set celular(value) {
    _celular = value;
    notifyListeners();
  }

  /// Método que retorna el valor correo electronico
  get correo => _correo;

  /// Método que cambia el valor correo electronico
  set correo(value) {
    _correo = value;
    notifyListeners();
  }

  /// Método que retorna el valor del tipo de usuario que esta ingresando
  get tipoUsuario => _tipoUsuario;

  /// Método que cambia el valor del tipo de usuario que esta ingresando
  set tipoUsuario(value) {
    _tipoUsuario = value;
    notifyListeners();
  }

  /// Método que retorna el valor de la contraseña del usuario
  get contrasenia => _contrasenia;

  /// Método que cambia el valor de la contraseña del usuario
  set contrasenia(value) {
    _contrasenia = value;
    notifyListeners();
  }

  /// Método que retorna el valor de cabmiar la contrasenia
  get cambio_contrasenia => _cambio_contrasenia;

  /// Método que cambia el valor de la contraseña del usuario
  set cambio_contrasenia(value) {
    _cambio_contrasenia = value;
    notifyListeners();
  }

  /// Método que retorna el valor de uid (Identificador para inicio de sesión)
  get uid => _uid;

  /// Método que cambia el valor de uid (Identificador para inicio de sesión)
  set uid(value) => _uid = value;
}
