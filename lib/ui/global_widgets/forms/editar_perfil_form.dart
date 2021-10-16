import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';

import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart';
import 'package:provider/provider.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_redondo.dart'
    as input_redondo;
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart'
    as validaciones_generales;
//---------------------------------------------------------------------

class FormEditarPerfil extends StatefulWidget {
  const FormEditarPerfil({Key? key}) : super(key: key);

  @override
  State<FormEditarPerfil> createState() => _FormEditarPerfilState();
}

class _FormEditarPerfilState extends State<FormEditarPerfil> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

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

    /// Variable que nos permite guardar la información de cada uno de los registros
    final usuarioServicios =
        Provider.of<AutenticacionServicio>(context).usuarioServiciosActual;
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.11),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            _crearNombre(usuarioServicios),
            SizedBox(height: size.height * 0.01),
            _crearApellido(usuarioServicios),
            SizedBox(height: size.height * 0.01),
            _crearEmail(usuarioServicios),
            SizedBox(height: size.height * 0.01),
            _crearNumCelular(usuarioServicios),
            SizedBox(height: size.height * 0.01),
            _crearContrasenia(context),
            SizedBox(height: size.height * 0.01),
            _crearConContrasenia(),
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
    AutenticacionServicio autenticacionServicio = AutenticacionServicio();
    final response = await autenticacionServicio.login(
        inputControllerCorreo.text.trim(),
        inputControllerContrasenia.text.trim());

    if (response == null) {
      customShapeSnackBar(context: context, titulo: 'Información invalida');
    } else {
      // Si todo esta bien redirige a la siguiente página
      keyForm.currentState!.save();
      Navigator.pushNamed(context, 'inicio');
    }
  }

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  ///  Input - Campo del nombre
  Widget _crearNombre(Usuario usuarioServicios) {
    return TextFormField(
      initialValue: usuarioServicios.nombre,
      decoration:
          inputDecoration('Nombre', 'Ingresa tu nombre', context, Colors.black),
      onSaved: (value) => usuarioServicios.nombre = value,
      onChanged: (value) => usuarioServicios.nombre = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del apellido
  Widget _crearApellido(Usuario usuarioServicios) {
    return TextFormField(
      initialValue: usuarioServicios.apellido,
      decoration: inputDecoration(
          'Apellido', 'Ingresa tu apellido', context, Colors.black),
      onSaved: (value) => usuarioServicios.apellido = value,
      onChanged: (value) => usuarioServicios.apellido = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo número de celular
  Widget _crearNumCelular(Usuario usuarioServicios) {
    return TextFormField(
      initialValue: usuarioServicios.celular.toString(),
      onSaved: (value) => usuarioServicios.celular = int.parse(value!),
      onChanged: (value) => usuarioServicios.celular = int.parse(value),
      keyboardType: TextInputType.number,
      decoration: inputDecoration('Número de celular',
          'Ingresa tu número celular', context, Colors.black),
      validator: (value) => (validaciones_generales.isNumber(value!))
          ? null
          : 'Solo se perminten números',
    );
  }

  /// Input - Campo correo eléctronico
  Widget _crearEmail(Usuario usuarioServicios) {
    inputControllerCorreo.text = usuarioServicios.correo;
    return TextFormField(
      initialValue: usuarioServicios.correo,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecoration(
          'Correo institucional', 'Ingresa tu correo', context, Colors.black),
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
      decoration: inputDecoration(
          'Contraseña', 'Ingresa tu contraseña', context, Colors.black),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo confirmarción de la contraseña
  Widget _crearConContrasenia() {
    return TextFormField(
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => inputControllerContrasenia.text = value,
      decoration: inputDecoration('Confirmar Contraseña',
          'Ingresa tu contraseña', context, Colors.black),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBtnInicioSesion() {
    return Center(
      child: BtnAnaranja(
          function: () => _validarFormulario(), titulo: 'Editar Perfil'),
    );
  }
}
