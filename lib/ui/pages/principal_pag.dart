import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'detalle_servicio_pag.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/pages/detalle_postulado_servicio_pag.dart';
import 'package:pa_donde_app/ui/pages/detalle_tu_servicio_pag.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
// import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
// import 'package:provider/provider.dart';
//---------------------------------------------------------------------

class PrincipalPag extends StatefulWidget {
  const PrincipalPag({Key? key}) : super(key: key);

  @override
  _PrincipalPagState createState() => _PrincipalPagState();
}

class _PrincipalPagState extends State<PrincipalPag> {
  PageController controller = PageController();
  int page = 0;
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
        "m|p}G~zoelCbBaFag@_TwV~y@rsA|t@xePjcDrpIfyCyqHj|Syy@hsH}~@nfHg`DzgRdPzpD`z@tkCl|IhsLzwFdnHppTn|L|q@zh@f^ttAufGtyK`wPlkRztBbqDnGda@iwCzeC}oA{o@xVqe@r`MlrJo|G`fHdlCvbForF`fFgjCysAqDqw@",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: body());
  }

  Widget body() {
    // final usuario = Provider.of<AutenticacionServicio>(context, listen: false)
    //  .usuarioServiciosActual;
    // /TODO: Cambiar cuando este listo
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
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 30, top: 10),
                child: Text(
                  "Tus servicios",
                  style: TextStyle(fontSize: size.width * 0.05),
                )),
            SizedBox(
              width: double.infinity,
              height: 120,
              child: listadoServiciosDelUsuario(),
            ),
            Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  "Servicios Postulados",
                  style: TextStyle(fontSize: size.width * 0.05),
                )),
            SizedBox(
              width: double.infinity,
              height: 140,
              child: PageView(
                onPageChanged: (i) {
                  page = i;
                },
                controller: controller,
                children: [
                  cardSerPostulados(servicio),
                  cardSerPostulados(servicio),
                ],
              ),
            )
          ],
        ),
        SlidingUpPanel(
          maxHeight: 500,
          minHeight: 300,
          parallaxEnabled: true,
          parallaxOffset: .5,
          panelBuilder: (sc) {
            return ListView(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30, top: 10),
                    child: Text(
                      "Servicios Generales",
                      style: TextStyle(fontSize: size.width * 0.04),
                    )),
                cardDeServicio(servicio),
              ],
            );
          },
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          onPanelSlide: (double pos) => setState(() {}),
        ),
      ],
    );
  }

  Widget listadoServiciosDelUsuario() {
    final servicios =
        BlocProvider.of<ServicioBloc>(context).state.serviciosDelUsuario;

    return PageView.builder(
      itemCount: servicios.length,
      itemBuilder: (context, index) {
        return cardTuServicio(servicios[index]);
      },
    );
  }

  Widget listadoServiciosPostulados() {
    final servicios =
        BlocProvider.of<ServicioBloc>(context).state.serviciosPostulados;

    return PageView.builder(
      itemCount: servicios.length,
      itemBuilder: (context, index) {
        return cardSerPostulados(servicios[index]);
      },
    );
  }

  Widget cardTuServicio(Servicio servicio) {
    final fecha = servicio.fechayhora.split("T");

    return GestureDetector(
      onTap: () {
        BlocProvider.of<ServicioBloc>(context)
            .add(OnServicioSeleccionado(servicio));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetalleTuServicio()),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(15),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(238, 246, 232, 1),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 30, left: 30, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    subTitulosDelServicio(subtitulo: "Destino"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time_outlined, size: 20),
                        const SizedBox(width: 10),
                        textoDelServicio(
                            texto: fecha[0] + ' ' + fecha[1].split(".")[0]),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: textoDelServicio(texto: servicio.nombreDestino),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      subTitulosDelServicio(subtitulo: "Cupos"),
                      const SizedBox(width: 10),
                      textoDelServicio(texto: servicio.cantidadCupos),
                    ],
                  ),
                  Row(
                    children: [
                      subTitulosDelServicio(subtitulo: "Pasajeros"),
                      const SizedBox(width: 10),
                      textoDelServicio(texto: servicio.cantidadCupos),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardDeServicio(Servicio servicio) {
    final fecha = servicio.fechayhora.split("T");
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ServicioBloc>(context)
            .add(OnServicioSeleccionado(servicio));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetalleServicioPag()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(238, 246, 232, 1),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 30, left: 30, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tituloDelServicio(titulo: "Pa Donde"),
                    Row(children: [
                      const Icon(Icons.access_time_outlined, size: 20),
                      textoDelServicio(
                          texto: fecha[0] + ' ' + fecha[1].split(".")[0]),
                    ]),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          subTitulosDelServicio(subtitulo: "Origen"),
                          textoDelServicio(texto: servicio.nombreOrigen),
                          const SizedBox(
                            height: 6,
                          ),
                          subTitulosDelServicio(subtitulo: "Destino"),
                          textoDelServicio(texto: servicio.nombreDestino)
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            child: subTitulosDelServicio(subtitulo: "Cupos"),
                            padding: const EdgeInsets.only(right: 50)),
                        Container(
                          child:
                              textoDelServicio(texto: servicio.cantidadCupos),
                          padding: const EdgeInsets.only(bottom: 18, right: 80),
                        ),
                        botonDelServicio(nombreBoton: "Ver mas"),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardSerPostulados(Servicio servicio) {
    final fecha = servicio.fechayhora.split("T");

    return GestureDetector(
      onTap: () {
        BlocProvider.of<ServicioBloc>(context)
            .add(OnServicioSeleccionado(servicio));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DetallePostuladoServicio()),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(15),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(238, 246, 232, 1),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 30, left: 30, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    subTitulosDelServicio(subtitulo: "Origen"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time_outlined, size: 20),
                        const SizedBox(width: 10),
                        textoDelServicio(
                            texto: fecha[0] + ' ' + fecha[1].split(".")[0]),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: textoDelServicio(texto: servicio.nombreOrigen),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: subTitulosDelServicio(subtitulo: "Destino")),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: textoDelServicio(texto: servicio.nombreDestino),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: IconButton(
                        onPressed: () {
                          SchedulerBinding.instance!.addPostFrameCallback((_) {
                            Navigator.of(context)
                                .push(navegarMapaFadeIn(context, ChatPag()));
                          });
                        },
                        icon: const Icon(Icons.chat, size: 35)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
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
        overflow: TextOverflow.ellipsis,
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

  Widget botonDelServicio({String nombreBoton = ''}) {
    return Container(
      height: 40,
      width: 100,
      // padding: EdgeInsets.only(bottom: ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10), topLeft: Radius.circular(10)),
        color: Theme.of(context).primaryColorLight,
      ),
      child: IconButton(
        icon: Text(
          nombreBoton,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetalleServicioPag()),
          );
        },
      ),
    );
  }
}
