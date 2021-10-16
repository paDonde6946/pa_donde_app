import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/cargando_show.dart';
import 'package:pa_donde_app/ui/pages/inicio_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_sesion_pag.dart';
import 'package:provider/provider.dart';

class PerfilPag extends StatefulWidget {
  PerfilPag({Key? key}) : super(key: key);

  @override
  _PerfilPagState createState() => _PerfilPagState();
}

class _PerfilPagState extends State<PerfilPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Stack(
          children: [fondo(), informacion()],
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

  Widget informacion() {
    final size = MediaQuery.of(context).size;
    final usuarioServicio =
        Provider.of<AutenticacionServicio>(context).usuarioServiciosActual;

    return Column(
      children: [
        const SizedBox(height: 30),
        encabezado(),
        const SizedBox(height: 30),
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
        BtnAnaranja(
          titulo: "Editar Perfil",
          function: () {
            Navigator.pushNamed(context, 'editarPerfil');
          },
        ),
        const SizedBox(height: 30),
        informacionTextoTitulo("CORREO", Icons.mail),
        const SizedBox(height: 10),
        informacionTextoSubTitulo(usuarioServicio.correo),
        const SizedBox(height: 20),
        informacionTextoTitulo("CELULAR", Icons.phone),
        const SizedBox(height: 10),
        informacionTextoSubTitulo(usuarioServicio.celular.toString()),
      ],
    );
  }

  Widget encabezado() {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back, size: size.width * 0.06)),
        Text(
          "PERFIL",
          style: TextStyle(
              color: Colors.white,
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
    return Center(
      child: Container(
        height: 200,
        width: 200,
        child: FadeInImage(
          image: NetworkImage(
              'https://cdn.pixabay.com/photo/2018/05/02/08/44/pkw-3367993_1280.jpg'),
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
      margin: EdgeInsets.symmetric(horizontal: 106),
      width: 195,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[
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
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icono),
          SizedBox(width: 10),
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
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(left: 30),
      child: Text(
        titulo,
        style: TextStyle(
          color: Colors.black54,
          fontSize: size.width * 0.05,
        ),
      ),
    );
  }
}
