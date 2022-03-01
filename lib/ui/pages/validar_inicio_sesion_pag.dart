import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/servicios/servicio_bloc.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/services/vehiculo_servicio.dart';
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
    if (autenticado) {
      // sockettServicce.connect();
      /// Agrega en el bloc la informacion del usuario
      BlocProvider.of<UsuarioBloc>(context)
          .add(OnActualizarUsuario(authService.usuarioServiciosActual));

      agregarHistorialesBusqueda(context, authService.usuarioServiciosActual);

      /// Consulta los auxilios economicos que puede tener un servicio
      final auxilioEconomicoServicio =
          await ServicioRServicio().getAuxiliosEconomicos();

      /// Consulta los vehiculos que puede tener un servicio
      final vehiculosServicio = await VehiculoServicio().getVehiculos();

      /// Agrega en el bloc los vehiculos del usuario.
      BlocProvider.of<PreserviciosBloc>(context)
          .add(OnAgregarVehiculo(vehiculosServicio));

      /// Agrega en el bloc los precios establecidos
      BlocProvider.of<PreserviciosBloc>(context)
          .add(OnAgregarPrecios(auxilioEconomicoServicio));

      /// Obtiene los servicios que han sido creados por el usuario
      final serviciosDelUsuario =
          await ServicioRServicio().darServiciosCreadosPorUsuario();

      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarServiciosDelUsuario(serviciosDelUsuario));

      /// Obtiene los servicios que se ha postulado el usuario
      final serviciosPostulados =
          await ServicioRServicio().darServiciosPostuladosPorUsuario();

      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarServiciosPostulados(serviciosPostulados));

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

  void agregarHistorialesBusqueda(BuildContext context, Usuario usuario) {
    for (var feature in usuario.historialOrigen) {
      BlocProvider.of<BusquedaBloc>(context)
          .add(OnAgregarHistorialOrigenEvent(feature));
    }

    for (var feature in usuario.historialDestino) {
      BlocProvider.of<BusquedaBloc>(context)
          .add(OnAgregarHistorialDestionoEvent(feature));
    }
  }
}
