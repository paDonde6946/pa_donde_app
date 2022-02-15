import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_elevado.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';

import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/text/formulario_texto.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart';
import 'package:provider/provider.dart';
import 'package:pa_donde_app/ui/utils/validaciones_generales.dart'
    as validaciones_generales;

import 'package:pa_donde_app/data/models/usuario_modelo.dart';
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
            _nombreLabel(
                _generalMaterial(_crearNombre(usuarioServicios)), 'Nombre'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(_generalMaterial(_crearApellido(usuarioServicios)),
                'Apellidos'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(_generalMaterial(_crearEmail(usuarioServicios)),
                'Correo Institucional'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(_generalMaterial(_crearNumCelular(usuarioServicios)),
                'Número de teléfono'),
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

    mostrarShowDialogCargando(
        context: context, titulo: 'Guardando Información');
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

  Widget _generalMaterial(Widget widget) {
    return Material(
      elevation: 7,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: widget,
    );
  }

  ///  Input - Campo del nombre
  Widget _crearNombre(Usuario usuarioServicios) {
    return TextFormField(
      style: styleInput,
      initialValue: usuarioServicios.nombre,
      decoration: inputDecorationElevado(
          'Nombre', 'Ingresa tu nombre', context, Colors.white),
      onSaved: (value) => usuarioServicios.nombre = value,
      onChanged: (value) => usuarioServicios.nombre = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del apellido
  Widget _crearApellido(Usuario usuarioServicios) {
    return TextFormField(
      style: styleInput,
      initialValue: usuarioServicios.apellido,
      decoration: inputDecorationElevado(
          'Apellido', 'Ingresa tu apellido', context, Colors.white),
      onSaved: (value) => usuarioServicios.apellido = value,
      onChanged: (value) => usuarioServicios.apellido = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo número de celular
  Widget _crearNumCelular(Usuario usuarioServicios) {
    return TextFormField(
      style: styleInput,
      initialValue: usuarioServicios.celular.toString(),
      onSaved: (value) => usuarioServicios.celular = int.parse(value!),
      onChanged: (value) => usuarioServicios.celular = int.parse(value),
      keyboardType: TextInputType.number,
      decoration: inputDecorationElevado(
          '', 'Ingresa tu número celular', context, Colors.white),
      validator: (value) => (validaciones_generales.isNumber(value!))
          ? null
          : 'Solo se perminten números',
    );
  }

  /// Input - Campo correo eléctronico
  Widget _crearEmail(Usuario usuarioServicios) {
    inputControllerCorreo.text = usuarioServicios.correo;
    return TextFormField(
      style: styleInput,
      initialValue: usuarioServicios.correo,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecorationElevado(
          '', 'Ingresa tu correo', context, Colors.white),
      validator: (value) =>
          (validarEmail(value)) ? 'El correo ingresado no es valido' : null,
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
