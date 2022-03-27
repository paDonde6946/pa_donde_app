import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:intl/intl.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

import 'package:pa_donde_app/data/response/busqueda_response.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja_icono.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/validacion_show.dart';

import 'package:pa_donde_app/blocs/blocs.dart';

import 'package:pa_donde_app/data/services/servicios_servicio.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';
//---------------------------------------------------------------------

class DetallePostuladoServicio extends StatefulWidget {
  final Function? callbackFunction;

  const DetallePostuladoServicio({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  State<DetallePostuladoServicio> createState() =>
      // ignore: no_logic_in_create_state
      _DetallePostuladoServicioState(callbackFunction);
}

class _DetallePostuladoServicioState extends State<DetallePostuladoServicio> {
  Servicio servicio = Servicio();
  final Function? callbackFunction;

  _DetallePostuladoServicioState(this.callbackFunction);

  @override
  Widget build(BuildContext context) {
    servicio =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;

    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          cardDeServicio(),
          _botonesChatYCancelar(),
          _mostrarMapa(),
        ],
      ),
    );
  }

  /// AppBar personalizado que se muestra en la parte superior de la pantalla
  PreferredSizeWidget appBar() {
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Servicio Postulado",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      margin: const EdgeInsets.all(10),
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

  /// Contienes los botones del servicio  (para Cancelar el servicio y para chatear)
  Widget _botonesChatYCancelar() {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: size.width * 0.7,
          child: _botonCancelarPostulacion(),
        ),
        BtnNaranjaIcon(
          function: () async {
            const _storage = FlutterSecureStorage();
            final token = await _storage.read(key: 'token');

            Navigator.of(context).push(navegarMapaFadeIn(
                context,
                ChatPag(
                    servicio: servicio.uid,
                    para: "",
                    nombre: servicio.nombreConductor,
                    token: token)));
          },
          titulo: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Contiene la logica para poder eliminar el servicio
  Widget _botonCancelarPostulacion() {
    return

        /// boton para poder eliminar el servicio
        BtnAnaranja(
      titulo: 'Cancelar Postulación',
      function: () async {
        mostrarShowDialogValidar(
          context: context,
          titulo: '¿Desea cancelar el servicio?',
          contenido:
              'Se borrará la postulación al servicio y el cupo quedará libre',
          icono: Icons.unpublished,
          funtionContinuar: () async {
            BlocProvider.of<ServicioBloc>(context)
                .buscarYactualizarServicioPostulado(servicio);

            BlocProvider.of<ServicioBloc>(context)
                .actualizarServicioGeneral(servicio);

            final validar =
                await ServicioRServicio().cancelarServicio(servicio.uid);
            Navigator.of(context, rootNavigator: true).pop(context);
            if (validar) {
              mostrarShowDialogCargando(
                  context: context, titulo: 'Eliminando postulación...');
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context, rootNavigator: true).pop(context);
              mostrarShowDialogCargando(
                  context: context, titulo: 'Haz cancelado el servicio');
              await Future.delayed(const Duration(seconds: 1));
              Navigator.of(context, rootNavigator: true).pop(context);
              callbackFunction!();
              Navigator.pop(context);
            } else {
              customShapeSnackBar(
                  context: context, titulo: "No se pudo cancelar el servicio");
            }
          },
        );
      },
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
          maxHeight: size.height * 0.485,
          minHeight: size.height * 0.485,
          parallaxEnabled: true,
          parallaxOffset: .5,
          panelBuilder: (sc) =>
              BlocBuilder<LocalizacionBloc, LocalizacionState>(
                  builder: (context, localizacionState) {
            return BlocBuilder<MapsBloc, MapsState>(
                builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);
              return MapaView(
                  initialLocalizacion: latLngLista[0],
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
