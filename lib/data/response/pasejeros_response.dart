import 'package:pa_donde_app/data/models/pasajeros_modelo.dart';

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
