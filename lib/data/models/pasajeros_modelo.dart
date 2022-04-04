class Pasajero {
  Pasajero({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Pasajero.fromJson(dynamic json) => Pasajero(
        id: json["_id"].toString(),
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
      };
}
