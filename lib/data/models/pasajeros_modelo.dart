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
