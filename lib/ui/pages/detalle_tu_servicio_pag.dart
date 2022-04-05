import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:intl/intl.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/models/pasajeros_modelo.dart';

import 'package:pa_donde_app/data/services/servicios_servicio.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja_icono.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/validacion_show.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/calificar_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';

import 'package:pa_donde_app/global/enums/estado_servicio_enum.dart';

import 'package:pa_donde_app/ui/pages/editar_servicio_pag.dart';

import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/data/response/pasejeros_response.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';

import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class DetalleTuServicio extends StatefulWidget {
  final Function? callbackFunction;

  const DetalleTuServicio({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  State<DetalleTuServicio> createState() =>
      // ignore: no_logic_in_create_state
      _DetalleTuServicioState(callbackFunction);
}

class _DetalleTuServicioState extends State<DetalleTuServicio> {
  final Function? callbackFunction;
  Servicio servicio = Servicio();
  // ignore: prefer_typing_uninitialized_variables
  var validar;
  _DetalleTuServicioState(this.callbackFunction);

  @override
  void initState() {
    validar = false;
    super.initState();
  }

  /// Metodo para refrescar la pagina
  callback() {
    callbackFunction!();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    servicio =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;

    if (servicio.estado == EstadoServicio.camino) {
      validar = true;
    }
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          cardDeServicio(),
          SizedBox(height: size.height * 0.01),
          _botonesDelServicio(),
          _mostrarMapa(),
          _listadoUsuariosPostulados(),
        ],
      ),
    );
  }

  /// AppBar personalizado que se muestra en la parte superior de la pantalla
  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;

    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Tu servicio",
          style: TextStyle(
              fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
        ));
  }

  /// Es el contendero de la información del servicio
  Widget cardDeServicio() {
    final fecha = servicio.fechayhora.split("T");
    final precio = _validarPrecioServicio();
    final placa = _validarVehiculoServicio();
    final size = MediaQuery.of(context).size;
    return Card(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      elevation: 5,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: size.width * 0.65,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subTitulosDelServicio(subtitulo: "Origen"),
                      textoDelServicio(texto: servicio.nombreOrigen),
                      const SizedBox(height: 6),
                      subTitulosDelServicio(subtitulo: "Destino"),
                      textoDelServicio(texto: servicio.nombreDestino),
                      const SizedBox(height: 6),
                      subTitulosDelServicio(subtitulo: "Fecha"),
                      textoDelServicio(texto: fecha[0])
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitulosDelServicio(subtitulo: "Placa"),
                    textoDelServicio(texto: placa),
                    const SizedBox(height: 6),
                    subTitulosDelServicio(subtitulo: "Valor servicio"),
                    textoDelServicio(texto: precio),
                    const SizedBox(height: 6),
                    subTitulosDelServicio(subtitulo: "Hora"),
                    textoDelServicio(texto: fecha[1].split(".")[0])
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///  Valida el valor del precio del servicio con una lista que se encuentra preCargada en el Bloc
  String _validarPrecioServicio() {
    final auxilioEconomico =
        BlocProvider.of<PreserviciosBloc>(context).state.precios;

    for (var precio in auxilioEconomico) {
      if (precio.uid == servicio.auxilioEconomico) {
        NumberFormat formato = NumberFormat("#,##0", "es_AR");
        return '\$ ' + formato.format(precio.valor);
      }
    }
    return '';
  }

  ///  Valida la placa del vehiculo que va a prestar el servicio con una lista que se encuentra preCargada en el Bloc
  String _validarVehiculoServicio() {
    final vehiculos =
        BlocProvider.of<PreserviciosBloc>(context).state.vehiculos;

    for (var vehiculo in vehiculos) {
      if (vehiculo.uid == servicio.idVehiculo) {
        return vehiculo.placa;
      }
    }
    return '';
  }

  /// Muestra el mapa con la ruta establecida de destino.
  Widget _mostrarMapa() {
    final size = MediaQuery.of(context).size;
    final mapaBloc = BlocProvider.of<MapsBloc>(context);

    // Deecodificar
    final puntos = decodePolyline(servicio.polylineRuta, accuracyExponent: 6);

    final latLngLista = puntos
        .map((coord) => LatLng(coord[0].toDouble(), coord[1].toDouble()))
        .toList();

    final destino = RutaDestino(
        puntos: latLngLista,
        duracion: double.parse(servicio.duracion),
        distancia: double.parse(servicio.distancia),
        lugarFinal: Feature(text: servicio.nombreDestino));

    return FutureBuilder(
      builder: (context, snapshot) {
        mapaBloc.dibujarRutaPolyline(context, destino);
        return SlidingUpPanel(
          margin: const EdgeInsets.all(15),
          maxHeight: size.height * 0.282,
          minHeight: size.height * 0.282,
          parallaxEnabled: true,
          parallaxOffset: .5,
          panelBuilder: (sc) =>
              BlocBuilder<LocalizacionBloc, LocalizacionState>(
                  builder: (context, localizacionState) {
            return BlocBuilder<MapsBloc, MapsState>(
                builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);
              return MapaView(
                  initialLocalizacion: latLngLista[latLngLista.length - 1],
                  markers: mapState.markers.values.toSet(),
                  polylines: polylines.values.toSet());
            });
          }),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          onPanelSlide: (double pos) => setState(() {}),
        );
      },
    );
  }

  ///Contiene el titulo de los postulados y la lista de los pasajeros.
  Widget _listadoUsuariosPostulados() {
    final size = MediaQuery.of(context).size;

    return Container(
        height: size.height * 0.24,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            Center(child: tituloDelServicio(titulo: 'Tus pasajeros')),
            SizedBox(height: size.height * 0.015),
            pasajeros(),
            SizedBox(height: size.height * 0.015),
          ],
        ));
  }

  /// Crea una lista con la data que trae del server para mostrar la lista de pasajeros.
  Widget pasajeros() {
    List<Widget> pasejeros = [];
    for (PasajeroElement pasajero in servicio.pasajeros) {
      pasejeros.add(_cardUsuarioPostulado(pasajero.pasajero!, 2));
    }

    return Column(children: pasejeros);
  }

  /// Contienes los botones del servicio  (Comenzar servicio, editar, eliminar)
  Widget _botonesDelServicio() {
    final size = MediaQuery.of(context).size;

    /// Validar si
    ///  True: Se elimina el servicio
    ///  False: se Iniica el servicio
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: size.width * 0.6,
          child: BtnAnaranja(
            titulo: validar == false ? 'Iniciar' : 'Detener',
            function: () async {
              if (validar) {
                _detenerServicio();
              } else {
                _activarServicio();
              }
              setState(() {});
            },
          ),
        ),

        /// Boton para poder editar el servicio
        BtnNaranjaIcon(
          titulo: const Icon(Icons.edit, color: Colors.white),
          function: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditarServicioPag(callbackFunction: callbackFunction),
            ),
          ),
        ),
        _botonEliminar()
      ],
    );
  }

  void _activarServicio() {
    mostrarShowDialogValidar(
      context: context,
      titulo: '¿Desea iniciar el servicio?',
      contenido:
          'El servicio se iniciará y notificará a los pasajeros que el servicio ha comenzado.',
      icono: Icons.emoji_transportation_outlined,
      funtionCancelar: () {
        validar = false;
        Navigator.of(context, rootNavigator: true).pop(context);
        setState(() {});
      },
      funtionContinuar: () async {
        Navigator.of(context, rootNavigator: true).pop(context);
        mostrarShowDialogCargando(context: context, titulo: 'Cargando...');
        final servicioValidar =
            await ServicioRServicio().iniciarServicio(servicio.uid);
        Navigator.of(context, rootNavigator: true).pop(context);
        servicio.estado = EstadoServicio.camino;
        BlocProvider.of<ServicioBloc>(context)
            .buscarYcambiarServicioDelUsuario(servicio);

        if (servicioValidar) {
          validar = true;
          setState(() {});
          mostrarShowDialogCargando(
              context: context, titulo: 'Servicio iniciado');
          await Future.delayed(const Duration(seconds: 1));
          Navigator.of(context, rootNavigator: true).pop(context);
        } else {
          customShapeSnackBar(
              context: context, titulo: "No se pudo iniciar el servicio");
        }
      },
    );
  }

  void _detenerServicio() {
    mostrarShowDialogValidar(
      context: context,
      titulo: '¿Desea finalizar el servicio?',
      contenido:
          'El servicio se finalizara y notificará a los pasajeros que el servicio ha finalizado.',
      icono: Icons.emoji_transportation_outlined,
      funtionCancelar: () {
        validar = false;
        Navigator.of(context, rootNavigator: true).pop(context);
        setState(() {});
      },
      funtionContinuar: () async {
        Navigator.of(context, rootNavigator: true).pop(context);
        mostrarShowDialogCargando(context: context, titulo: 'Cargando...');
        final servicioValidar =
            await ServicioRServicio().finalizarServicio(servicio.uid);
        Navigator.of(context, rootNavigator: true).pop(context);

        if (servicioValidar) {
          final servicioBloc = BlocProvider.of<ServicioBloc>(context);

          servicioBloc.buscarYactualizarServicioDelUsuario(servicio);

          validar = true;

          calificacionesPasajeros();
          callbackFunction!();
          setState(() {});
        } else {
          customShapeSnackBar(
              context: context, titulo: "No se pudo finalizar el servicio");
        }
      },
    );
  }

  calificacionesPasajeros() {
    List calificaciones = [];
    int aux = 0;
    for (var pasajero in servicio.pasajeros) {
      aux = aux + 1;
      calificaciones.add(mostrarShowDialogCalificar(
        context: context,
        titulo: 'Calificación',
        contenido: 'Califica al usuario ${pasajero.pasajero!.nombre!}',
        icono: Icons.emoji_transportation_outlined,
        funtionContinuar: () async {
          final calificacion =
              BlocProvider.of<ServicioBloc>(context).state.calificacionAUsurio;
          if (calificacion != 0) {
            ServicioRServicio().calificarUsuario(
                servicio.uid, pasajero.pasajero!.id, calificacion.toString());
            BlocProvider.of<ServicioBloc>(context)
                .add(const OnCalificarAUsuario(0));
            Navigator.of(context, rootNavigator: true).pop(context);
            if (aux == servicio.pasajeros.length) {
              _finalizandoServicio();
            }
          } else {
            mostrarShowDialogInformativo(
                context: context,
                titulo: "Debe de calificar al usuario",
                contenido:
                    "Para poder finalizar el servicio debe de calificar el usuario.");
          }
        },
      ));
    }
    if (servicio.pasajeros.length == 0) {
      _finalizandoServicio();
    }

    return calificaciones;
  }

  void _finalizandoServicio() async {
    mostrarShowDialogCargando(
        context: context, titulo: 'Su servicio se esta finalizando...');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context, rootNavigator: true).pop(context);

    mostrarShowDialogCargando(
        context: context, titulo: 'Servicio finalizado, Muchas gracias');
    Navigator.of(context, rootNavigator: true).pop(context);
    await Future.delayed(const Duration(seconds: 1));

    Navigator.of(context).pop(context);
  }

  /// Contiene la logica para poder eliminar el servicio
  Widget _botonEliminar() {
    return

        /// boton para poder eliminar el servicio
        BtnNaranjaIcon(
      titulo: const Icon(Icons.delete, color: Colors.white),
      function: () async {
        mostrarShowDialogValidar(
          context: context,
          titulo: '¿Desea eliminar el servicio?',
          contenido: 'El servicio se eliminará de forma permanente.',
          icono: Icons.delete_forever_outlined,
          funtionContinuar: () async {
            final servicioBloc = BlocProvider.of<ServicioBloc>(context);

            servicioBloc.buscarYactualizarServicioDelUsuario(servicio);

            final validar =
                await ServicioRServicio().eliminarServicio(servicio);
            Navigator.of(context, rootNavigator: true).pop(context);
            if (validar) {
              mostrarShowDialogCargando(
                  context: context, titulo: 'Eliminando...');
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context, rootNavigator: true).pop(context);
              mostrarShowDialogCargando(
                  context: context, titulo: 'Servicio Eliminado');
              await Future.delayed(const Duration(seconds: 1));
              Navigator.of(context, rootNavigator: true).pop(context);
              callbackFunction!();
              Navigator.pop(context);
            } else {
              customShapeSnackBar(
                  context: context, titulo: "No se pudo eliminar el servicio");
            }
          },
        );
      },
    );
  }

  /// Es un contenedor general para mostrar la información de un usuario postulado
  Widget _cardUsuarioPostulado(Pasajero pasajero, int posicion) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.04,
                  child: Icon(Icons.person_add_alt_1_outlined,
                      size: size.width * 0.06),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30),
                  width: size.width * 0.6,
                  child: Text(pasajero.nombre!),
                ),
              ],
            ),
            IconButton(
                onPressed: () async {
                  const _storage = FlutterSecureStorage();
                  final token = await _storage.read(key: 'token');

                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    Navigator.of(context).push(navegarMapaFadeIn(
                        context,
                        ChatPag(
                            servicio: servicio.uid,
                            para: pasajero.id,
                            nombre: pasajero.nombre,
                            token: token)));
                  });
                },
                icon: Icon(Icons.chat_rounded, size: size.width * 0.06))
          ],
        ),
        height: size.height * 0.05,
        width: size.width * 0.9,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(1.0, 1.0), //(x,y)
              blurRadius: 9.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  Text tituloDelServicio({titulo}) {
    return Text(titulo,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

  Widget subTitulosDelServicio({subtitulo}) {
    return Text(subtitulo,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

  Widget textoDelServicio({texto}) {
    return Text(texto.toString());
  }
}
