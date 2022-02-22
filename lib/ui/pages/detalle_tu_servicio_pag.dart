import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';

class DetalleTuServicio extends StatefulWidget {
  const DetalleTuServicio({Key? key}) : super(key: key);

  @override
  State<DetalleTuServicio> createState() => _DetalleTuServicioState();
}

class _DetalleTuServicioState extends State<DetalleTuServicio> {
  Servicio servicio = Servicio(
    pAuxilioEconomico: "61f1f9e7d41447b8ea79d2eb",
    pCantidadCupos: 3,
    pDistancia: "4451.591",
    pDuracion: "802.541",
    pFechayhora: "2022-02-20T10:37:00.000+00:00",
    pIdVehiculo: "6190885bf803e870847c6e73",
    pNombreDestino: "Hayuelos Centro Comercial",
    pNombreOrigen: "Tintal Plaza",
    pPolylineRuta:
        "yui[tprcMm@}@`CcBdEjGV~@t@Tx@SXo@e@qAuCo@u[e_@}p@qr@qWk^aVuSoR{Ma@cANqB",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: cardDeServicio(servicio));
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

  Widget cardDeServicio(Servicio servicio) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
          // color: Theme.of(context).primaryColor.withOpacity(0.35),
          color: const Color.fromRGBO(238, 246, 232, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(15),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 30, left: 30, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.access_time_outlined, size: 20),
                      textoDelServicio(
                          texto: DateFormat(' EEE, MMM d, ' 'yy')
                              .format(DateTime.now()))
                    ]),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subTitulosDelServicio(subtitulo: "Origen"),
                              textoDelServicio(texto: servicio.nombreOrigen),
                              const SizedBox(
                                height: 6,
                              ),
                              subTitulosDelServicio(subtitulo: "Destino"),
                              textoDelServicio(texto: servicio.nombreDestino),
                              const SizedBox(
                                height: 6,
                              ),
                              subTitulosDelServicio(subtitulo: "Placa"),
                              //TODO: Cambiar cuando willy suba lo suyo

                              textoDelServicio(texto: 'FSW123'),
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
                        textoDelServicio(texto: servicio.cantidadCupos),
                        const SizedBox(
                          height: 6,
                        ),
                        subTitulosDelServicio(subtitulo: "Valor Servicio"),
                        textoDelServicio(texto: '2.000'),
                        const SizedBox(
                          height: 6,
                        ),
                        subTitulosDelServicio(subtitulo: "Postulados"),
                        textoDelServicio(texto: '2'),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        // SlidingUpPanel(
        //   margin: const EdgeInsets.all(15),
        //   maxHeight: size.height * 0.47,
        //   minHeight: size.height * 0.47,
        //   parallaxEnabled: true,
        //   parallaxOffset: .5,
        //   panelBuilder: (sc) =>
        //       BlocBuilder<LocalizacionBloc, LocalizacionState>(
        //           builder: (context, localizacionState) {
        //     return BlocBuilder<MapsBloc, MapsState>(
        //         builder: (context, mapState) {
        //       Map<String, Polyline> polylines = Map.from(mapState.polylines);
        //       return MapaView(
        //           initialLocalizacion: localizacionState.ultimaLocalizacion!,
        //           markers: mapState.markers.values.toSet(),
        //           polylines: polylines.values.toSet());
        //     });
        //   }),
        //   borderRadius: const BorderRadius.all(Radius.circular(18)),
        //   onPanelSlide: (double pos) => setState(() {}),
        // ),
      ],
    );
  }

  Text tituloDelServicio({titulo}) {
    return Text(titulo,
        style: TextStyle(
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
