import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_redondo.dart'
    as input_redondo;
import 'package:pa_donde_app/ui/pages/ruta_pag.dart';
//---------------------------------------------------------------------

class AgregarServicioParte1 extends StatefulWidget {
  const AgregarServicioParte1({Key? key}) : super(key: key);

  @override
  State<AgregarServicioParte1> createState() => _AgregarServicioParte1State();
}

class _AgregarServicioParte1State extends State<AgregarServicioParte1> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  Servicio servicio = Servicio();

  String fecha2 = 'Ingrese la fecha';
  String hora2 = 'Ingrese la hora';

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputFecha = TextEditingController();
  TextEditingController inputHora = TextEditingController();
  TextEditingController inputCupos = TextEditingController();
  final styleInput = const TextStyle(height: 0.4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Espacio entre cada input
    const tamanioSeparador = 5.0;
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios_sharp)),
                const Text("Regitro del servicio"),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios_rounded)),
              ],
            ),
            // const SizedBox(height: tamanioSeparador),
            _generalMaterial(_crearCupos()),
            const SizedBox(height: tamanioSeparador),
            _crearFecha(),
            const SizedBox(height: tamanioSeparador),
            _crearHora()
          ],
        ),
      ),
    );
  }

  Widget _generalMaterial(Widget widget) {
    return Material(
      elevation: 7,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: widget,
    );
  }

  /// Input - Campo del año del vehiculo
  Widget _crearCupos() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: styleInput,
      controller: inputCupos,
      scrollPadding: const EdgeInsets.all(1),
      obscureText: true,
      onChanged: (value) => servicio.cantidadCupos = int.parse(value),
      decoration: input_redondo.inputDecorationRedondo(
          'Cupos', 'Ingresa la cantidad de cupos', context, Colors.white),
      validator: (value) => (value!.isEmpty) ? 'El digito no es valido' : null,
    );
  }

  Widget _crearFecha() {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        width: size.width,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.width * 0.04),
            child: Text(fecha2 == "" ? 'Ingrese la fecha del servicio' : fecha2,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      onTap: () {
        _seleccionarFechaServicio(servicio);
      },
    );
  }

  Widget _crearHora() {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        width: size.width,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.width * 0.04),
            child: Text(hora2 == "" ? 'Ingrese la hora del servicio' : hora2,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      onTap: () {
        _seleccionarHoraServicio(servicio);
      },
    );
  }

  _seleccionarFechaServicio(Servicio servicio) async {
    DateTime selectedDate = DateTime.now();

    DateTime? _fechaDada = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      locale: const Locale('es'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.normal,
                buttonColor: Theme.of(context).focusColor),
          ),
          child: child!,
        );
      },
    );

    if (_fechaDada != null) {
      setState(() {
        final a = DateTime.parse(_fechaDada.toString());
        servicio.fecha = a;
        fecha2 = servicio.fecha.toString().split(" ")[0];
      });
    }
  }

  _seleccionarHoraServicio(Servicio servicio) async {
    TimeOfDay selectHora = TimeOfDay.now();

    TimeOfDay? _horaDada = await showTimePicker(
      context: context,
      initialTime: selectHora,
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Theme.of(context).primaryColor,
              colorScheme:
                  ColorScheme.light(primary: Theme.of(context).primaryColor),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.normal,
                  buttonColor: Theme.of(context).focusColor),
            ),
            child: Localizations(
                locale: const Locale('es'),
                child: child,
                delegates: const <LocalizationsDelegate>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ]));
      },
    );

    if (_horaDada != null) {
      setState(() {
        hora2 = _horaDada.toString().replaceAll("TimeOfDay(", "");
        hora2 = hora2.replaceAll(")", "");
        servicio.horaInicio = hora2.toString();
      });
    }
  }
}
