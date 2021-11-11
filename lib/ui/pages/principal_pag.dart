import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/confirmacion_show.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:provider/provider.dart';

//---------------------------------------------------------------------

class PrincipalPag extends StatefulWidget {
  const PrincipalPag({Key? key}) : super(key: key);

  @override
  _PrincipalPagState createState() => _PrincipalPagState();
}

class _PrincipalPagState extends State<PrincipalPag> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(body: body());
  }

  Widget body() {
    final usuario = Provider.of<AutenticacionServicio>(context, listen: false)
        .usuarioServiciosActual;
    //TODO: Cambiar cuando este listo
    // if (usuario.cambio_contrasenia == 0) {
    //   SchedulerBinding.instance!.addPostFrameCallback((_) {
    //     mostrarShowDialogConfirmar(
    //         context: context,
    //         titulo: "Cambio de Contraseña",
    //         contenido:
    //             "Hemos notado que has cambiado tu contraseña. Para mayor seguridad cambia la contraseña por una personal.",
    //         paginaRetorno: 'editarPerfil');
    //     // add your code here.
    //   });
    // }

    return const Center(
      child: Text("Principal"),
    );
  }
}
