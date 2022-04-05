import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';
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

  String fecha2 = '';
  String hora2 = '';
  int cupos = 0;
  double taminoLetra = 0;

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputCupos = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    taminoLetra = size.width * 0.038;

    validarExistenciaCampos();
    // Espacio entre cada input
    const tamanioSeparador = 0.0;
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Column(
          children: [
            titulo(),
            _crearCupos(),
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
            onPressed: () => BlocProvider.of<PreserviciosBloc>(context)
                .controller!
                .jumpToPage(0),
            icon: const Icon(Icons.arrow_back_ios_sharp)),
        const Text("Registro del servicio"),
        IconButton(
            onPressed: validarCampos,
            icon: const Icon(Icons.arrow_forward_ios_rounded)),
      ],
    );
  }

  void validarExistenciaCampos() {
    final servicioBloc =
        BlocProvider.of<PreserviciosBloc>(context).state.servicio;

    /// Valida si tiene datos ya registrados anteriormente
    if (servicioBloc.cantidadCupos != null && servicioBloc.fechayhora != null) {
      cupos = servicioBloc.cantidadCupos;
      inputCupos.value =
          TextEditingValue(text: servicioBloc.cantidadCupos.toString());
      fecha2 = servicioBloc.fechayhora.toString().split("T")[0];
      hora2 = servicioBloc.fechayhora.toString().split("T")[1].split(".")[0];
    }
  }

  /// Valida los campos para continuar con el siguiente
  void validarCampos() {
    final preServicioBloc = BlocProvider.of<PreserviciosBloc>(context);
    final servicioBloc = preServicioBloc.state.servicio;

    try {
      // Separar hora 00:00
      final horaPartida = hora2.split(':');

      //Modifica la fecha de String a DateTime
      DateTime fechaModificada = DateTime.parse(fecha2);

      // Se agrega la hora a la fecha
      fechaModificada = fechaModificada.add(Duration(
          hours: int.parse(horaPartida[0]),
          minutes: int.parse(horaPartida[1])));

      String formateandoFecha =
          // DateFormat('yyyy-MM-dd – kk:mm').format(fechaModificada);
          DateFormat('yyyy-MM-ddTkk:mm:ss.sss').format(fechaModificada) +
              '+00:00';

      // Se valida la diferencia de la fecha con la fecha actual
      final diferenciaHoras =
          fechaModificada.difference(DateTime.now()).inHours;

      if (inputCupos.text.isNotEmpty) {
        servicioBloc.cantidadCupos =
            int.parse(inputCupos.text.replaceAll(" ", ""));
        if (servicioBloc.cantidadCupos <= 0 ||
            servicioBloc.cantidadCupos >= 5) {
          mostrarShowDialogInformativo(
              context: context,
              titulo: 'Cupos',
              contenido:
                  "La cantidad de cupos no es valida. Debe de ingresar un valor entre 1 y 4");
        } else {
          if (diferenciaHoras < 0 ||
              diferenciaHoras > 24 && fecha2 != '' && hora2 != '') {
            mostrarShowDialogInformativo(
                context: context,
                titulo: 'Fecha del Servicio',
                contenido:
                    "Debe ingresar una fecha y hora menor a 24 horas de la hora actual (${DateTime.now()})");
          } else {
            servicioBloc.fechayhora = formateandoFecha;
            preServicioBloc.controller!.jumpToPage(2);
            preServicioBloc.add(OnCambiarPagina(preServicioBloc.controller!));
            preServicioBloc.add(OnCrearServicio(servicioBloc));
          }
        }
      }
      // throw Exception();
    } catch (e) {
      mostrarShowDialogInformativo(
          context: context,
          titulo: 'Campos Incompletos',
          contenido: "Debe de completar todos los campos");
    }
  }

  /// Input - Cupos disponibles en el carro o moto
  Widget _crearCupos() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: inputCupos,
      cursorColor: Theme.of(context).primaryColor,
      onSaved: (value) => cupos = int.parse(value!),
      decoration: inputDecoration(
          'Cupos',
          'Cantidad de cupos',
          context,
          Theme.of(context).primaryColor,
          const Icon(
            Icons.person_add_alt_1_outlined,
            color: Colors.black,
          ),
          0),
      validator: (value) => (value!.isEmpty) ? 'El digito no es valido' : null,
    );
  }

  /// Crea el contenedor de la fecha para seleccionar la fecha
  Widget _crearFecha() {
    return _crearContenedor(fecha2, 'Fecha del servicio', Icons.calendar_today,
        _seleccionarFechaServicio);
  }

  /// Crea el contenedor de la hora para seleccionar la hora a realizar del servicio
  Widget _crearHora() {
    return _crearContenedor(
        hora2, 'Hora de partida', Icons.schedule, _seleccionarHoraServicio);
  }

  /// Configuracion del pop up para mostrar el calendario
  _seleccionarFechaServicio() async {
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
        final servicioBloc =
            BlocProvider.of<PreserviciosBloc>(context).state.servicio;
        servicioBloc.fechayhora = null;
        final fechaModificada = DateTime.parse(_fechaDada.toString());
        fecha2 = fechaModificada.toString().split(" ")[0];
      });
    }
  }

  /// Configuracion del pop up para mostrar el reloj
  _seleccionarHoraServicio() async {
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
      });
    }
  }

  /// Crear contenedor general para fecha y hora
  Widget _crearContenedor(
      String dato, String datoDefecto, IconData icono, Function() funcion) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.006),
        width: size.width,
        child: Container(
          height: 53,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dato == "" ? datoDefecto : dato,
                style: TextStyle(
                  color: dato == ""
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  fontSize: taminoLetra,
                ),
              ),
              Icon(icono)
            ],
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).primaryColor, width: 1)),
          ),
        ),
      ),
      onTap: funcion,
    );
  }
}
