import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/services/autencicacion_service.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart';

class FormInicioSesion extends StatefulWidget {
  const FormInicioSesion({Key? key}) : super(key: key);

  @override
  State<FormInicioSesion> createState() => _FormInicioSesionState();
}

class _FormInicioSesionState extends State<FormInicioSesion> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  TextEditingController inputControllerCorreo = TextEditingController();
  TextEditingController inputControllerContrasenia = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: keyForm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // const SizedBox(height: 20.0),
            _crearEmail(context),
            SizedBox(height: size.height * 0.01),
            _crearContrasenia(context),
            SizedBox(height: size.height * 0.02),
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

  /// Input - Campo correo eléctronico
  Widget _crearEmail(BuildContext context) {
    return TextFormField(
      controller: inputControllerCorreo,
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

  /// Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBtnInicioSesion() {
    return Center(
      child: BtnAnaranja(
          function: () => _validarFormulario(), titulo: 'Iniciar Sesión'),
    );
  }
}
