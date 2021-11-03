import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class PrincipalPag extends StatefulWidget {
  PrincipalPag({Key? key}) : super(key: key);

  @override
  _PrincipalPagState createState() => _PrincipalPagState();
}

class _PrincipalPagState extends State<PrincipalPag> {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AutenticacionServicio>(context, listen: false)
        .usuarioServiciosActual;

    print(usuario.apellido);

    return Scaffold(body: Consumer<AutenticacionServicio>(
      builder: (context, cart, child) {
        return Text("Total price: ${cart.usuarioServiciosActual.apellido}");
      },
    ));
  }
}
