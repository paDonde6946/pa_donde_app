import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';

import 'package:pa_donde_app/data/services/usuario_servicio.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_redondo.dart'
    as input_redondo;
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart'
    as validaciones_generales;
//---------------------------------------------------------------------

class FormRegistroUsuario extends StatefulWidget {
  const FormRegistroUsuario({Key? key}) : super(key: key);

  @override
  State<FormRegistroUsuario> createState() => _FormRegistroUsuarioState();
}

class _FormRegistroUsuarioState extends State<FormRegistroUsuario> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();
  String conContrasenia = "";

  Usuario usuario = Usuario();

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerCorreo = TextEditingController();
  TextEditingController inputControllerNombre = TextEditingController();
  TextEditingController inputControllerApellido = TextEditingController();
  TextEditingController inputControllerTelefono = TextEditingController();
  TextEditingController inputControllerConContrasenia = TextEditingController();
  TextEditingController inputControllerContrasenia = TextEditingController();

  final styleInput = const TextStyle(height: 0.4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Espacio entre cada input
    const tamanioSeparador = 15.0;
    // Formulario del registro del usuario
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Column(
          children: [
            const SizedBox(height: tamanioSeparador),
            _crearApellido(usuario),
            const SizedBox(height: tamanioSeparador),
            _crearNombre(usuario),
            const SizedBox(height: tamanioSeparador),
            _crearNumCelular(usuario),
            const SizedBox(height: tamanioSeparador),
            _crearEmail(),
            const SizedBox(height: tamanioSeparador),
            _crearContrasenia(),
            const SizedBox(height: tamanioSeparador),
            _crearConContrasenia(),
            const SizedBox(height: tamanioSeparador),
            _crearBotonRegistro(usuario),
            const SizedBox(height: tamanioSeparador),
          ],
        ),
      ),
    );
  }

  /// Método auxiliar que  ayuda a validar todos los campos del registro
  void _validarFormulario(Usuario usuario) async {
    // Verfica que todos los campos del formulario esten completos
    if (!keyForm.currentState!.validate()) {
      customShapeSnackBar(
          context: context,
          titulo: "Recuerda que todos los campos son obligatorios");
      return;
    }
    // Verifica que las contraseñas coincidan
    if (inputControllerContrasenia.text != inputControllerConContrasenia.text) {
      customShapeSnackBar(
          context: context, titulo: 'Las contraseñas no coinciden');
      return;
    }

    if (!validaciones_generales
        .validarEmailDominio(inputControllerCorreo.text.trim())) {
      customShapeSnackBar(
          context: context,
          titulo: "Solo se permiten correos de la universidad");
      return;
    }

    mostrarShowDialogCargando(context: context, titulo: 'REGISTRANDOTE');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    UsuarioServicio usuarioServicio = UsuarioServicio();
    usuarioServicio.crearUsuarioServicio(usuario);
    //Si todo esta bien redirige a la siguiente página
    keyForm.currentState!.save();
    Navigator.pushNamed(context, 'inicio');

    mostrarShowDialogCargando(context: context, titulo: 'REGISTRO EXITO');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
  }

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  ///  Input - Campo del nombre
  Widget _crearNombre(Usuario usuario) {
    return TextFormField(
      style: styleInput,
      controller: inputControllerNombre,
      decoration: input_redondo.inputDecorationRedondo(
          'Nombre', 'Ingresa tu nombre', context, Colors.white),
      onSaved: (value) => usuario.nombre = value,
      onChanged: (value) => usuario.nombre = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del apellido
  Widget _crearApellido(Usuario usuario) {
    return TextFormField(
      style: styleInput,
      controller: inputControllerApellido,
      decoration: input_redondo.inputDecorationRedondo(
          'Apellido', 'Ingresa tu apellido', context, Colors.white),
      onSaved: (value) => usuario.apellido = value,
      onChanged: (value) => usuario.apellido = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo número de celular
  Widget _crearNumCelular(Usuario usuario) {
    return TextFormField(
      style: styleInput,
      controller: inputControllerTelefono,
      onSaved: (value) => usuario.celular = int.parse(value!),
      onChanged: (value) => usuario.celular = int.parse(value),
      keyboardType: TextInputType.number,
      decoration: input_redondo.inputDecorationRedondo('Número de celular',
          'Ingresa tu número celular', context, Colors.white),
      validator: (value) => (validaciones_generales.isNumber(value!))
          ? null
          : 'Solo se perminten números',
    );
  }

  /// Input - Campo correo eléctronico
  Widget _crearEmail() {
    return TextFormField(
      style: styleInput,
      controller: inputControllerCorreo,
      keyboardType: TextInputType.emailAddress,
      decoration: input_redondo.inputDecorationRedondo(
          'Correo institucional', 'Ingresa tu correo', context, Colors.white),
      onSaved: (value) => usuario.correo = value,
      onChanged: (value) => usuario.correo = value,
      validator: (value) => (validaciones_generales.validarEmail(value) ||
              !validaciones_generales.validarEmailDominio(value))
          ? 'El correo ingresado no es valido'
          : null,
    );
  }

  /// Input - Campo de la contraseña
  Widget _crearContrasenia() {
    return TextFormField(
      style: styleInput,
      controller: inputControllerContrasenia,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onSaved: (value) => usuario.contrasenia = value,
      onChanged: (value) => usuario.contrasenia = value,
      decoration: input_redondo.inputDecorationRedondo(
          'Contraseña', 'Ingresa tu contraseña', context, Colors.white),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo confirmarción de la contraseña
  Widget _crearConContrasenia() {
    return TextFormField(
      style: styleInput,
      controller: inputControllerConContrasenia,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => conContrasenia = value,
      decoration: input_redondo.inputDecorationRedondo('Confirmar Contraseña',
          'Ingresa tu contraseña', context, Colors.white),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  ///_____________________________________________________________________

  // Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBotonRegistro(Usuario usuario) {
    return Center(
      child: BtnAnaranja(
          function: () => _validarFormulario(usuario), titulo: 'Registrarse'),
    );
  }
}
