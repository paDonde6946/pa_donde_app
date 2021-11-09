import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/ui/pages/inicio_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_sesion_pag.dart';
//---------------------------------------------------------------------

class ValidarInicioSesion extends StatelessWidget {
  const ValidarInicioSesion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    height: size.height * 0.23,
                    image: const AssetImage('img/logo/logo_PaDonde.png')),
                const SizedBox(
                  height: 40,
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  strokeWidth: 5,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  /// Validar que el usuario tenga su token activo y si es asi valida el login del usuario
  Future checkLoginState(BuildContext context) async {
    final authService =
        Provider.of<AutenticacionServicio>(context, listen: false);
    // final sockettServicce = Provider.of<SocketServicio>(context);

    final autenticado = await authService.logeado();
    await Future.delayed(const Duration(seconds: 4));
    if (autenticado) {
      // sockettServicce.connect();
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, __, ___) => const InicioPag(),
                transitionDuration: const Duration(milliseconds: 0)));
      });
    } else {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, __, ___) => InicioSesionPag(),
                transitionDuration: const Duration(milliseconds: 0)));
      });
    }
  }
}
