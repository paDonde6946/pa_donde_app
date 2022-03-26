import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';

import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/confirmacion_show.dart';

import 'package:pa_donde_app/blocs/blocs.dart';

import 'package:pa_donde_app/ui/helpers/helpers.dart';

import 'package:pa_donde_app/ui/pages/editar_contrasenia_pag.dart';
import 'package:pa_donde_app/ui/pages/historial_pag.dart';
import 'package:pa_donde_app/ui/pages/editar_perfil_pag.dart';
import 'package:pa_donde_app/ui/pages/principal_pag.dart';
//---------------------------------------------------------------------

class PerfilPag extends StatefulWidget {
  const PerfilPag({Key? key}) : super(key: key);

  @override
  _PerfilPagState createState() => _PerfilPagState();
}

class _PerfilPagState extends State<PerfilPag> {
  callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuarioServicio =
        BlocProvider.of<UsuarioBloc>(context).state.usuario;

    return Scaffold(
      appBar: appBar(),
      body: ListView(children: [
        Stack(
          children: [fondo(), informacion(usuarioServicio)],
        ),
      ]),
    );
  }

  /// AppBar personalizado que se muestra en la parte superior de la pantalla
  PreferredSizeWidget appBar() {
    return AppBar(
      elevation: 0,
      title: encabezado(),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget fondo() {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height * 0.25,
          color: Theme.of(context).primaryColor,
        ),
        Container(
          color: Colors.white,
        ),
      ],
    );
  }

  Widget informacion(Usuario usuarioServicio) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // const SizedBox(height: 10),
        // encabezado(),
        const SizedBox(height: 20),
        contenedorImagen(),
        const SizedBox(height: 10),
        Text(
          "${usuarioServicio.nombre}  ${usuarioServicio.apellido}",
          style: TextStyle(
              color: Colors.black54,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BtnAnaranja(
              titulo: "Editar perfil",
              function: () {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Navigator.of(context).push(navegarMapaFadeIn(
                      context,
                      EditarPerfilPag(
                        callbackFunction: callback,
                      )));
                });
              },
            ),
            BtnAnaranja(
              titulo: "Editar contraseña",
              function: () {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                      navegarMapaFadeIn(context, const EditarContraseniaPag()));
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        informacionTextoTitulo("Correo", Icons.mail),
        const SizedBox(height: 10),
        informacionTextoSubTitulo(usuarioServicio.correo),
        const SizedBox(height: 10),
        informacionTextoTitulo("Celular", Icons.phone),
        const SizedBox(height: 10),
        informacionTextoSubTitulo(usuarioServicio.celular.toString()),
        const SizedBox(height: 10),
        informacionTextoTitulo("Puntuación", Icons.star),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                informacionTextoPuntuacion('Usuario'),
                const SizedBox(height: 5),
                Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: cuadroEstrella(
                        usuarioServicio.calificacionUsuario.toString()))
              ],
            ),
            Column(
              children: [
                informacionTextoPuntuacion('Conductor'),
                const SizedBox(height: 5),
                Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: cuadroEstrella(
                        usuarioServicio.calificacionConductor.toString()))
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget encabezado() {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistorialPag()));
            },
            icon: Icon(Icons.watch_later_outlined,
                color: Colors.black, size: size.width * 0.075)),
        IconButton(
            onPressed: () async {
              mostrarShowDialogCargando(
                  context: context, titulo: 'CERRANDO SESIÓN');
              await Future.delayed(const Duration(seconds: 1));
              BlocProvider.of<PaginasBloc>(context)
                  .add(const OnCambiarPaginaPrincipal(PrincipalPag(), 0));

              mostrarShowDialogConfirmar(
                  context: context,
                  titulo: "CONFIRMACIÓN",
                  contenido: 'Usted ha cerrado sesión correctamente',
                  paginaRetorno: 'login');
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const InicioSesionPag()));
              AutenticacionServicio.eliminarToken();
            },
            icon: Icon(Icons.login,
                color: Colors.black, size: size.width * 0.075)),
      ],
    );
  }

  Widget imagen() {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      height: 200,
      width: 200,
      child: const Image(image: AssetImage("img/icons/usuario_icon.png")),
    );
  }

  Widget contenedorImagen() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 106),
      width: 195,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 5.0,
              color: Colors.black26,
              offset: Offset(0, 10),
              spreadRadius: 1.0,
            ),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: imagen(),
      ),
    );
  }

  Widget informacionTextoTitulo(String titulo, IconData icono) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icono),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget informacionTextoSubTitulo(String titulo) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(left: 30),
      child: Text(
        titulo,
        style: TextStyle(
          color: Colors.black54,
          fontSize: size.width * 0.05,
        ),
      ),
    );
  }

  Widget informacionTextoPuntuacion(String titulo) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        titulo,
        style: TextStyle(
          color: Colors.black54,
          fontSize: size.width * 0.05,
        ),
      ),
    );
  }

  /// Puntuacion recibida y dada del servicio
  Widget cuadroEstrella(String calificacion) {
    final media = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          calificacion,
          style: TextStyle(
              // fontFamily: Tipografia.medium,
              fontSize: media.height * 0.03,
              color: Colors.grey),
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: media.width * 0.06,
          // onPressed: () {},
        ),
      ],
    );
  }
}
