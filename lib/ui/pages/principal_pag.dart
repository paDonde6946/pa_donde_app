// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'detalle_servicio_pag.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/confirmacion_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/calificar_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';

import 'package:pa_donde_app/ui/pages/detalle_postulado_servicio_pag.dart';
import 'package:pa_donde_app/ui/pages/detalle_tu_servicio_pag.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';

import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';

import 'package:pa_donde_app/blocs/blocs.dart';

import 'package:pa_donde_app/ui/helpers/helpers.dart';
//---------------------------------------------------------------------

class PrincipalPag extends StatefulWidget {
  const PrincipalPag({Key? key}) : super(key: key);

  @override
  _PrincipalPagState createState() => _PrincipalPagState();
}

class _PrincipalPagState extends State<PrincipalPag> {
  /// Metodo para refrescar la pagina
  callback() {
    setState(() {});
  }

  PageController controller = PageController(viewportFraction: 0.9);
  PageController controllerPos = PageController(viewportFraction: 0.9);

  int page = 0;

  @override
  Widget build(BuildContext context) {
    validarCalificarConductor();
    validarCambioContrasenia();

    return Scaffold(appBar: appBar(), body: body());
  }

  /// Encabezado de la pagina
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

  /// Cuerpo de la pagina
  Widget body() {
    final serviciosDelUsuario =
        BlocProvider.of<ServicioBloc>(context).state.serviciosDelUsuario;

    final serviciosPostulados =
        BlocProvider.of<ServicioBloc>(context).state.serviciosPostulados;

    return Stack(
      children: [
        Column(
          children: [
            serviciosDelUsuario.isEmpty
                ? Container()
                : mostrarServiciosDelUsuario(),
            serviciosPostulados.isEmpty
                ? Container()
                : mostrarServiciosPostulados(),
          ],
        ),
        mostrarPanelServiciosGenerales(),
      ],
    );
  }

  /// Valida si el usuario ya realizo un cambio de contraseña, por el método del olvido de contraseña
  /// dado que se le da una contraseña aleatoria se valida para que la cambie por una que pueda recordar y por seguridad
  void validarCambioContrasenia() {
    final usuario = BlocProvider.of<UsuarioBloc>(context).state.usuario;

    if (usuario.cambioContrasenia == 1) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        mostrarShowDialogConfirmar(
            context: context,
            titulo: "Cambio de Contraseña",
            contenido:
                "Hemos notado que has cambiado tu contraseña. Para mayor seguridad cambia la contraseña por una personal.",
            paginaRetorno: 'editarContrasenia');
        // add your code here.
      });
    }
  }

  void validarCalificarConductor() {
    final usuario = BlocProvider.of<UsuarioBloc>(context).state.usuario;

    if (usuario.ultimoServicioCalificar != null) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        mostrarShowDialogCalificar(
            context: context,
            titulo: 'Califica tu último servicio',
            contenido: "Califica al conductor en tu último servicio tomado",
            icono: Icons.thumb_up_alt_outlined,
            funtionContinuar: () {
              final calificacion = BlocProvider.of<ServicioBloc>(context)
                  .state
                  .calificacionAUsurio;
              if (calificacion != 0) {
                ServicioRServicio().calificarConductor(
                    usuario.ultimoServicioCalificar, calificacion.toString());
                usuario.ultimoServicioCalificar = null;
                BlocProvider.of<UsuarioBloc>(context)
                    .add(OnActualizarUsuario(usuario));
                BlocProvider.of<ServicioBloc>(context)
                    .add(const OnCalificarAUsuario(0));
                Navigator.of(context, rootNavigator: true).pop(context);
              } else {
                mostrarShowDialogInformativo(
                    context: context,
                    titulo: "Debe de calificar al usuario",
                    contenido:
                        "Para poder finalizar el servicio debe de calificar el usuario.");
              }
            });
      });
    }
  }

  /// Valida si el panel esta expandido totalmente para cambiar los border redondos
  bool validarRedondoPanel() {
    final serviciosDelUsuario =
        BlocProvider.of<ServicioBloc>(context).state.serviciosDelUsuario;

    final serviciosPostulados =
        BlocProvider.of<ServicioBloc>(context).state.serviciosPostulados;

    if (serviciosDelUsuario.isEmpty && serviciosPostulados.isEmpty) {
      return true;
    }
    return false;
  }

  /// Valida la lista de cada unos de los diferentes tipos de servicios y con base a eso. Le da un tamaño al panel de los servicios generales
  double validarTamanioPanel() {
    final size = MediaQuery.of(context).size;

    final serviciosDelUsuario =
        BlocProvider.of<ServicioBloc>(context).state.serviciosDelUsuario;

    final serviciosPostulados =
        BlocProvider.of<ServicioBloc>(context).state.serviciosPostulados;

    if (serviciosDelUsuario.isEmpty && serviciosPostulados.isEmpty) {
      return size.height * 0.8;
    } else if (serviciosDelUsuario.isEmpty || serviciosPostulados.isEmpty) {
      return size.height < 785 ? size.height * 0.55 : size.height * 0.59;
    } else {
      return size.height < 785 ? size.height * 0.35 : size.height * 0.39;
    }
  }

  /// Muestra el panel de los servicios generales con sus respectivas validaciones
  Widget mostrarPanelServiciosGenerales() {
    final size = MediaQuery.of(context).size;
    return SlidingUpPanel(
      maxHeight: size.height * 0.9,
      minHeight: validarTamanioPanel(),
      parallaxEnabled: true,
      parallaxOffset: .5,
      panelBuilder: (sc) {
        return listadoServiciosGenerales();
      },
      borderRadius: BorderRadius.only(
          topLeft: !validarRedondoPanel()
              ? const Radius.circular(18.0)
              : const Radius.circular(0),
          topRight: !validarRedondoPanel()
              ? const Radius.circular(18.0)
              : const Radius.circular(0)),
      onPanelSlide: (double pos) => setState(() {}),
    );
  }

  /// Muestra los servicios postulados con las validaciones para ocultarlo o no sino contiene ningun objeto
  Widget mostrarServiciosPostulados() {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 30, top: 10),
            child: Text(
              "Servicios postulados",
              style: TextStyle(fontSize: size.width * 0.045),
            )),
        SizedBox(
          width: double.infinity,
          height: size.height * 0.17,
          child: listadoServiciosPostulados(),
        )
      ],
    );
  }

  /// Muestra los servicios del usuario con las validaciones para ocultarlo o no, sino contiene ningun objeto
  Widget mostrarServiciosDelUsuario() {
    final size = MediaQuery.of(context).size;

    setState(() {});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 30, top: 10),
            child: Text(
              "Tus servicios",
              style: TextStyle(fontSize: size.width * 0.045),
            )),
        SizedBox(
          width: double.infinity,
          height: size.height * 0.15,
          child: listadoServiciosDelUsuario(),
        ),
      ],
    );
  }

  /// Obtiene el listado de los servicios del usuario del Bloc y los construye en un  Widget (PageView)
  Widget listadoServiciosDelUsuario() {
    final servicios =
        BlocProvider.of<ServicioBloc>(context).state.serviciosDelUsuario;
    setState(() {});
    return PageView.builder(
      controller: controller,
      itemCount: servicios.length,
      itemBuilder: (context, index) {
        return cardTuServicio(servicios[index]);
      },
    );
  }

  /// Obtiene el listado de los servicios postulados del usuario del Bloc y los construye en un  Widget (PageView)
  Widget listadoServiciosPostulados() {
    final servicios =
        BlocProvider.of<ServicioBloc>(context).state.serviciosPostulados;

    return PageView.builder(
      controller: controllerPos,
      itemCount: servicios.length,
      itemBuilder: (context, index) {
        return cardSerPostulados(servicios[index]);
      },
    );
  }

  /// Obtiene el listado de los servicios generales que el usuario puede postularse del Bloc y los construye en un  Widget (PageView)
  Widget listadoServiciosGenerales() {
    final servicios =
        BlocProvider.of<ServicioBloc>(context).state.serviciosGenerales;
    if (servicios.isNotEmpty) {
      return ListView.builder(
        itemCount: servicios.length,
        itemBuilder: (context, index) {
          return cardDeServicio(servicios[index]);
        },
      );
    }
    return sinServicios("No existen servicios generales en el momento");
  }

  Widget sinServicios(String nombre) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Image(
            height: size.height * 0.15,
            image: const AssetImage('img/logo/logo_PaDonde.png')),
        const SizedBox(height: 20),
        Text(
          nombre,
          style: TextStyle(fontSize: size.width * 0.04),
        ),
      ],
    );
  }

  /// Es una card general para construir la información de los servicios del usuario
  Widget cardTuServicio(Servicio servicio) {
    final fecha = servicio.fechayhora.split("T");

    return GestureDetector(
      onTap: () {
        /// Actualiza el servicio con su información para mostrar en la siguiente página
        BlocProvider.of<ServicioBloc>(context)
            .add(OnServicioSeleccionado(servicio));

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetalleTuServicio(callbackFunction: callback)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15, right: 20),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).backgroundColor,
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
                      textoDelServicio(
                          texto: servicio.cantidadCupos -
                              servicio.pasajeros.length),
                    ],
                  ),
                  Row(
                    children: [
                      subTitulosDelServicio(subtitulo: "Pasajeros"),
                      const SizedBox(width: 10),
                      textoDelServicio(texto: servicio.pasajeros.length),
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

  /// Es una card general para construir la información de los servicios generales
  Widget cardDeServicio(Servicio servicio) {
    final fecha = servicio.fechayhora.split("T");
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ServicioBloc>(context)
            .add(OnServicioSeleccionado(servicio));

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetalleServicioPag(callbackFunction: callback)),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).backgroundColor,
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
                        botonDelServicio("Ver mas", servicio),
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

  /// Es una card general para construir la información de los servicios generales
  Widget cardSerPostulados(Servicio servicio) {
    final fecha = servicio.fechayhora.split("T");

    return GestureDetector(
      onTap: () {
        BlocProvider.of<ServicioBloc>(context)
            .add(OnServicioSeleccionado(servicio));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetallePostuladoServicio(
                    callbackFunction: callback,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15, right: 20),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).backgroundColor,
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
                        onPressed: () async {
                          const _storage = FlutterSecureStorage();
                          final token = await _storage.read(key: 'token');
                          SchedulerBinding.instance!.addPostFrameCallback((_) {
                            Navigator.of(context).push(navegarMapaFadeIn(
                                context,
                                ChatPag(
                                    servicio: servicio.uid,
                                    para: "",
                                    nombre: servicio.nombreConductor,
                                    token: token)));
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

  /// Texto general para poder incluir los titulos dentro de la card
  Text tituloDelServicio({titulo}) {
    return Text(titulo,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

  /// SubTexto general para poder incluir los subtitulos dentro de la card
  Widget subTitulosDelServicio({subtitulo}) {
    return Text(subtitulo,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

  /// Texto del servicio
  Widget textoDelServicio({texto}) {
    return Text(texto.toString());
  }

  ///
  Widget botonDelServicio(String nombreBoton, Servicio servicio) {
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
          BlocProvider.of<ServicioBloc>(context)
              .add(OnServicioSeleccionado(servicio));

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetalleServicioPag(callbackFunction: callback)),
          );
        },
      ),
    );
  }
}
