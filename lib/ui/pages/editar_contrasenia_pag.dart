import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/editar_contrasenia_form.dart';

class EditarContraseniaPag extends StatefulWidget {
  const EditarContraseniaPag({Key? key}) : super(key: key);

  @override
  _EditarContraseniaPagState createState() => _EditarContraseniaPagState();
}

class _EditarContraseniaPagState extends State<EditarContraseniaPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: body());
  }

  Widget body() {
    return ListView(
      children: const [SizedBox(height: 40), FormEditarContrasenia()],
    );
  }

  /// Encabezado de la pagina
  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Editar contraseña",
          style: TextStyle(
              fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
        ));
  }
}
