class Usuario {
  Usuario({String? pCorreo, int? pTipoUsuario, String? pUid}) {
    correo = pCorreo;
    tipoUsuario = pTipoUsuario;
    uid = pUid;
  }

  String? _correo;
  int? _tipoUsuario;
  String? _uid;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        pCorreo: json["correo"],
        pTipoUsuario: json["tipoUsuario"],
        pUid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "tipoUsuario": tipoUsuario,
        "uid": uid,
      };

  get correo => _correo;

  set correo(value) => _correo = value;

  get tipoUsuario => _tipoUsuario;

  set tipoUsuario(value) => _tipoUsuario = value;

  get uid => _uid;

  set uid(value) => _uid = value;
}
