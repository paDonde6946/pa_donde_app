import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/recuperar_contrasenia_form.dart';

class RecuperarContraseniaPag extends StatelessWidget {
  const RecuperarContraseniaPag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        children: [
          SizedBox(height: size.height * 0.04),
          tituloInformativo(),
          SizedBox(height: size.height * 0.02),
          mensajeInformativo(),
          SizedBox(height: size.height * 0.02),
          const RecuperarContraseniaForm()
        ],
      ),
    );
  }

  /// Encabezado de la pagina
  PreferredSizeWidget appBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      title: Image(
          height: size.width * 0.15,
          image: const AssetImage('img/logo/logo_PaDonde.png')),
      centerTitle: true,
    );
  }

  /// Contenedor del titulo informativco para el usuario
  Widget tituloInformativo() {
    return const Text(
      "Recuperar contraseña",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  /// Contenedor del mensaje informativo para el usuario
  Widget mensajeInformativo() {
    return const Text(
      "Debe de ingresar el correo registrado en el aplicativo, luego de eso debe de ver en su correo la confirmación de su nueva contraseña por defecto que puede cambiar una vez halla iniciado sesión.",
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
