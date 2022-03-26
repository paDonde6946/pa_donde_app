import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------

import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/services/vehiculo_servicio.dart';
import 'package:pa_donde_app/global/enums/tipo_vehiculo_enum.dart';
import 'package:pa_donde_app/global/regexp/regexp_locales.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/confirmacion_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';
import 'package:pa_donde_app/ui/utils/snack_bars.dart';
//---------------------------------------------------------------------

class FormAgregarVehiulo extends StatefulWidget {
  const FormAgregarVehiulo({Key? key}) : super(key: key);

  @override
  State<FormAgregarVehiulo> createState() => _FormAgregarVehiuloState();
}

class _FormAgregarVehiuloState extends State<FormAgregarVehiulo> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();
  String conContrasenia = "";

  Vehiculo vehiculo = Vehiculo(pTipoVehiculo: TipoVehiculo.carro);

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputControllerPlaca = TextEditingController();
  TextEditingController inputControllerColor = TextEditingController();
  TextEditingController inputControllerDocTitular = TextEditingController();
  TextEditingController inputControllerMarca = TextEditingController();
  TextEditingController inputControllerModelo = TextEditingController();
  TextEditingController inputControllerAnio = TextEditingController();

  Size size = const Size(0, 0);

  final styleInput = const TextStyle(height: 0.4);
  bool esMoto = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

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
            const SizedBox(height: tamanioSeparador),
            _crearTipoVehiculo(),
            const SizedBox(height: tamanioSeparador),
            _filaInputs(),
            const SizedBox(height: tamanioSeparador),
            _crearMarca(),
            const SizedBox(height: tamanioSeparador),
            _crearModelo(),
            const SizedBox(height: tamanioSeparador),
            _crearAnio(),
            const SizedBox(height: tamanioSeparador),
            SizedBox(width: 200, child: _crearBotonRegistro(vehiculo)),
            const SizedBox(height: tamanioSeparador),
          ],
        ),
      ),
    );
  }

  /// Método auxiliar que  ayuda a validar todos los campos del registro
  void _validarFormulario(Vehiculo vehiculo) async {
    // Verificar la placa
    if (!esMoto) {
      if (!RegExpLocales.expresionPlacaCarro
          .hasMatch(inputControllerPlaca.text)) {
        mostrarShowDialogInformativo(
            context: context,
            titulo: 'Placa Inválida',
            contenido: "La placa no es válida para ser una placa de carro.");
        return;
      }
    } else {
      if (!RegExpLocales.expresionPlacaMoto
          .hasMatch(inputControllerPlaca.text)) {
        mostrarShowDialogInformativo(
            context: context,
            titulo: 'Placa Inválida',
            contenido: "La placa no es válida para ser una placa de moto.");
        return;
      }
    }

    // Verfica que todos los campos del formulario esten completos
    if (!keyForm.currentState!.validate()) {
      mostrarShowDialogInformativo(
          context: context,
          titulo: 'Campos obligatorios',
          contenido: "Recuerda que todos los campos son obligatorios");
      return;
    }

    mostrarShowDialogCargando(
        context: context, titulo: "Estamos guardando tu vehículo");
    var vehiculoServicio = VehiculoServicio();
    var respuesta = await vehiculoServicio.agregarVehiculo(vehiculo: vehiculo);
    Navigator.of(context, rootNavigator: true).pop(context);

    if (respuesta["ok"] == false) {
      customShapeSnackBar(
          context: context,
          titulo: "No se pudo agregar el vehículo. ${respuesta['msg']}");
    } else {
      var nuevosVehiculos = await vehiculoServicio.getVehiculos();
      BlocProvider.of<PreserviciosBloc>(context)
          .add(OnAgregarVehiculo(nuevosVehiculos));

      mostrarShowDialogConfirmar(
          context: context,
          titulo: "CONFIRMACIÓN",
          contenido: respuesta["msg"],
          paginaRetorno: 'inicio');
    }
  }

  /*____________________________________________________________*/
  // CREACIÓN DE LOS CAMPOS DEL FORMULARIO
  /*____________________________________________________________*/

  Widget _filaInputs() {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(width: size.width * 0.42, child: _crearPlaca(vehiculo)),
        const SizedBox(width: 15),
        SizedBox(width: size.width * 0.42, child: _crearColor(vehiculo)),
      ],
    );
  }

  Widget _crearTipoVehiculo() {
    const double redondo = 20;
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              esMoto = false;
              vehiculo.tipoVehiculo = TipoVehiculo.carro;
              setState(() {});
            },
            child: _cardCarro(redondo)),
        const SizedBox(width: 20),
        GestureDetector(
            onTap: () {
              esMoto = true;
              vehiculo.tipoVehiculo = TipoVehiculo.moto;
              setState(() {});
            },
            child: _cardMoto(redondo)),
      ],
    );
  }

  Widget _cardCarro(double redondo) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(redondo)),
      child: Container(
        child: const Image(image: AssetImage("img/icons/carro_icon.png")),
        height: size.height * 0.13,
        width: size.width * 0.4,
        padding: EdgeInsets.symmetric(
            horizontal: size.height * 0.03, vertical: size.height * 0.02),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: !esMoto
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                offset: const Offset(1.0, 1.0), //(x,y)
                blurRadius: 9.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(redondo))),
      ),
    );
  }

  Widget _cardMoto(double redondo) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(redondo)),
      child: Container(
        child: const Image(image: AssetImage("img/icons/moto_icon.png")),
        height: size.height * 0.13,
        width: size.width * 0.4,
        padding: EdgeInsets.symmetric(
            horizontal: size.height * 0.03, vertical: size.height * 0.02),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: esMoto
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                offset: const Offset(1.0, 1.0), //(x,y)
                blurRadius: 9.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(redondo))),
      ),
    );
  }

  ///  Input - Campo de la Placa del Vehiculo
  Widget _crearPlaca(Vehiculo vehiculo) {
    return TextFormField(
      controller: inputControllerPlaca,
      decoration: inputDecoration('Placa', 'Placa del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.023),
      onSaved: (value) => vehiculo.placa = value,
      onChanged: (value) => vehiculo.placa = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del color del vehiculo
  Widget _crearColor(Vehiculo vehiculo) {
    return TextFormField(
      controller: inputControllerColor,
      decoration: inputDecoration('Color', 'Color del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.023),
      onSaved: (value) => vehiculo.color = value,
      onChanged: (value) => vehiculo.color = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo de la marca del vehiculo
  Widget _crearMarca() {
    return TextFormField(
      controller: inputControllerMarca,
      keyboardType: TextInputType.text,
      decoration: inputDecoration('Marca', 'Marca del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.023),
      onSaved: (value) => vehiculo.marca = value,
      onChanged: (value) => vehiculo.marca = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo del modelo del vehiculo
  Widget _crearModelo() {
    return TextFormField(
      controller: inputControllerModelo,
      scrollPadding: const EdgeInsets.all(1),
      onSaved: (value) => vehiculo.modelo = value,
      onChanged: (value) => vehiculo.modelo = value,
      keyboardType: TextInputType.text,
      decoration: inputDecoration('Modelo', 'Modelo del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.023),
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo del año del vehiculo
  Widget _crearAnio() {
    return TextFormField(
      controller: inputControllerAnio,
      scrollPadding: const EdgeInsets.all(1),
      onSaved: (value) => vehiculo.anio = value,
      onChanged: (value) => vehiculo.anio = value,
      keyboardType: TextInputType.number,
      decoration: inputDecoration('Año', 'Año del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.023),
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///_____________________________________________________________________

  // Se crea el boton registro que es el encargado de validar la información y redirigir a la siguiente página
  Widget _crearBotonRegistro(Vehiculo vehiculo) {
    return BtnAnaranja(
        function: () => _validarFormulario(vehiculo),
        titulo: 'Guardar vehículo');
  }
}
