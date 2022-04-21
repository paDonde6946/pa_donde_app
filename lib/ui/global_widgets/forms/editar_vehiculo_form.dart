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

// ignore: must_be_immutable
class FormEditarVehiulo extends StatefulWidget {
  Vehiculo? _vehiculo;
  // ignore: use_key_in_widget_constructors
  FormEditarVehiulo({Key? key, @required Vehiculo? vehiculo}) {
    _vehiculo = vehiculo;
  }

  @override
  State<FormEditarVehiulo> createState() =>
      // ignore: no_logic_in_create_state
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

  bool color = false;
  // ignore: prefer_const_constructors
  Size size = Size(0, 0);

  _FormEditarVehiuloState(Vehiculo vehiculo) {
    _vehiculo = vehiculo;
  }

  // print(_vehiculo.placa);
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
            _tipoPlacaColor(),
            const SizedBox(height: tamanioSeparador),
            _crearMarca(_vehiculo!),
            const SizedBox(height: tamanioSeparador),
            _crearModelo(_vehiculo!),
            const SizedBox(height: tamanioSeparador),
            _crearAnio(_vehiculo!),
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
    if (!keyForm.currentState!.validate()) {
      mostrarShowDialogInformativo(
          context: context,
          titulo: 'Campos obligatorios',
          contenido: "Recuerda que todos los campos son obligatorios");
      return;
    }

    if (!RegExpLocales.expresionPlacaCarro.hasMatch(vehiculo.placa)) {
      mostrarShowDialogInformativo(
          context: context,
          titulo: 'Placa Inválida',
          contenido: "No es una placa válida");
      return;
    }
    mostrarShowDialogCargando(
        context: context, titulo: "Estamos editando tu vehículo");

    var vehiculoServicio = VehiculoServicio();
    var respuesta = await vehiculoServicio.editarServicio(vehiculo: vehiculo);
    Navigator.of(context, rootNavigator: true).pop(context);

    if (respuesta["ok"] == false) {
      customShapeSnackBar(
          context: context,
          titulo: "No se pudo editar el vehículo. ${respuesta['msg']}");
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

  Widget _tipoPlacaColor() {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(child: _crearTipoVehiculo()),
        Column(
          children: [
            SizedBox(width: size.width * 0.42, child: _crearPlaca(_vehiculo!)),
            SizedBox(
              height: size.width * 0.02,
            ),
            SizedBox(width: size.width * 0.42, child: _crearColor(_vehiculo!)),
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
      ],
    );
  }

  Widget _cardVehiculo(double redondo) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(redondo)),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.height * 0.03, vertical: size.height * 0.02),
        child: (_vehiculo!.tipoVehiculo != TipoVehiculo.carro)
            ? const Image(image: AssetImage("img/icons/moto_icon.png"))
            : const Image(image: AssetImage("img/icons/carro_icon.png")),
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

  ///  Input - Campo de la Placa del Vehiculo
  Widget _crearPlaca(Vehiculo vehiculo) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      initialValue: vehiculo.placa,
      decoration: inputDecoration('Placa', 'Placa del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.03),
      onSaved: (value) => vehiculo.placa = value,
      onChanged: (value) => vehiculo.placa = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  ///  Input - Campo del color del vehiculo
  Widget _crearColor(Vehiculo vehiculo) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      initialValue: vehiculo.color,
      decoration: inputDecoration('Color', 'Color del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.03),
      onSaved: (value) => vehiculo.color = value,
      onChanged: (value) => vehiculo.color = value,
      validator: (value) =>
          (value!.isEmpty) ? 'Es Obligatorio este campo' : null,
    );
  }

  /// Input - Campo de la marca del vehiculo
  Widget _crearMarca(Vehiculo vehiculo) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      initialValue: vehiculo.marca,
      keyboardType: TextInputType.text,
      decoration: inputDecoration('Marca', 'Marca del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.03),
      onSaved: (value) => vehiculo.marca = value,
      onChanged: (value) => vehiculo.marca = value,
    );
  }

  /// Input - Campo del modelo del vehiculo
  Widget _crearModelo(Vehiculo vehiculo) {
    return TextFormField(
      initialValue: vehiculo.modelo,
      cursorColor: Theme.of(context).primaryColor,
      scrollPadding: const EdgeInsets.all(1),
      onSaved: (value) => vehiculo.modelo = value,
      onChanged: (value) => vehiculo.modelo = value,
      decoration: inputDecoration('Modelo', 'Modelo del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.03),
      validator: (value) =>
          (value!.isEmpty) ? 'El modelo ingresado no es valido' : null,
    );
  }

  /// Input - Campo del año del vehiculo
  Widget _crearAnio(Vehiculo vehiculo) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      initialValue: vehiculo.anio,
      keyboardType: TextInputType.number,
      scrollPadding: const EdgeInsets.all(1),
      onChanged: (value) => conContrasenia = value,
      decoration: inputDecoration('Año', 'Año del vehículo', context,
          Theme.of(context).primaryColor, null, size.height * 0.03),
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
          style: TextStyle(
              fontSize: size.width * 0.045,
              color: Theme.of(context).primaryColor),
        ),
        color: Colors.black87,
        onPressed: () async {
          mostrarShowDialogCargando(
              context: context, titulo: "Estamos eliminando tu vehículo");

          var vehiculoServicio = VehiculoServicio();
          var respuesta =
              await vehiculoServicio.eliminarVehiculo(vehiculo: vehiculo);
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
        },
      ),
    );
  }
}
