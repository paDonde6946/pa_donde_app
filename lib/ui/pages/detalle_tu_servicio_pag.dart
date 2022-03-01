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

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';

import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class DetalleTuServicio extends StatefulWidget {
  const DetalleTuServicio({Key? key}) : super(key: key);

  @override
  State<DetalleTuServicio> createState() => _DetalleTuServicioState();
}

class _DetalleTuServicioState extends State<DetalleTuServicio> {
  Servicio servicio = Servicio();

  @override
  Widget build(BuildContext context) {
    servicio =
        BlocProvider.of<ServicioBloc>(context).state.servicioSeleccionado;

    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          cardDeServicio(),
          _listadoUsuariosPostulados(),
          _mostrarMapa(),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Tu servicio",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ));
  }

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
          _botonesEditarYEliminar()
        ],
      ),
    );
  }

  Widget _botonesEditarYEliminar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BtnAnaranja(
          function: () {},
          titulo: 'Editar',
        ),
        BtnAnaranja(
          function: () {},
          titulo: 'Eliminar',
        ),
      ],
    );
  }

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

  Widget _listadoUsuariosPostulados() {
    final size = MediaQuery.of(context).size;

    return Container(
        height: size.height * 0.2,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            // SizedBox(height: 5),
            const Text('Tus pasajeros'),
            const SizedBox(height: 10),
            _cardUsuarioPostulado('Steven Estrada', 0),
            const SizedBox(height: 20),
            _cardUsuarioPostulado('Steven Estrada', 0),
            const SizedBox(height: 20),
            _cardUsuarioPostulado('Steven Estrada', 0),
            const SizedBox(height: 20),
            _cardUsuarioPostulado('Steven Estrada', 0),
            const SizedBox(height: 20),
          ],
        ));
  }

  Widget _cardUsuarioPostulado(String nombre, int posicion) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
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
                  child: Text(nombre),
                ),
              ],
            ),
            IconButton(
                onPressed: () {},
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
