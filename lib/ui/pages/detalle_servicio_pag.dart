import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

import 'package:pa_donde_app/data/response/busqueda_response.dart';

import 'package:pa_donde_app/data/services/servicios_servicio.dart';

import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/validacion_show.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';

import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class DetalleServicioPag extends StatefulWidget {
  final Function? callbackFunction;

  const DetalleServicioPag({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  State<DetalleServicioPag> createState() =>
      // ignore: no_logic_in_create_state
      _DetalleServicioPagState(callbackFunction);
}

class _DetalleServicioPagState extends State<DetalleServicioPag> {
  final Function? callbackFunction;

  Servicio servicio = Servicio();

  _DetalleServicioPagState(this.callbackFunction);

  @override
  Widget build(BuildContext context) {
    servicio =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;

    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          cardDeServicio(),
          _botonPostularse(),
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
          "Servicio ",
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
                    subTitulosDelServicio(subtitulo: "Valor Servicio"),
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

  /// Contienes los botones del servicio  (postularse)
  Widget _botonPostularse() {
    return BtnAnaranja(
      function: () async {
        mostrarShowDialogValidar(
          context: context,
          titulo: '¿Desea postularse al servicio?',
          contenido: 'Se apartara un cupo para que pueda tomar el servicio',
          paginaRetorno: 'inicio',
          icono: Icons.check_box_outlined,
          funtion: () async {
            final servicioBloc = BlocProvider.of<ServicioBloc>(context);

            servicioBloc.buscarYactualizarServicioGenerales(servicio);

            servicioBloc.actualizarServicioPostulado(servicio);

            final validar =
                await ServicioRServicio().postularseServicio(servicio.uid);
            Navigator.of(context, rootNavigator: true).pop(context);
            if (validar) {
              mostrarShowDialogCargando(
                  context: context, titulo: 'Postulandose...');
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context, rootNavigator: true).pop(context);
              mostrarShowDialogCargando(
                  context: context, titulo: 'Se ha postulado al servicio');
              await Future.delayed(const Duration(seconds: 1));
              Navigator.of(context, rootNavigator: true).pop(context);
              callbackFunction!();
              Navigator.pop(context);
            } else {
              customShapeSnackBar(
                  context: context, titulo: "No se pudo postular al servicio");
            }
          },
        );
      },
      titulo: 'Postularse',
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
