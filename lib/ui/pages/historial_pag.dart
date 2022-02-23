// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

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
  @override
  Widget build(BuildContext context) {
    Servicio servicio = Servicio();
    // setState(() {});
    return Scaffold(appBar: appBar(), body: _tabSection(servicio));
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

  Widget _tabSection(Servicio servicio) {
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
            height: MediaQuery.of(context).size.height * 0.62,
            child: TabBarView(children: [
              cardDeServicioUsuario(servicio),
              cardDeServicioConductor(servicio)
            ]),
          ),
        ],
      ),
    );
  }

  Widget cardDeServicioUsuario(Servicio servicio) {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
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
                            texto:
                                "Calle 74 A - No. 113 A - 47"), // servicio.historialDestino.toString()
                        const SizedBox(
                          height: 6,
                        ),
                        subTitulosDelServicio(subtitulo: "Placa"),
                        textoDelServicio(
                            texto: "AAAXXX"), // servicio.idVehiculo.toString()
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitulosDelServicio(subtitulo: "Valor"),
                    textoDelServicio(
                        texto: "30000"), //servicio.auxilioEconomico.toString()
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, size: 20),
                        textoDelServicio(
                            texto: DateFormat(' EEE, MMM d, ' 'yy')
                                .format(DateTime.now())),
                      ],
                    ),
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
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
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
                            texto:
                                "Calle 74 A - No. 113 A - 47"), // servicio.historialDestino.toString()
                        const SizedBox(
                          height: 6,
                        ),
                        subTitulosDelServicio(subtitulo: "Placa"),
                        textoDelServicio(
                            texto: "AAAXXX"), // servicio.idVehiculo.toString()
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitulosDelServicio(subtitulo: "Valor"),
                    textoDelServicio(
                        texto: "30000"), //servicio.auxilioEconomico.toString()
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, size: 20),
                        textoDelServicio(
                            texto: DateFormat(' EEE, MMM d, ' 'yy')
                                .format(DateTime.now())),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
