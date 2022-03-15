// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/cargando_widget.dart';

import 'detalle_historial_pag.dart';

//------------------IMPORTACIONES LOCALES------------------------------
// import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
// import 'package:provider/provider.dart';
//---------------------------------------------------------------------

class HistorialPag extends StatefulWidget {
  const HistorialPag({Key? key}) : super(key: key);

  @override
  _HistorialPagState createState() => _HistorialPagState();
}

class _HistorialPagState extends State<HistorialPag> {
  // List<Servicio> servicio = [];
  List<Servicio>? usuarioHistorial = [];
  List<Servicio>? conductorHistorial = [];
  @override
  Widget build(BuildContext context) {
    getHistorial(context);
    // setState(() {});
    final media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(),
        body: (usuarioHistorial == null || conductorHistorial == null)
            ? Cargando(size: media)
            : _tabSection());
  }

  PreferredSizeWidget appBar() {
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Historial",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ));
  }

  Widget subTitulosDelServicio({subtitulo}) {
    return Text(subtitulo,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

  Widget textoDelServicio({texto}) {
    return Text(texto);
  }

  /// Puntuacion recibida y dada del servicio
  Widget cuadroEstrella(String calificacion) {
    final media = MediaQuery.of(context).size;
    return Row(
      children: [
        Text(
          calificacion,
          style: TextStyle(fontSize: media.height * 0.02, color: Colors.black),
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: media.width * 0.04,
        ),
      ],
    );
  }

  getHistorial(context) async {
    usuarioHistorial =
        BlocProvider.of<ServicioBloc>(context).state.historialComoUsuario;
    conductorHistorial =
        BlocProvider.of<ServicioBloc>(context).state.historialComoConductor;

    if (usuarioHistorial == null || conductorHistorial == null) {
      ServicioRServicio servicioServicio = ServicioRServicio();
      var response = await servicioServicio.getHistorial();
      usuarioHistorial = response.serviciosComoUsuario;
      conductorHistorial = response.serviciosComoConductor;
      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarHistorialUsuario(usuarioHistorial));
      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarHistorialConductor(conductorHistorial));
    }
    setState(() {});
  }

  Widget _tabSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          TabBar(
              unselectedLabelColor: Theme.of(context).primaryColorLight,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColorLight),
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Usuario"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Conductor"),
                  ),
                ),
              ]),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.71,
            child: TabBarView(children: <Widget>[
              panelHistorialUsuario(),
              panelHistorialConductor()
            ]),
          ),
        ],
      ),
    );
  }

  Widget panelHistorialUsuario() {

    if (usuarioHistorial!.isNotEmpty) {
      for (var i = 0; i < usuarioHistorial!.length; i++) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: usuarioHistorial!.length,
          itemBuilder: (context, i) =>
              cardDeServicioConductor(usuarioHistorial![i]),
        );
      }
    }
    return Text("No posee servicios como usuario");
  }

  Widget panelHistorialConductor() {
    if (conductorHistorial!.isNotEmpty) {
      for (var i = 0; i < conductorHistorial!.length; i++) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: conductorHistorial!.length,
          itemBuilder: (context, i) =>
              cardDeServicioConductor(conductorHistorial![i]),
        );
      }
    }
    return Text("No posee servicios como conductor");
  }

  Widget cardDeServicioUsuario(Servicio servicio) {
    final size = MediaQuery.of(context).size;
    final placa = _validarVehiculoServicio(servicio.idVehiculo);
    final auxilio = _validarPrecioServicio(servicio.auxilioEconomico);
    final fecha = servicio.fechayhora.split("T");

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            BlocProvider.of<ServicioBloc>(context)
                .add(OnServicioSeleccionado(servicio));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DetalleHistorialServicioPag()),
            );
          },
          child: Card(
            color: const Color.fromRGBO(238, 246, 232, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(15),
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: cuadroEstrella('5.0')),
                    const Icon(Icons.person_outlined, size: 45)
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subTitulosDelServicio(subtitulo: "Destino"),
                        textoDelServicio(
                            texto: servicio.nombreDestino.toString()),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 20),
                            textoDelServicio(
                                texto: fecha[0] + " " + fecha[1].split(".")[0]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitulosDelServicio(subtitulo: "Valor"),
                    textoDelServicio(texto: auxilio),
                    const SizedBox(
                      height: 5,
                    ),
                    subTitulosDelServicio(subtitulo: "Placa"),
                    textoDelServicio(texto: placa),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget cardDeServicioConductor(Servicio servicio) {
    final size = MediaQuery.of(context).size;
    final placa = _validarVehiculoServicio(servicio.idVehiculo);
    final auxilio = _validarPrecioServicio(servicio.auxilioEconomico);
    final fecha = servicio.fechayhora.split("T");
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            BlocProvider.of<ServicioBloc>(context)
                .add(OnServicioSeleccionado(servicio));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DetalleHistorialServicioPag()),
            );
          },
          child: Card(
            color: const Color.fromRGBO(238, 246, 232, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(15),
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: cuadroEstrella('5.0')),
                    const Icon(Icons.drive_eta_outlined, size: 45)
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subTitulosDelServicio(subtitulo: "Destino"),
                        textoDelServicio(
                            texto: servicio.nombreDestino.toString()),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 20),
                            textoDelServicio(
                                texto: fecha[0] + " " + fecha[1].split(".")[0]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitulosDelServicio(subtitulo: "Valor"),
                    textoDelServicio(texto: auxilio),
                    const SizedBox(
                      height: 5,
                    ),
                    subTitulosDelServicio(subtitulo: "Placa"),
                    textoDelServicio(texto: placa),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
}
