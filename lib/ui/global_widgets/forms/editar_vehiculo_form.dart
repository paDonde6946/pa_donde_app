import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------

import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/services/vehiculo_servicio.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_redondo.dart'
    as input_redondo;

import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_elevado.dart'
    as input_elevado;
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/text/formulario_texto.dart';

import 'package:pa_donde_app/ui/utils/validaciones_generales.dart'
    as validaciones_generales;
//---------------------------------------------------------------------

class FormEditarVehiulo extends StatefulWidget {
  Vehiculo? _vehiculo;
  FormEditarVehiulo({Key? key, @required Vehiculo? vehiculo}) {
    _vehiculo = vehiculo;
  }

  @override
  State<FormEditarVehiulo> createState() =>
      _FormEditarVehiuloState(_vehiculo!); //
}

class _FormEditarVehiuloState extends State<FormEditarVehiulo> {
  Vehiculo? _vehiculo;
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();
  String conContrasenia = "";

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerPlaca = TextEditingController();
  TextEditingController inputControllerColor = TextEditingController();
  TextEditingController inputControllerDocTitular = TextEditingController();
  TextEditingController inputControllerMarca = TextEditingController();
  TextEditingController inputControllerModelo = TextEditingController();
  TextEditingController inputControllerAnio = TextEditingController();

  final styleInput = const TextStyle(height: 0.4);
  bool color = false;

  _FormEditarVehiuloState(Vehiculo vehiculo) {
    _vehiculo = vehiculo;
  }

  // print(_vehiculo.placa);
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
            _tipoPlacaColor(),
            const SizedBox(height: tamanioSeparador),
            _nombreLabel(_generalMaterial(_crearDocumentoTitular(_vehiculo!)),
                'Documento del titular'),
            const SizedBox(height: tamanioSeparador),
            _nombreLabel(_generalMaterial(_crearMarca(_vehiculo!)),
                "Marca del vehiculo"),
            const SizedBox(height: tamanioSeparador),
            _nombreLabel(_generalMaterial(_crearModelo(_vehiculo!)),
                "Modelo del  vehiculo"),
            const SizedBox(height: tamanioSeparador),
            _nombreLabel(
                _generalMaterial(_crearAnio(_vehiculo!)), "Año del vehiculo"),
            const SizedBox(height: tamanioSeparador),
            SizedBox(
                width: size.width * 1, child: _crearBotonEditar(_vehiculo!)),
            // const SizedBox(height: tamanioSeparador),
            SizedBox(
                width: size.width * 1, child: _crearBotonEliminar(_vehiculo!)),
          ],
        ),
      ),
    );
  }

  /// Método auxiliar que  ayuda a validar todos los campos del registro
  void _validarFormulario(Vehiculo vehiculo) async {
    // Verfica que todos los campos del formulario esten completos
    // if (!keyForm.currentState!.validate()) {
    //   customShapeSnackBar(
    //       context: context,
    //       titulo: "Recuerda que todos los campos son obligatorios");
    //   return;
    // }
    // Verifica que las contraseñas coincidan
    // if (inputControllerContrasenia.text != inputControllerConContrasenia.text) {
    //   customShapeSnackBar(
    //       context: context, titulo: 'Las contraseñas no coinciden');
    //   return;
    // }

    // if (!validaciones_generales
    //     .validarEmailDominio(inputControllerCorreo.text.trim())) {
    //   customShapeSnackBar(
    //       context: context,
    //       titulo: "Solo se permiten correos de la universidad");
    //   return;
    // }

    // mostrarShowDialogCargando(context: context, titulo: 'REGISTRANDOTE');
    // await Future.delayed(const Duration(seconds: 1));
    // Navigator.pop(context);

    // UsuarioServicio usuarioServicio = UsuarioServicio();
    // AutenticacionServicio autenticacionServicio = AutenticacionServicio();
    // final Usuario? response =
    //     await usuarioServicio.crearUsuarioServicio(usuario);
    // // Si todo esta bien redirige a la siguiente página
    // keyForm.currentState!.save();

    // mostrarShowDialogCargando(context: context, titulo: 'REGISTRO EXITO');
    // await Future.delayed(const Duration(seconds: 1));
    // Navigator.pop(context);
    // autenticacionServicio.usuarioServiciosActual = response!;
    // Navigator.pushReplacementNamed(context, 'inicio');
  }

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  Widget _tipoPlacaColor() {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
            width: size.width * 0.45,
            child: _nombreLabel(_crearTipoVehiculo(), 'Tipo Vehículo')),
        Column(
          children: [
            SizedBox(
                width: size.width * 0.42,
                child: _nombreLabel(
                    _generalMaterial(_crearPlaca(_vehiculo!)), 'Placa')),
            SizedBox(
                width: size.width * 0.42,
                child: _nombreLabel(
                    _generalMaterial(_crearColor(_vehiculo!)), 'Color')),
          ],
        ),
      ],
    );
  }

  Widget _crearTipoVehiculo() {
    const double redondo = 20;
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              color = false;
              setState(() {});
            },
            child: _cardVehiculo(redondo)),
        const SizedBox(width: 20),
        // GestureDetector(
        //     onTap: () {
        //       color = true;
        //       setState(() {});
        //     },
        //     child: _cardMoto(redondo)),
      ],
    );
  }

  Widget _cardVehiculo(double redondo) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(redondo)),
      child: Container(
        child: Icon(Icons.drive_eta_outlined, size: size.width * 0.24),
        height: size.height * 0.14,
        width: size.width * 0.4,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: !color
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                offset: const Offset(1.0, 1.0), //(x,y)
                blurRadius: 4.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(redondo))),
      ),
    );
  }

  // Widget _cardMoto(double redondo) {
  //   final size = MediaQuery.of(context).size;

  //   return Material(
  //     elevation: 10,
  //     borderRadius: BorderRadius.all(Radius.circular(redondo)),
  //     child: Container(
  //       child: Icon(Icons.motorcycle_rounded, size: size.width * 0.24),
  //       height: size.height * 0.13,
  //       width: size.width * 0.4,
  //       decoration: BoxDecoration(
  //           boxShadow: [
  //             BoxShadow(
  //               color:
  //                   color ? Theme.of(context).primaryColor : Colors.transparent,
  //               offset: const Offset(1.0, 1.0), //(x,y)
  //               blurRadius: 9.0,
  //             ),
  //           ],
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(redondo))),
  //     ),
  //   );
  // }

  Widget _generalMaterial(Widget widget) {
    return Material(
      elevation: 7,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: widget,
    );
  }

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

  ///  Input - Campo de la Placa del Vehiculo
  Widget _crearPlaca(Vehiculo vehiculo) {
    return TextFormField(
      initialValue: vehiculo.placa,
      style: styleInput,
      decoration:
          input_elevado.inputDecorationElevado('', '', context, Colors.white),
      onSaved: (value) => vehiculo.placa = value,
      onChanged: (value) => vehiculo.placa = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del color del vehiculo
  Widget _crearColor(Vehiculo vehiculo) {
    return TextFormField(
      initialValue: vehiculo.color,
      style: styleInput,
      decoration:
          input_redondo.inputDecorationRedondo('', '', context, Colors.white),
      onSaved: (value) => vehiculo.color = value,
      onChanged: (value) => vehiculo.color = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo número de cedula del titular del vehiculo
  Widget _crearDocumentoTitular(Vehiculo vehiculo) {
    return TextFormField(
      initialValue: vehiculo.documentoTitular,
      style: styleInput,
      onSaved: (value) => vehiculo.documentoTitular = int.parse(value!),
      onChanged: (value) => vehiculo.documentoTitular = int.parse(value),
      keyboardType: TextInputType.number,
      decoration:
          input_redondo.inputDecorationRedondo('', '', context, Colors.white),
      validator: (value) => (validaciones_generales.isNumber(value!))
          ? null
          : 'Solo se perminten números',
    );
  }

  /// Input - Campo de la marca del vehiculo
  Widget _crearMarca(Vehiculo vehiculo) {
    return TextFormField(
      initialValue: vehiculo.marca,
      style: styleInput,
      keyboardType: TextInputType.text,
      decoration:
          input_redondo.inputDecorationRedondo('', '', context, Colors.white),
      onSaved: (value) => vehiculo.marca = value,
      onChanged: (value) => vehiculo.marca = value,
      validator: (value) => (validaciones_generales.validarEmail(value) ||
              !validaciones_generales.validarEmailDominio(value))
          ? 'El correo ingresado no es valido'
          : null,
    );
  }

  /// Input - Campo del modelo del vehiculo
  Widget _crearModelo(Vehiculo vehiculo) {
    return TextFormField(
      initialValue: vehiculo.modelo,
      style: styleInput,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onSaved: (value) => vehiculo.modelo = value,
      onChanged: (value) => vehiculo.modelo = value,
      decoration:
          input_redondo.inputDecorationRedondo('', '', context, Colors.white),
      validator: (value) =>
          (value!.isEmpty) ? 'El correo ingresado no es valido' : null,
    );
  }

  /// Input - Campo del año del vehiculo
  Widget _crearAnio(Vehiculo vehiculo) {
    return TextFormField(
      initialValue: vehiculo.anio,
      style: styleInput,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => conContrasenia = value,
      decoration:
          input_redondo.inputDecorationRedondo('', '', context, Colors.white),
      validator: (value) => (value!.isEmpty) ? 'El digito no es valido' : null,
    );
  }

  ///_____________________________________________________________________

  // Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBotonEditar(Vehiculo vehiculo) {
    return BtnAnaranja(
        function: () => _validarFormulario(vehiculo), titulo: 'Editar');
  }

  Widget _crearBotonEliminar(Vehiculo vehiculo) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      width: 150,
      // margin: const EdgeInsets.only(bottom: 10),
      child: IconButton(
        icon: Text(
          'Eliminar',
          style: TextStyle(fontSize: size.width * 0.045, color: Colors.red),
        ),
        color: Colors.black87,
        onPressed: () {
          mostrarShowDialogCargando(
              context: context, titulo: "Estammos eliminando tu vehiculo");
          var vehiculoServicio = VehiculoServicio();
          vehiculoServicio.eliminarVehiculo(placa: vehiculo.placa);
        },
      ),
    );
  }
}
