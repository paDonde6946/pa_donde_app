import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/global_widgets/views/mapa_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//------------------IMPORTACIONES LOCALES------------------------------
// import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
// import 'package:provider/provider.dart';
//---------------------------------------------------------------------

class DetalleServicioPag extends StatefulWidget {
  const DetalleServicioPag({Key? key}) : super(key: key);

  @override
  _DetalleServicioPagState createState() => _DetalleServicioPagState();
}

class _DetalleServicioPagState extends State<DetalleServicioPag> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(appBar: appBar(), body: body());
  }

  Widget body() {
    // final usuario = Provider.of<AutenticacionServicio>(context, listen: false)
    //  .usuarioServiciosActual;
    ///TODO: Cambiar cuando este listo
    // if (usuario.cambio_contrasenia == 0) {
    //   SchedulerBinding.instance!.addPostFrameCallback((_) {
    //     mostrarShowDialogConfirmar(
    //         context: context,
    //         titulo: "Cambio de Contraseña",
    //         contenido:
    //             "Hemos notado que has cambiado tu contraseña. Para mayor seguridad cambia la contraseña por una personal.",
    //         paginaRetorno: 'editarPerfil');
    //     // add your code here.
    //   });
    // }

    return Column(
      children: [
        GestureDetector(
          child: cardDeServicio(
              titulo: "Detalles del Servicio",
              destino: "Calle 74 A - No. 113 A - 47",
              origen: "Calle 74 A - No. 113 A - 47",
              fecha: DateTime.parse("1969-07-20 20:18:04Z"),
              nombreConductor: "Steven Estrada",
              placa: "AAAXXX",
              cuposDisponibles: "4",
              valorServicio: "30000"),
        ),
      ],
    );
  }

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
                    tituloDelServicio(titulo: titulo),
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
                              textoDelServicio(texto: origen),
                              const SizedBox(
                                height: 6,
                              ),
                              subTitulosDelServicio(subtitulo: "Destino"),
                              textoDelServicio(texto: destino),
                              const SizedBox(
                                height: 6,
                              ),
                              subTitulosDelServicio(subtitulo: "Conductor"),
                              textoDelServicio(texto: nombreConductor),
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
                        const SizedBox(
                          height: 6,
                        ),
                        subTitulosDelServicio(subtitulo: "Valor Servicio"),
                        textoDelServicio(texto: valorServicio),
                        const SizedBox(
                          height: 6,
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
        SlidingUpPanel(
          margin: const EdgeInsets.all(15),
          maxHeight: size.height * 0.47,
          minHeight: size.height * 0.47,
          parallaxEnabled: true,
          parallaxOffset: .5,
          panelBuilder: (sc) =>
              BlocBuilder<LocalizacionBloc, LocalizacionState>(
                  builder: (context, localizacionState) {
            return BlocBuilder<MapsBloc, MapsState>(
                builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);
              return MapaView(
                  initialLocalizacion: localizacionState.ultimaLocalizacion!,
                  markers: mapState.markers.values.toSet(),
                  polylines: polylines.values.toSet());
            });
          }),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          onPanelSlide: (double pos) => setState(() {}),
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
          "PaDonde",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ));
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
    return Text(texto);
  }
}
