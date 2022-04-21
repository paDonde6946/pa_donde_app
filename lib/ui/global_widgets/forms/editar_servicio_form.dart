import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/inputs/input_form.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';
//---------------------------------------------------------------------

class EditarServicioForm extends StatefulWidget {
  final Function? callbackFunction;
  const EditarServicioForm({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  State<EditarServicioForm> createState() =>
      // ignore: no_logic_in_create_state
      _EditarServicioFormState(callbackFunction);
}

class _EditarServicioFormState extends State<EditarServicioForm> {
  final Function? callbackFunction;
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();
  Servicio servicio = Servicio();

  String fecha2 = '';
  String hora2 = '';
  String cupos = '';
  double taminoLetra = 0;

  // CONTROLADORES DE CADA INPUT
  TextEditingController inputCupos = TextEditingController();

  @override
  void initState() {
    servicio =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;
    final separarFecha = servicio.fechayhora.split("T");

    fecha2 = separarFecha[0].toString();
    hora2 = separarFecha[1].split(".")[0];
    super.initState();
  }

  _EditarServicioFormState(this.callbackFunction);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    taminoLetra = size.width * 0.04;
    servicio =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;

    // Espacio entre cada input
    const tamanioSeparador = 7.0;
    return Form(
      key: keyForm,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            _crearCupos(),
            const SizedBox(height: tamanioSeparador),
            _crearFecha(),
            const SizedBox(height: tamanioSeparador),
            _crearHora(),
            SizedBox(height: size.height * 0.04),
            _btnActualizar(),
          ],
        ),
      ),
    );
  }

  /// Valida los campos para continuar con el siguiente
  void validarCampos() async {
    final servicioBloc =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;

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

      servicioBloc.cantidadCupos =
          int.parse(cupos.isEmpty ? servicio.cantidadCupos.toString() : cupos);

      if (servicioBloc.cantidadCupos <= 0 || servicioBloc.cantidadCupos >= 6) {
        mostrarShowDialogInformativo(
            context: context,
            titulo: 'Cupos',
            contenido:
                "La cantidad de cupos no es válida. Debe de ingresar un valor entre 1 y 5");
      } else {
        if (diferenciaHoras > 24 && fecha2 != '' && hora2 != '') {
          mostrarShowDialogInformativo(
              context: context,
              titulo: 'Fecha del Servicio',
              contenido:
                  "Debe ingresar una fecha y hora menor a 24 horas de la hora actual (${DateTime.now()})");
        } else {
          if (servicioBloc.cantidadCupos < servicio.pasajeros.length) {
            mostrarShowDialogInformativo(
                context: context,
                titulo: 'Cupos',
                contenido:
                    "La cantidad de cupos no es valida. Debe de ingresar un valor superior o igual al número de pasajeros");
          } else {
            servicioBloc.fechayhora = formateandoFecha;

            final validar =
                await ServicioRServicio().actualizarServicio(servicio);

            /// Actualiza el servicio con su información para mostrar en la siguiente página
            BlocProvider.of<ServicioBloc>(context)
                .add(OnServicioSeleccionado(servicioBloc));
            if (validar) {
              callbackFunction!();
              mostrarShowDialogInformativo(
                  context: context,
                  titulo: 'Actualizado',
                  contenido: "Los campos fueron actualizados");
            } else {
              mostrarShowDialogInformativo(
                  context: context,
                  titulo: 'No se actualizo',
                  contenido: "Los campos no fueron actualizados");
            }

            Navigator.pop(context);
            return;
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
      cursorColor: Theme.of(context).primaryColor,

      keyboardType: TextInputType.number,
      initialValue: servicio.cantidadCupos.toString(),
      // controller: inputCupos,
      scrollPadding: const EdgeInsets.all(1),
      onChanged: (value) => cupos = value,
      onSaved: (value) => cupos = value!,
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
          height: 50,
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

  Widget _btnActualizar() {
    return BtnAnaranja(
      function: () => validarCampos(),
      titulo: 'Actualizar',
    );
  }
}
