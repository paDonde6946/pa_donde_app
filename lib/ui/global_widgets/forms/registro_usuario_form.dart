import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart' as input;
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart'
    as validaciones_generales;

class FormRegistroUsuario extends StatefulWidget {
  const FormRegistroUsuario({Key? key}) : super(key: key);

  @override
  State<FormRegistroUsuario> createState() => _FormRegistroUsuarioState();
}

class _FormRegistroUsuarioState extends State<FormRegistroUsuario> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerCorreo = TextEditingController();
  TextEditingController inputControllerNombre = TextEditingController();
  TextEditingController inputControllerApellido = TextEditingController();
  TextEditingController inputControllerTelefono = TextEditingController();
  TextEditingController inputControllerConContrasenia = TextEditingController();
  TextEditingController inputControllerContrasenia = TextEditingController();

  String email = "";
  String contrasenia = "";

  Usuario usuario = Usuario();

  @override
  Widget build(BuildContext context) {
    // Espacio entre cada input
    const tamanioSeparador = 15.0;
    // Formulario del registro del usuario
    return Form(
      key: keyForm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

    mostrarShowDialogCargando(context: context, titulo: 'REGISTRANDOTE');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    //TODO: CREAR USUARIO CONECTAR A SERVICIO

    //Si todo esta bien redirige a la siguiente página
    // keyForm.currentState!.save();
    // //  Navigator.pushNamed(context, 'login');

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
      controller: inputControllerNombre,
      decoration: input.inputDecoration(
          'Nombre', 'Ingresa tu nombre', context, Colors.white),
      // onSaved: (value) => usuario.nombre = value,
      // onChanged: (value) => usuario.nombre = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del nombre
  Widget _crearApellido(Usuario usuario) {
    return TextFormField(
      controller: inputControllerApellido,
      decoration: input.inputDecoration(
          'Apellido', 'Ingresa tu apellido', context, Colors.white),
      // onSaved: (value) => usuario.nombre = value,
      // onChanged: (value) => usuario.nombre = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo número de celular
  Widget _crearNumCelular(Usuario usuario) {
    return TextFormField(
      controller: inputControllerTelefono,
      // onSaved: (value) => usuario.numeroCelular = value,
      // onChanged: (value) => usuario.numeroCelular = value,
      keyboardType: TextInputType.number,
      decoration: input.inputDecoration('Número de celular',
          'Ingresa tu número celular', context, Colors.white),
      validator: (value) => (validaciones_generales.isNumber(value!))
          ? null
          : 'Solo se perminten números',
    );
  }

  /// Input - Campo correo eléctronico
  Widget _crearEmail() {
    return TextFormField(
      controller: inputControllerCorreo,
      keyboardType: TextInputType.emailAddress,
      decoration: input.inputDecoration(
          'Correo institucional', 'Ingresa tu correo', context, Colors.white),
      onChanged: (value) => email = value,
      validator: (value) => (validaciones_generales.validarEmail(value))
          ? 'El correo ingresado no es valido'
          : null,
    );
  }

  /// Input - Campo de la contraseña
  Widget _crearContrasenia() {
    return TextFormField(
      controller: inputControllerContrasenia,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => contrasenia = value,
      decoration: input.inputDecoration(
          'Contraseña', 'Ingresa tu contraseña', context, Colors.white),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo confirmarción de la contraseña
  Widget _crearConContrasenia() {
    return TextFormField(
      controller: inputControllerConContrasenia,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => contrasenia = value,
      decoration: input.inputDecoration('Confirmar Contraseña',
          'Ingresa tu contraseña', context, Colors.white),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// _____________________________________________________________________

  // Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBotonRegistro(Usuario usuario) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: BtnAnaranja(
          function: () => _validarFormulario(usuario), titulo: 'Registrarse'),
    );
  }
}
