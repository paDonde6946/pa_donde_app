import 'package:flutter/material.dart';
import 'dart:convert';

Vehiculo vehiculoFromJson(String str) => Vehiculo.fromJson(json.decode(str));

String vehiculoToJson(Vehiculo data) => json.encode(data.toJson());

class Vehiculo with ChangeNotifier {
  Vehiculo({
    String? pUid,
    String? pPlaca,
    int? pTipoVehiculo,
    String? pColor,
    String? pMarca,
    String? pAnio,
    String? pModelo,
    int? pDocumentoTitular,
    int? pEstado,
  }) {
    uid = pUid;
    placa = pPlaca;
    tipoVehiculo = pTipoVehiculo;
    color = pColor;
    marca = pMarca;
    anio = pAnio;
    modelo = pModelo;
    estado = pEstado;
  }

  String? _uid;
  String? _placa;
  int? _tipoVehiculo;
  String? _color;
  String? _marca;
  String? _anio;
  String? _modelo;
  int? _documentoTitular;
  int? _estado;

  factory Vehiculo.fromJson(Map<String, dynamic> json) => Vehiculo(
      pUid: json["uid"],
      pPlaca: json["placa"],
      pTipoVehiculo: json["tipoVehiculo"],
      pColor: json["color"],
      pMarca: json["marca"],
      pAnio: json["anio"],
      pModelo: json["modelo"],
      pDocumentoTitular: json["documentoTitular"],
      pEstado: json["estado"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "placa": placa,
        "tipoVehiculo": tipoVehiculo,
        "color": color,
        "marca": marca,
        "anio": anio,
        "modelo": modelo,
        "documentoTitular": documentoTitular,
        "estado": estado,
      };

  // MÉTODOS GET AND SET DE LOS ATRIBUTOS

  /// Método que retorna el valor uid del vehiculo
  get uid => _uid;

  /// Método que cambia el valor uid del vehiculo
  set uid(value) {
    _uid = value;
    notifyListeners();
  }

  /// Método que retorna el valor de la placa del vehiculo
  get placa => _placa;

  /// Método que cambia el valor de la placa del vehiculo
  set placa(value) {
    _placa = value;
    notifyListeners();
  }

  /// Método que retorna el valor del tipo del vehiculo
  get tipoVehiculo => _tipoVehiculo;

  /// Método que cambia el valor del tipo del vehiculo
  set tipoVehiculo(value) {
    _tipoVehiculo = value;
    notifyListeners();
  }

  /// Método que retorna el valor del color del vehiculo
  get color => _color;

  /// Método que cambia el valor del color del vehiculo
  set color(value) {
    _color = value;
    notifyListeners();
  }

  /// Método que retorna el valor de la marca del vehiculo
  get marca => _marca;

  /// Método que cambia el valor de la marca del vehiculo
  set marca(value) {
    _marca = value;
    notifyListeners();
  }

  /// Método que retorna el valor del año del vehiculo
  get anio => _anio;

  /// Método que cambia el valor del año del vehiculo
  set anio(value) {
    _anio = value;
    notifyListeners();
  }

  /// Método que retorna el valor del modelo del vehiculo
  get modelo => _modelo;

  /// Método que cambia el valor del modelo del vehiculo
  set modelo(value) {
    _modelo = value;
    notifyListeners();
  }

  /// Método que retorna el valor del documento de identidad del titular del vehiculo
  get documentoTitular => _documentoTitular;

  /// Método que cambia el valor del documento de identidad del titular del vehiculo
  set documentoTitular(value) {
    _documentoTitular = value;
    notifyListeners();
  }

  /// Método que retorna el valor del estado del vehiculo
  get estado => _estado;

  /// Método que cambia el valor del estado del vehiculo
  set estado(value) {
    _estado = value;
    notifyListeners();
  }
}
