import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:provider/provider.dart';
//---------------------------------------------------------------------

class PrincipalPag extends StatefulWidget {
  const PrincipalPag({Key? key}) : super(key: key);

  @override
  _PrincipalPagState createState() => _PrincipalPagState();
}

class _PrincipalPagState extends State<PrincipalPag> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(appBar: appBar(), body: body());
  }

  Widget body() {
    final usuario = Provider.of<AutenticacionServicio>(context, listen: false)
        .usuarioServiciosActual;
    //TODO: Cambiar cuando este listo
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

    return ListView(
      children: [
        cardDeServicio(
            titulo: "Pa Donde",
            destino: "Calle 74 A - No. 113 A - 47",
            origen: "Calle 74 A - No. 113 A - 47",
            fecha: DateTime.parse("1969-07-20 20:18:04Z")),
        cardDeServicio(
            titulo: "Pa Donde",
            destino: "Calle 74 A - No. 113 A - 47",
            origen: "Calle 74 A - No. 113 A - 47",
            fecha: DateTime.parse("1969-07-20 20:18:04Z"))
      ],
    );
  }

  Widget cardDeServicio(
      {String? titulo, String? origen, String? destino, DateTime? fecha}) {
    return Card(
      // color: Theme.of(context).primaryColor.withOpacity(0.35),
      color: const Color.fromRGBO(238, 246, 232, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tituloDelServicio(titulo: titulo),
                Row(children: [
                  const Icon(Icons.access_time_outlined, size: 20),
                  textoDelServicio(
                      texto: DateFormat('hh:mm a').format(DateTime.now()))
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
                      textoDelServicio(texto: origen),
                      const SizedBox(
                        height: 6,
                      ),
                      subTitulosDelServicio(subtitulo: "Destino"),
                      textoDelServicio(texto: destino)
                    ],
                  ),
                ),
                botonDelServicio(nombreBoton: "Ver mas")
              ],
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;
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
        onPressed: () => {},
      ),
    );
  }
}
