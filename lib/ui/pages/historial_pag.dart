import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    // setState(() {});
    return Scaffold(appBar: appBar(), body: body());
  }

  Widget body() {
    return ListView(
      children: [
        Container(
          child: cardDeServicio(
              destino: "Calle 74 A - No. 113 A - 47",
              fecha: DateTime.parse("1969-07-20 20:18:04Z"),
              placa: "AAAXXX",
              valorServicio: "30000"),
        ),
      ],
    );
  }

  Widget cardDeServicio(
      {String? destino,
      DateTime? fecha,
      String? placa,
      String? valorServicio}) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
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
                      child: cuadroEstrella(
                          '5.0')),
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
                      textoDelServicio(texto: destino),
                      const SizedBox(
                        height: 6,
                      ),
                      subTitulosDelServicio(subtitulo: "Placa"),
                      textoDelServicio(texto: placa),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.05,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  subTitulosDelServicio(subtitulo: "Valor"),
                  textoDelServicio(texto: valorServicio),
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
      ],
    );
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
}
