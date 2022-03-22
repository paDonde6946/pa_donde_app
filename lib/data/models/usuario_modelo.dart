import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:pa_donde_app/data/response/busqueda_response.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario with ChangeNotifier {
  Usuario({
    String? pCorreo,
    int? pTipoUsuario,
    String? pNombre,
    String? pApellido,
    int? pCelular,
    String? pConstrasenia,
    int? pCambioContrasenia,
    String? pUid,
    double? pCalificacionUsuario,
    double? pCalificacionConductor,
    List<Feature>? pHistorialOrigen,
    List<Feature>? pHistorialDestino,
    String? pUltimoServicioCalificar,
  }) {
    correo = pCorreo;
    tipoUsuario = pTipoUsuario;
    nombre = pNombre;
    apellido = pApellido;
    celular = pCelular;
    contrasenia = pConstrasenia;
    cambioContrasenia = pCambioContrasenia;
    uid = pUid;
    calificacionUsuario = pCalificacionUsuario;
    calificacionConductor = pCalificacionConductor;
    historialOrigen = pHistorialOrigen;
    historialDestino = pHistorialDestino;
    ultimoServicioCalificar = pUltimoServicioCalificar;
  }

  /// ATRIBUTOS DE LA CLASE
  String? _nombre;
  String? _apellido;
  int? _celular;
  String? _correo;
  int? _tipoUsuario;
  String? _contrasenia;
  int? _cambioContrasenia;
  String? _uid;
  double? _calificacionUsuario;
  double? _calificacionConductor;
  List<Feature>? _historialOrigen;
  List<Feature>? _historialDestino;
  String? _ultimoServicioCalificar;

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
      pCalificacionUsuario: json["calificacionUsuario"].toDouble(),
      pCalificacionConductor: json["calificacionConductor"].toDouble(),
      pHistorialDestino: json["historialDestino"] != null
          ? List<Feature>.from(
              json["historialDestino"].map((x) => Feature.fromJson(x)))
          : [],
      pHistorialOrigen: json["historialDestino"] != null
          ? List<Feature>.from(
              json["historialOrigen"]?.map((x) => Feature.fromJson(x)))
          : [],
      pUltimoServicioCalificar: json["ultimoServicioSinCalificar"]);

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "nombre": nombre,
        "apellido": apellido,
        "celular": celular,
        "contrasenia": contrasenia,
        "cambio_contrasenia": cambioContrasenia,
        "calificacionUsuario": calificacionUsuario,
        "calificacionConductor": calificacionConductor,
        "ultimoServicioSinCalificar": ultimoServicioCalificar
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
  get cambioContrasenia => _cambioContrasenia;

  /// Método que cambia el valor de la contraseña del usuario
  set cambioContrasenia(value) {
    _cambioContrasenia = value;
    notifyListeners();
  }

  /// Método que retorna el valor de uid (Identificador para inicio de sesión)
  get uid => _uid;

  /// Método que cambia el valor de uid (Identificador para inicio de sesión)
  set uid(value) {
    _uid = value;
    notifyListeners();
  }

  get calificacionUsuario => _calificacionUsuario;

  set calificacionUsuario(value) {
    _calificacionUsuario = value;
    notifyListeners();
  }

  get calificacionConductor => _calificacionConductor;

  set calificacionConductor(value) {
    _calificacionConductor = value;
    notifyListeners();
  }

  get historialOrigen => _historialOrigen;

  set historialOrigen(value) {
    _historialOrigen = value;
  }

  get historialDestino => _historialDestino;

  set historialDestino(value) {
    _historialDestino = value;
  }

  get ultimoServicioCalificar => _ultimoServicioCalificar;

  set ultimoServicioCalificar(value) {
    _ultimoServicioCalificar = value;
  }
}
