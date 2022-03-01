import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/services/usuario_servicio.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_elevado.dart';

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
  final Function? callbackFunction;

  const FormEditarPerfil({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<FormEditarPerfil> createState() =>
      _FormEditarPerfilState(callbackFunction);
}

class _FormEditarPerfilState extends State<FormEditarPerfil> {
  final Function? callbackFunction;

  Usuario usuario = Usuario();
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerCorreo = TextEditingController();
  TextEditingController inputControllerNombre = TextEditingController();
  TextEditingController inputControllerApellido = TextEditingController();
  TextEditingController inputControllerTelefono = TextEditingController();

  final styleInput = const TextStyle(height: 0.05);

  _FormEditarPerfilState(this.callbackFunction);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    /// Variable que nos permite guardar la información de cada uno de los registros
    usuario =
        Provider.of<AutenticacionServicio>(context).usuarioServiciosActual;
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.11),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            _nombreLabel(_crearNombre(), 'Nombre'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(_crearApellido(), 'Apellidos'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(_crearEmail(), 'Correo Institucional'),
            SizedBox(height: size.height * 0.01),
            _nombreLabel(_crearNumCelular(), 'Número de teléfono'),
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
    try {
      usuario.celular = int.parse(inputControllerTelefono.value.text);
    } catch (e) {
      customShapeSnackBar(
          context: context, titulo: 'Número de celular inválido');

      return;
    }

    // mostrarShowDialogCargando(
    //     context: context, titulo: 'Guardando Información');
    await Future.delayed(const Duration(seconds: 1));

    // Validar informacion con el backend
    UsuarioServicio usuarioServicio = UsuarioServicio();
    final response = await usuarioServicio.editarPerfil(usuario);
    if (response == null) {
      customShapeSnackBar(context: context, titulo: 'Información invalida');
    } else {
      // Si todo esta bien redirige a la siguiente página
      // keyForm.currentState!.save();
      BlocProvider.of<UsuarioBloc>(context).add(OnActualizarUsuario(response));
      setState(() {
        callbackFunction!();
      });
      Navigator.pop(context);
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
        // const SizedBox(height: 2),
        widget
      ],
    );
  }

  ///  Input - Campo del nombre
  Widget _crearNombre() {
    return TextFormField(
      style: styleInput,
      initialValue: usuario.nombre,
      decoration: inputDecoration(
          '', 'Ingresa tu nombre', context, Theme.of(context).primaryColor, null, 0),
      onSaved: (value) => usuario.nombre = value,
      onChanged: (value) => usuario.nombre = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del apellido
  Widget _crearApellido() {
    return TextFormField(
      style: styleInput,
      initialValue: usuario.apellido,
      decoration: inputDecoration(
          '', 'Ingresa tu apellido', context, Theme.of(context).primaryColor, null, 0),
      onSaved: (value) => usuario.apellido = value,
      onChanged: (value) => usuario.apellido = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo número de celular
  Widget _crearNumCelular() {
    return TextFormField(
        style: styleInput,
        initialValue: usuario.celular.toString(),
        onSaved: (value) => usuario.celular = int.parse(value!),
        onChanged: (value) => inputControllerTelefono.text = value,
        keyboardType: TextInputType.number,
        decoration: inputDecoration('', 'Ingresa tu número celular', context,
            Theme.of(context).primaryColor, null, 0),
        validator: (value) => (validaciones_generales.isNumber(value!))
            ? null
            : 'Solo se perminten números',
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ]);
  }

  /// Input - Campo correo eléctronico
  Widget _crearEmail() {
    inputControllerCorreo.text = usuario.correo;
    return TextFormField(
      enabled: false,
      style: styleInput,
      initialValue: usuario.correo,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecoration(
          '', 'Ingresa tu correo', context, Theme.of(context).primaryColor, null, 0),
      validator: (value) =>
          (validarEmail(value)) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBtnInicioSesion() {
    return Center(
      child: BtnAnaranja(
          function: () => _validarFormulario(), titulo: 'Actualizar'),
    );
  }
}
