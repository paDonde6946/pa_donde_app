import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/editar_contrasenia_form.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/editar_perfil_form.dart';

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
      children: [
        const SizedBox(height: 40),
        const FormEditarContrasenia()
      ],
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
          "Editar Contraseña",
          style: TextStyle(
              fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
        ));
  }

  /// Panel superior verde (Titulo de la pagina)
  Widget panelSuperior() {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      height: 120,
      child: Column(
        children: [
          Icon(
            Icons.directions_car_filled_outlined,
            size: size.height * 0.1,
          ),
          Text(
            "Editar Contraseña",
            style: TextStyle(fontSize: size.width * 0.06),
          ),
        ],
      ),
    );
  }
}
