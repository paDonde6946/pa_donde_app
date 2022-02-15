import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pa_donde_app/ui/pages/editar_contrasenia_pag.dart';
import 'package:provider/provider.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/usuario_modelo.dart';

import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';

import 'package:pa_donde_app/ui/helpers/helpers.dart';

import 'package:pa_donde_app/ui/pages/editar_perfil_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_sesion_pag.dart';
//---------------------------------------------------------------------

class PerfilPag extends StatefulWidget {
  const PerfilPag({Key? key}) : super(key: key);

  @override
  _PerfilPagState createState() => _PerfilPagState();
}

class _PerfilPagState extends State<PerfilPag> {
  @override
  Widget build(BuildContext context) {
    Usuario usuarioServicio =
        Provider.of<AutenticacionServicio>(context).usuarioServiciosActual;
    return Scaffold(
      body: ListView(children: [
        Stack(
          children: [fondo(), informacion(usuarioServicio)],
        ),
      ]),
    );
  }

  Widget fondo() {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height * 0.3,
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
        const SizedBox(height: 30),
        encabezado(),
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
              titulo: "Editar Perfil",
              function: () {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                      navegarMapaFadeIn(context, const EditarPerfilPag()));
                });
              },
            ),
            BtnAnaranja(
              titulo: "Editar Contraseña",
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
        informacionTextoTitulo("CORREO", Icons.mail),
        const SizedBox(height: 10),
        informacionTextoSubTitulo(usuarioServicio.correo),
        const SizedBox(height: 10),
        informacionTextoTitulo("CELULAR", Icons.phone),
        const SizedBox(height: 10),
        informacionTextoSubTitulo(usuarioServicio.celular.toString()),
        const SizedBox(height: 10),
        informacionTextoTitulo("PUNTUACIÓN", Icons.star),
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
                  child: cuadroEstrella('4.8')
                  )
              ],
            ),
            Column(
              children: [
                informacionTextoPuntuacion('Conductor'),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: cuadroEstrella('5.0')
                  )
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
        IconButton(onPressed: () {}, icon: const Icon(null, size: null)),
        Text(
          "Perfil",
          style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.08,
              fontWeight: FontWeight.w600),
        ),
        IconButton(
            onPressed: () async {
              mostrarShowDialogCargando(
                  context: context, titulo: 'CERRANDO SESIÓN');
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InicioSesionPag()));
              AutenticacionServicio.eliminarToken();
            },
            icon: Icon(Icons.login, size: size.width * 0.075)),
      ],
    );
  }

  Widget imagen() {
    return const Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: FadeInImage(
          image: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/User.svg/768px-User.svg.png'),
          placeholder: AssetImage('img/gif/cargando.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          height: 300.0,
          fit: BoxFit.cover,
        ),
      ),
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
              blurRadius: 40.0,
              color: Colors.black26,
              offset: Offset(30.0, 5.0),
              spreadRadius: 20.0,
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
