import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/text/formulario_texto.dart';

import 'package:pa_donde_app/data/services/usuario_servicio.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
//---------------------------------------------------------------------

class FormEditarContrasenia extends StatefulWidget {
  const FormEditarContrasenia({Key? key}) : super(key: key);

  @override
  State<FormEditarContrasenia> createState() => _FormEditarContraseniaState();
}

class _FormEditarContraseniaState extends State<FormEditarContrasenia> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerConContrasenia = TextEditingController();
  TextEditingController inputControllerContrasenia = TextEditingController();

  final styleInput = const TextStyle(height: 0.4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    /// Variable que nos permite guardar la información de cada uno de los registros
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.11),
        child: Column(
          children: [
            _nombreLabel(_crearContrasenia(context), 'Contraseña'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(_crearConContrasenia(), 'Repetir contraseña'),
            SizedBox(height: size.height * 0.04),
            _crearBtnInicioSesion(),
          ],
        ),
      ),
    );
  }

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  Widget _nombreLabel(Widget widget, String texto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textoRegular(texto: texto, context: context),
        const SizedBox(height: 2),
        widget
      ],
    );
  }

  /// Input - Campo de la contraseña
  Widget _crearContrasenia(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => inputControllerContrasenia.text = value,
      decoration: inputDecoration('', 'Nueva contraseña', context,
          Theme.of(context).primaryColor, null, 0),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo confirmarción de la contraseña
  Widget _crearConContrasenia() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => inputControllerConContrasenia.text = value,
      decoration: inputDecoration('', 'Repetir nueva contraseña', context,
          Theme.of(context).primaryColor, null, 0),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBtnInicioSesion() {
    final size = MediaQuery.of(context).size;

    return Center(
      child: BtnAnaranja(
          tamanioLetra: size.width * 0.036,
          function: validarContrasenia,
          titulo: 'Editar contraseña'),
    );
  }

  void validarContrasenia() async {
    // Verifica que las contraseñas coincidan
    if (inputControllerContrasenia.text != inputControllerConContrasenia.text) {
      customShapeSnackBar(
          context: context, titulo: 'Las contraseñas no coinciden');
      return;
    }
    mostrarShowDialogCargando(
        context: context, titulo: 'Guardando Información');
    await Future.delayed(const Duration(seconds: 1));

    // Validar informacion con el backend
    UsuarioServicio usuarioServicio = UsuarioServicio();
    final response = await usuarioServicio
        .cambiarContrasenia(inputControllerContrasenia.text.trim());

    if (mounted) {
      // ignore: unnecessary_null_comparison
      if (response == null) {
        customShapeSnackBar(context: context, titulo: 'Información invalida');
      } else {
        final usuario = BlocProvider.of<UsuarioBloc>(context).state.usuario;
        usuario.cambioContrasenia = 0;
        BlocProvider.of<UsuarioBloc>(context).add(OnActualizarUsuario(usuario));
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }
}
