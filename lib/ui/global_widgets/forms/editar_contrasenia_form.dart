import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/services/usuario_servicio.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_elevado.dart';
import 'package:pa_donde_app/ui/global_widgets/text/formulario_texto.dart';

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
            _nombreLabel(
                _crearContrasenia(context), 'Contraseña'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(
                _crearConContrasenia(), 'Repetir Contraseña'),
            SizedBox(height: size.height * 0.04),
            _crearBtnInicioSesion(),
          ],
        ),
      ),
    );
  }

  // /// Método auxiliar que  ayuda a validar todos los campos del registro
  // void _validarFormulario() async {
  //   // Verfica que todos los campos del formulario esten completos
  //   if (!keyForm.currentState!.validate()) {
  //     customShapeSnackBar(
  //         context: context,
  //         titulo: "Recuerda que todos los campos son obligatorios");
  //     return;
  //   }

  //   mostrarShowDialogCargando(
  //       context: context, titulo: 'Guardando Información');
  //   await Future.delayed(const Duration(seconds: 1));
  //   Navigator.pop(context);

  //   // Validar informacion con el backend
  //   AutenticacionServicio autenticacionServicio = AutenticacionServicio();
  //   final response = await autenticacionServicio.login(
  //       inputControllerCorreo.text.trim(),
  //       inputControllerContrasenia.text.trim());

  //   if (response == null) {
  //     customShapeSnackBar(context: context, titulo: 'Información invalida');
  //   } else {
  //     // Si todo esta bien redirige a la siguiente página
  //     keyForm.currentState!.save();
  //     Navigator.pushNamed(context, 'inicio');
  //   }
  // }

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
      style: styleInput,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => inputControllerContrasenia.text = value,
      decoration:
          inputDecoration('', 'Nueva contraseña', context, Theme.of(context).primaryColor, null, 0),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo confirmarción de la contraseña
  Widget _crearConContrasenia() {
    return TextFormField(
      style: styleInput,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => inputControllerConContrasenia.text = value,
      decoration: inputDecoration(
          '', 'Repetir nueva contraseña', context, Theme.of(context).primaryColor, null, 0),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBtnInicioSesion() {
    return Center(
      child: BtnAnaranja(
          function: () => validarContrasenia(), titulo: 'Editar Contraseña'),
    );
  }

  void validarContrasenia() async {
    // Verifica que las contraseñas coincidan
    if (inputControllerContrasenia.text != inputControllerConContrasenia.text) {
      customShapeSnackBar(
          context: context, titulo: 'Las contraseñas no coinciden');
      return;
    }
    // mostrarShowDialogCargando(
    //     context: context, titulo: 'Guardando Información');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    // Validar informacion con el backend
    UsuarioServicio usuarioServicio = UsuarioServicio();
    final response = await usuarioServicio
        .cambiarContrasenia(inputControllerContrasenia.text.trim());

    if (response == null) {
      customShapeSnackBar(context: context, titulo: 'Información invalida');
    } else {
      // Si todo esta bien redirige a la siguiente página
      keyForm.currentState!.save();
    }
  }
}
