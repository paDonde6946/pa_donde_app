import 'dart:convert';

List<Mensaje> mensajeFromJson(String str) =>
    List<Mensaje>.from(json.decode(str).map((x) => Mensaje.fromJson(x)));

String mensajeToJson(List<Mensaje> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mensaje {
  Mensaje({
    this.para,
    this.mensaje,
    this.servicio,
    this.de,
  });

  String? para;
  String? mensaje;
  String? servicio;
  String? de;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        para: json["para"],
        mensaje: json["mensaje"],
        servicio: json["servicio"],
        de: json["de"],
      );

  Map<String, dynamic> toJson() => {
        "para": para,
        "mensaje": mensaje,
        "servicio": servicio,
        "de": de,
      };
}
