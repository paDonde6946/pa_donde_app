//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
//---------------------------------------------------------------------

class VehiculosResponse {
  VehiculosResponse({
    this.ok,
    this.vehiculos,
  });

  bool? ok;
  List<Vehiculo>? vehiculos;

  factory VehiculosResponse.fromJson(Map<String, dynamic> json) =>
      VehiculosResponse(
        ok: json["ok"],
        vehiculos: List<Vehiculo>.from(
            json["vehiculos"].map((x) => Vehiculo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "vehiculos": List<dynamic>.from(vehiculos!.map((x) => x.toJson())),
      };
}
