class Usuario {
  Usuario(correo, tipoUsuario, uid) {
    this.correo = correo;
    this.tipoUsuario = tipoUsuario;
    this.uid = uid;
  }

  String _correo;
  int _tipoUsuario;
  String _uid;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        correo: json["correo"],
        tipoUsuario: json["tipoUsuario"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "tipoUsuario": tipoUsuario,
        "uid": uid,
      };
}
