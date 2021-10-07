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
          tituloInformativo(context),
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
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "RECUPERAR CONTRASEÑA",
          style: TextStyle(
              fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
        ));
  }

  /// Contenedor del titulo informativco para el usuario
  Widget tituloInformativo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Image(
        height: size.width * 0.4,
        image: AssetImage('img/logo/logo_PaDonde.png'));
  }

  /// Contenedor del mensaje informativo para el usuario
  Widget mensajeInformativo() {
    return const Text(
      "Ingresa el correo registrado de tu usuario:",
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
