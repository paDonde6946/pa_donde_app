import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario(
      {String? pCorreo,
      int? pTipoUsuario,
      String? pNombre,
      String? pApellido,
      int? pCelular,
      String? pConstrasenia,
      String? pUid}) {
    correo = pCorreo;
    tipoUsuario = pTipoUsuario;
    nombre = pNombre;
    apellido = pApellido;
    celular = pCelular;
    contrasenia = pConstrasenia;
    uid = pUid;
  }

  /// ATRIBUTOS DE LA CLASE
  String? _nombre;
  String? _apellido;
  int? _celular;
  String? _correo;
  int? _tipoUsuario;
  String? _uid;
  String? _contrasenia;

  /// Constructor
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        pCorreo: json["correo"],
        pTipoUsuario: json["tipoUsuario"],
        pNombre: json["nombre"],
        pApellido: json["apellido"],
        pCelular: json["celular"],
        pConstrasenia: json["contrasenia"],
        pUid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "nombre": nombre,
        "apellido": apellido,
        "celular": celular,
        "contrasenia": contrasenia,
      };

  get nombre => _nombre;

  set nombre(value) => _nombre = value;

  get apellido => _apellido;

  set apellido(value) => _apellido = value;

  get celular => _celular;

  set celular(value) => _celular = value;

  get correo => _correo;

  set correo(value) => _correo = value;

  get tipoUsuario => _tipoUsuario;

  set tipoUsuario(value) => _tipoUsuario = value;

  get contrasenia => _contrasenia;

  set contrasenia(value) => _contrasenia = value;

  get uid => _uid;

  set uid(value) => _uid = value;
}
