import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/cargando_widget.dart';
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
          return Cargando(size: size);
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

      /// Consulta los vehiculos del usuario
      final preServicios = await ServicioRServicio().getPreServicio();

      BlocProvider.of<PreserviciosBloc>(context)
          .add(OnAgregarVehiculo(preServicios.vehiculos!));

      // Bloc de usuario
      BlocProvider.of<UsuarioBloc>(context)
          .add(OnActualizarUsuario(authService.usuarioServiciosActual));

      BlocProvider.of<PreserviciosBloc>(context)
          .add(OnAgregarPrecios(preServicios.auxilioEconomico!));

      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, __, ___) => const InicioPag(),
                transitionDuration: const Duration(milliseconds: 10)));
      });
    } else {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, __, ___) => const InicioSesionPag(),
                transitionDuration: const Duration(milliseconds: 10)));
      });
    }
  }
}
