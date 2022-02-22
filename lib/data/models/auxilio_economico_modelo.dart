class AuxilioEconomico {
  AuxilioEconomico({
    this.estado,
    this.valor,
    this.uid,
  });

  int? estado;
  int? valor;
  String? uid;

  factory AuxilioEconomico.fromJson(Map<String, dynamic> json) =>
      AuxilioEconomico(
        estado: json["estado"],
        valor: json["valor"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "valor": valor,
        "uid": uid,
      };
}
