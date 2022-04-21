import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';

import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart'
    as validaciones_generales;
//---------------------------------------------------------------------

class RecuperarContraseniaForm extends StatefulWidget {
  const RecuperarContraseniaForm({Key? key}) : super(key: key);

  @override
  _RecuperarContraseniaFormState createState() =>
      _RecuperarContraseniaFormState();
}

class _RecuperarContraseniaFormState extends State<RecuperarContraseniaForm> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerCorreo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
        key: keyForm,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            children: [
              _crearEmail(context),
              SizedBox(height: size.height * 0.03),
              _crearBtnInicioSesion()
            ],
          ),
        ));
  }

  /// Método auxiliar que  ayuda a validar todos los campos para recuperar la contraseña
  void _validarFormulario() async {
    // Verfica que todos los campos del formulario esten completos
    if (!keyForm.currentState!.validate()) {
      customShapeSnackBar(
          context: context,
          titulo: "Recuerda que todos los campos son obligatorios");
      return;
    }

    mostrarShowDialogCargando(context: context, titulo: 'INFORMACIÓN ENVIADA');
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);

    // Validar informacion con el backend
    AutenticacionServicio autenticacionServicio = AutenticacionServicio();
    bool response = await autenticacionServicio
        .recuperarContrasenia(inputControllerCorreo.text);

    if (!response) {
      customShapeSnackBar(context: context, titulo: 'Información invalida');
    } else {
      // Si todo esta bien redirige a la siguiente página
      keyForm.currentState!.save();
      // Navigator.pushNamed(context, 'inicio');
      Navigator.pop(context);
    }
  }

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  /// Input - Campo correo eléctronico
  Widget _crearEmail(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: inputControllerCorreo,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecoration('Correo institucional', 'Ingresa tu correo',
          context, Colors.black, null, 0),
      validator: (value) => (validaciones_generales.validarEmail(value) ||
              !validaciones_generales.validarEmailDominio(value))
          ? 'El correo ingresado no es valido'
          : null,
    );
  }

  /// Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBtnInicioSesion() {
    return Center(
      child: BtnAnaranja(
          function: () => _validarFormulario(), titulo: 'Recuperar'),
    );
  }
}
