import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';

import 'package:pa_donde_app/data/services/usuario_servicio.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';
import 'package:pa_donde_app/global/regexp/regexp_locales.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_redondo.dart'
    as input_redondo;
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';

import 'package:pa_donde_app/ui/global_widgets/show_dialogs/confirmacion_show.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart'
    as validaciones_generales;
import 'package:url_launcher/url_launcher.dart';
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
  TextEditingController inputControllerCedula = TextEditingController();

  bool validarPolitica = false;

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
            _crearNombre(usuario),
            const SizedBox(height: tamanioSeparador),
            _crearApellido(usuario),
            const SizedBox(height: tamanioSeparador),
            _crearCedula(usuario),
            const SizedBox(height: tamanioSeparador),
            _crearNumCelular(usuario),
            const SizedBox(height: tamanioSeparador),
            _crearEmail(),
            const SizedBox(height: tamanioSeparador),
            _crearContrasenia(),
            const SizedBox(height: tamanioSeparador),
            _crearConContrasenia(),
            const SizedBox(height: tamanioSeparador),
            _crearCheckPoltica(),
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

    try {
      usuario.cedula = int.parse(inputControllerCedula.value.text);
    } catch (e) {
      customShapeSnackBar(
          context: context, titulo: 'Número de la cédula inválido');

      return;
    }

    try {
      if (inputControllerTelefono.text.length < 10) {
        customShapeSnackBar(
            context: context,
            titulo: 'El número de celular debe de tener 10 dígitos');
        return;
      }
      usuario.celular = int.parse(inputControllerTelefono.value.text);
    } catch (e) {
      customShapeSnackBar(
          context: context, titulo: 'Número del celular inválido');

      return;
    }

    // Verifica que las contraseñas coincidan
    if (inputControllerContrasenia.text != inputControllerConContrasenia.text) {
      customShapeSnackBar(
          context: context, titulo: 'Las contraseñas no coinciden');
      return;
    }

    // Verifica que la contraseña sea fiable
    if (!RegExpLocales.expresionContrasenia
        .hasMatch(inputControllerContrasenia.text)) {
      customShapeSnackBar(
          context: context,
          titulo:
              'Las contraseñas debe tener: \n     - Una minuscula \n     - Una mayuscula \n     - Un numero \n     - Un simbolo');
      return;
    }

    if (!RegExpLocales.expresionSoloLetras
        .hasMatch(inputControllerNombre.text)) {
      customShapeSnackBar(
          context: context,
          titulo: 'El nombre no debe de contener caracteres especiales');
      return;
    }

    if (!RegExpLocales.expresionSoloLetras
        .hasMatch(inputControllerApellido.text)) {
      customShapeSnackBar(
          context: context,
          titulo: 'El apellido no debe de contener caracteres especiales');
      return;
    }

    if (!validaciones_generales
        .validarEmailDominio(inputControllerCorreo.text.trim())) {
      customShapeSnackBar(
          context: context,
          titulo:
              "Solo se permiten correos institucionales (@unbosque.edu.co)");
      return;
    }

    if (!validarPolitica) {
      customShapeSnackBar(
          context: context,
          titulo: "Debe de aceptar las políticas de privacidad");
      return;
    }

    mostrarShowDialogCargando(context: context, titulo: 'REGISTRANDOTE');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    UsuarioServicio usuarioServicio = UsuarioServicio();
    final response =
        await usuarioServicio.crearUsuarioServicio(usuario, context);
    // Si todo esta bien redirige a la siguiente página
    keyForm.currentState!.save();

    if (response[0] == false) {
      customShapeSnackBar(context: context, titulo: "Error al registrarse");
    } else {
      mostrarShowDialogCargando(context: context, titulo: 'REGISTRO ÉXITOSO');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);

      mostrarShowDialogConfirmar(
          context: context,
          titulo: "Registro",
          contenido:
              "Para completar su registro verifique el correo que ingresó, para confirmar su registro",
          paginaRetorno: 'validarInicioSesion');
    }
  }

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  ///  Input - Campo del nombre
  Widget _crearNombre(Usuario usuario) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: inputControllerNombre,
      decoration: input_redondo.inputDecorationRedondo(
          'Nombre', 'Ingrese su nombre', context, Colors.white),
      onSaved: (value) => usuario.nombre = value,
      onChanged: (value) => usuario.nombre = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del nombre
  Widget _crearCedula(Usuario usuario) {
    return TextFormField(
      keyboardType: TextInputType.number,
      cursorColor: Theme.of(context).primaryColor,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: input_redondo.inputDecorationRedondo(
          'Cédula', 'Ingrese su cédula', context, Colors.white),
      onSaved: (value) => inputControllerCedula.text = value!,
      onChanged: (value) => inputControllerCedula.text = value,
      validator: (value) => (validaciones_generales.isNumber(value!))
          ? null
          : 'Solo se permiten números',
    );
  }

  ///  Input - Campo del apellido
  Widget _crearApellido(Usuario usuario) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: inputControllerApellido,
      decoration: input_redondo.inputDecorationRedondo(
          'Apellido', 'Ingrese su apellido', context, Colors.white),
      onSaved: (value) => usuario.apellido = value,
      onChanged: (value) => usuario.apellido = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo número de celular
  Widget _crearNumCelular(Usuario usuario) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      onSaved: (value) => inputControllerTelefono.text = value!,
      onChanged: (value) => inputControllerTelefono.text = value,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: input_redondo.inputDecorationRedondo('Número de celular',
          'Ingrese su número celular', context, Colors.white),
      validator: (value) => (validaciones_generales.isNumber(value!))
          ? null
          : 'Solo se permiten números',
    );
  }

  /// Input - Campo correo eléctronico
  Widget _crearEmail() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: inputControllerCorreo,
      keyboardType: TextInputType.emailAddress,
      decoration: input_redondo.inputDecorationRedondo(
          'Correo institucional', 'Ingrese su correo', context, Colors.white),
      onSaved: (value) => usuario.correo = value!.trim(),
      onChanged: (value) => usuario.correo = value.trim(),
      validator: (value) => (validaciones_generales.validarEmail(value) ||
              !validaciones_generales.validarEmailDominio(value))
          ? 'El correo ingresado no es valido'
          : null,
    );
  }

  /// Input - Campo de la contraseña
  Widget _crearContrasenia() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: inputControllerContrasenia,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onSaved: (value) => usuario.contrasenia = value,
      onChanged: (value) => usuario.contrasenia = value,
      decoration: input_redondo.inputDecorationRedondo(
          'Contraseña', 'Ingrese su contraseña', context, Colors.white),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo confirmarción de la contraseña
  Widget _crearConContrasenia() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: inputControllerConContrasenia,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => conContrasenia = value,
      decoration: input_redondo.inputDecorationRedondo('Confirmar Contraseña',
          'Ingrese su contraseña', context, Colors.white),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  Widget _crearCheckPoltica() {
    return CheckboxListTile(
        title: GestureDetector(
          onTap: _launchURL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Acepta las políticas de",
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: const [
                  Text(
                    "privacidad ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    " (Ver)",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.white,
        checkColor: Colors.black,
        value: validarPolitica,
        onChanged: (value) {
          setState(() {
            validarPolitica = value!;
          });
        });
  }

  void _launchURL() async {
    if (!await launch(EntornoVariable.urlPoliticaPrivacidad)) {
      throw 'No se pudo encontrar  $EntornoVariable.urlPoliticaPrivacidad';
    }
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
