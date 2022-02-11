import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form_redondo.dart'
    as input_redondo;
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

  String fecha2 = 'Fecha del servicio';
  String hora2 = 'Hora de partida';
  double taminoLetra = 0;

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputFecha = TextEditingController();
  TextEditingController inputHora = TextEditingController();
  TextEditingController inputCupos = TextEditingController();
  final styleInput = const TextStyle(height: 0.4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    taminoLetra = size.width * 0.04;

    // Espacio entre cada input
    const tamanioSeparador = 7.0;
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Column(
          children: [
            titulo(),
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

  /// Metodo para crear el titulo del form y los botones superiores
  Widget titulo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              BlocProvider.of<PreserviciosBloc>(context)
                  .controller!
                  .jumpToPage(0);
            },
            icon: const Icon(Icons.arrow_back_ios_sharp)),
        const Text("Regitro del servicio"),
        IconButton(
            onPressed: () {
              final blocPaginar = BlocProvider.of<PreserviciosBloc>(context);
              blocPaginar.controller!.jumpToPage(2);
              BlocProvider.of<PreserviciosBloc>(context)
                  .add(OnCambiarPagina(blocPaginar.controller!));
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded)),
      ],
    );
  }

  /// Metodo que permite darle una elevacion a los widgets
  Widget _generalMaterial(Widget widget) {
    return Material(
      elevation: 7,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: widget,
    );
  }

  /// Input - Cupos disponibles en el carro o moto
  Widget _crearCupos() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: styleInput,
      controller: inputCupos,
      scrollPadding: const EdgeInsets.all(1),
      cursorColor: Theme.of(context).primaryColor,
      obscureText: true,
      onChanged: (value) => servicio.cantidadCupos = int.parse(value),
      decoration: input_redondo.inputDecorationRedondo(
          'Cupos', 'Cantidad de cupos', context, Colors.white),
      validator: (value) => (value!.isEmpty) ? 'El digito no es valido' : null,
    );
  }

  /// Crea el contenedor de la fecha para seleccionar la fecha
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
            child: Text(
              fecha2 == "" ? 'Fecha del servicio' : fecha2,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: taminoLetra,
              ),
            ),
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

  /// Crea el contenedor de la hora para seleccionar la hora a realizar del servicio
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
            child: Text(
              hora2 == "" ? 'Hora de partida' : hora2,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: taminoLetra,
              ),
            ),
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

  /// Configuracion del pop up para mostrar el calendario
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

  /// Configuracion del pop up para mostrar el reloj
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
