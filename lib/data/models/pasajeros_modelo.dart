class Pasajero {
  Pasajero({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Pasajero.fromJson(dynamic json) => Pasajero(
        id: json[0].toString(),
        nombre: json[1],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
      };
}
