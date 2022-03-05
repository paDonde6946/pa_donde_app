// To parse this JSON data, do
//
//     final pasejeros = pasejerosFromJson(jsonString);

import 'dart:convert';

Pasejeros pasejerosFromJson(String str) => Pasejeros.fromJson(json.decode(str));

class Pasejeros {
  Pasejeros({
    this.pasajeros,
  });

  List<PasajeroElement>? pasajeros;

  factory Pasejeros.fromJson(Map<String, dynamic> json) => Pasejeros(
        pasajeros: List<PasajeroElement>.from(
            json["pasajeros"].map((x) => PasajeroElement.fromJson(x))),
      );
}

class PasajeroElement {
  PasajeroElement({
    this.pasajero,
    this.id,
  });

  Pasajero? pasajero;
  String? id;

  factory PasajeroElement.fromJson(Map<String, dynamic> json) =>
      PasajeroElement(
        pasajero: Pasajero.fromJson(json["pasajero"]),
        id: json["_id"],
      );
}

class Pasajero {
  Pasajero({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Pasajero.fromJson(dynamic json) => Pasajero(
        id: json["_id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
      };
}
