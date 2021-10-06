/* Método para validar si el valor por parametro es un número */
bool isNumber(String value) {
  if (value.isEmpty) return false;

  final n = num.tryParse(value);

  return (n == null) ? false : true;
}

/* Método para validar un correo eléctronico */
bool validarEmail(String? email) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);

  if (regExp.hasMatch(email!)) {
    return false;
  } else {
    return true;
  }
}

/* Método para validar un correo eléctronico tenga el dominio de la universidad*/
bool validarEmailDominio(String? email) {
  String pattern = "@unbosque.edu.co";

  if (email!.contains(pattern)) {
    return true;
  }
  return false;
}
