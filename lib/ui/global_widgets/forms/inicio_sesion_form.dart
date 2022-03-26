import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/data/services/notificaciones_push_servicio.dart';
import 'package:provider/provider.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';

import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:pa_donde_app/data/services/vehiculo_servicio.dart';

import 'package:pa_donde_app/blocs/blocs.dart';

import 'package:pa_donde_app/data/models/usuario_modelo.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart';
//---------------------------------------------------------------------

class FormInicioSesion extends StatefulWidget {
  const FormInicioSesion({Key? key}) : super(key: key);

  @override
  State<FormInicioSesion> createState() => _FormInicioSesionState();
}

class _FormInicioSesionState extends State<FormInicioSesion> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerCorreo = TextEditingController();
  TextEditingController inputControllerContrasenia = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.11),
        child: Column(
          children: [
            // const SizedBox(height: 20.0),
            _crearEmail(context),
            SizedBox(height: size.height * 0.01),
            _crearContrasenia(context),
            SizedBox(height: size.height * 0.04),
            _crearBtnInicioSesion(),
          ],
        ),
      ),
    );
  }

  /// Método auxiliar que  ayuda a validar todos los campos del registro
  void _validarFormulario() async {
    // Verfica que todos los campos del formulario esten completos
    if (!keyForm.currentState!.validate()) {
      customShapeSnackBar(
          context: context,
          titulo: "Recuerda que todos los campos son obligatorios");
      return;
    }

    mostrarShowDialogCargando(context: context, titulo: 'INICIANDO SESIÓN');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    // Validar informacion con el backend
    AutenticacionServicio autenticacionServicio =
        Provider.of<AutenticacionServicio>(context, listen: false);

    autenticacionServicio.autenticando = true;
    ServicioPushNotificacion servicioNotificaciones =
        ServicioPushNotificacion(context: context);
    String tokenMensajes = await servicioNotificaciones.initNotifications();
    final response = await autenticacionServicio.login(
        inputControllerCorreo.text.trim(),
        inputControllerContrasenia.text.trim(),
        tokenMensajes);
    if (response == null) {
      customShapeSnackBar(context: context, titulo: 'Información invalida');
    } else {
      FocusScope.of(context).unfocus();
      // Si todo esta bien redirige a la siguiente página
      keyForm.currentState!.save();
      final authService =
          Provider.of<AutenticacionServicio>(context, listen: false);

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

      /// Obtiene los servicios que generales que el usuario puede postularse
      final serviciosGenerales =
          await ServicioRServicio().darServiciosGenerales();

      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarServiciosGenerales(serviciosGenerales));

      // SchedulerBinding.instance!.addPostFrameCallback((_) {
      //   Navigator.push(
      //       context,
      //       PageRouteBuilder(
      //           pageBuilder: (context, __, ___) => const InicioPag(),
      //           transitionDuration: const Duration(milliseconds: 10)));
      // });
      Navigator.pushNamed(context, 'inicio');
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

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  /// Input - Campo correo eléctronico
  Widget _crearEmail(BuildContext context) {
    return TextFormField(
      controller: inputControllerCorreo,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecoration('Correo institucional', 'Ingresa tu correo',
          context, Colors.black, null, 0),
      validator: (value) =>
          (validarEmail(value)) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo de la contraseña
  Widget _crearContrasenia(BuildContext context) {
    return TextFormField(
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => inputControllerContrasenia.text = value,
      decoration: inputDecoration('Contraseña', 'Ingresa tu contraseña',
          context, Colors.black, null, 0),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBtnInicioSesion() {
    return Center(
      child: BtnAnaranja(
          function: () => _validarFormulario(), titulo: 'Iniciar Sesión'),
    );
  }
}
