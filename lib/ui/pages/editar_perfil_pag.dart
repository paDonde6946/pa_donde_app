import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/editar_perfil_form.dart';

class EditarPerfilPag extends StatefulWidget {
  EditarPerfilPag({Key? key}) : super(key: key);

  @override
  _EditarPerfilPagState createState() => _EditarPerfilPagState();
}

class _EditarPerfilPagState extends State<EditarPerfilPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: ListView(
          children: [FormEditarPerfil()],
        ));
  }

  /// Encabezado de la pagina
  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "EDITAR PERFIL",
          style: TextStyle(
              fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
        ));
  }
}
