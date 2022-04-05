import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:intl/intl.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/models/ruta_destino_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/response/busqueda_response.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetalleHistorialServicioPag extends StatefulWidget {
  const DetalleHistorialServicioPag({Key? key}) : super(key: key);

  @override
  _DetalleHistorialServicioPagState createState() =>
      _DetalleHistorialServicioPagState();
}

class _DetalleHistorialServicioPagState
    extends State<DetalleHistorialServicioPag> {
  Servicio servicio = Servicio();

  @override
  Widget build(BuildContext context) {
    servicio =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;

    setState(() {});
    return Scaffold(appBar: appBar(), body: body());
  }

  Widget body() {
    final placa = _validarVehiculoServicio(servicio.idVehiculo);
    final auxilio = _validarPrecioServicio(servicio.auxilioEconomico);
    final fecha = servicio.fechayhora.split("T");
    return Column(
      children: [
        GestureDetector(
          child: cardDeServicio(
              titulo: "Detalle",
              destino: servicio.nombreDestino.toString(),
              origen: servicio.nombreOrigen.toString(),
              fecha: DateTime.parse(fecha[0] + " " + fecha[1].split(".")[0]),
              nombreConductor: "Nombre conductor", //"Steven Estrada",
              placa: placa,
              cuposDisponibles: servicio.cantidadCupos.toString(),
              valorServicio: auxilio),
        ),
        _mostrarMapa(),
      ],
    );
  }

// Appbar de detalle historial
  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;

    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "PaDonde",
          style: TextStyle(
              fontSize: size.width * 0.055, fontWeight: FontWeight.bold),
        ));
  }

// Estilo de titulos en la card del historial
  Text tituloDelServicio({titulo}) {
    return Text(titulo,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

// Estilo de subtitulo en la card del historial
  Widget subTitulosDelServicio({subtitulo}) {
    return Text(subtitulo,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

// Estilo de texto usado en la card de historial
  Widget textoDelServicio({texto}) {
    return Text(texto);
  }

// Metodo que valida y retorna la placa del vehiculo
  String _validarVehiculoServicio(String uid) {
    final vehiculos =
        BlocProvider.of<PreserviciosBloc>(context).state.vehiculos;

    for (var vehiculo in vehiculos) {
      if (vehiculo.uid == uid) {
        return vehiculo.placa;
      }
    }
    return '';
  }

// Metodo que retorna el valor del servicio
  String _validarPrecioServicio(String auxilio) {
    final auxilioEconomico =
        BlocProvider.of<PreserviciosBloc>(context).state.precios;

    for (var precio in auxilioEconomico) {
      if (precio.uid == auxilio) {
        NumberFormat formato = NumberFormat("#,##0", "es_AR");
        return '\$ ' + formato.format(precio.valor);
      }
    }
    return '';
  }

// Card donde se muestra toda la información del historial
  Widget cardDeServicio(
      {String? titulo,
      String? origen,
      String? destino,
      DateTime? fecha,
      String? placa,
      String? nombreConductor,
      String? cuposDisponibles,
      String? valorServicio}) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
          // color: Theme.of(context).primaryColor.withOpacity(0.35),
          color: const Color.fromRGBO(238, 246, 232, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(size.width * 0.02),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    right: size.width * 0.04,
                    left: size.width * 0.04,
                    top: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tituloDelServicio(titulo: titulo),
                    Row(children: [
                      Icon(Icons.access_time_outlined, size: size.width * 0.05),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      textoDelServicio(texto: fecha.toString())
                    ]),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: size.width * 0.07, top: size.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: size.height * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subTitulosDelServicio(subtitulo: "Origen"),
                              SizedBox(
                                  width: size.width * 0.45,
                                  child: textoDelServicio(texto: origen)),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              subTitulosDelServicio(subtitulo: "Destino"),
                              SizedBox(
                                  width: size.width * 0.45,
                                  child: textoDelServicio(texto: destino)),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              // subTitulosDelServicio(subtitulo: "Conductor"),
                              // SizedBox(
                              //     width: size.width * 0.45,
                              //     child:
                              //         textoDelServicio(texto: nombreConductor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: size.width * 0.10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subTitulosDelServicio(subtitulo: "Cupos Disponibles"),
                        textoDelServicio(texto: cuposDisponibles),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        subTitulosDelServicio(subtitulo: "Valor Servicio"),
                        textoDelServicio(texto: valorServicio),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        subTitulosDelServicio(subtitulo: "Placa"),
                        textoDelServicio(texto: placa),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

// Contenedor del mapa el cual trae la ruta realizada en el servicio
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
        mapaBloc.dibujarRutaPolylineSinMarker(context, destino);
        return SlidingUpPanel(
          margin: const EdgeInsets.all(15),
          maxHeight: size.height * 0.45,
          minHeight: size.height * 0.45,
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
}
