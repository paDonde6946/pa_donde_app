import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/global_widgets/forms/inicio_sesion_form.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/registro_usuario_form.dart';
//---------------------------------------------------------------------

class InicioSesionPag extends StatefulWidget {
  InicioSesionPag({Key? key}) : super(key: key);

  @override
  _InicioSesionPagState createState() => _InicioSesionPagState();
}

class _InicioSesionPagState extends State<InicioSesionPag> {
  String email = "";
  String contrasenia = "";

  final radius = const Radius.circular(40);
  final radiusAll = const Radius.circular(100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 10),
          // PANEL INICIAR SESIÓN
          panelInicioSesion(),
          // PANEL CENTRAL DE LA PANTALLA
          Stack(
            children: [
              contenedorVerde(),
              contenedorBlanco(),
              semicirculoSuperior(),
              semicirculoInferior()
            ],
          ),
          // PANEL REGISTRO
          panelRegistro()
        ],
      ),
    );
  }

  /// Es el panel inferiror este contiene la siguiente información:
  /// Contiene un formulario de los datos basicos para el registro del usuario
  Widget panelRegistro() {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width * 0.35,
              child: Text(
                'Crear Cuenta',
                style: TextStyle(
                    fontSize: size.height * 0.038,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const FormRegistroUsuario(),
          ],
        ),
      ),
    );
  }

  /// Es el panel superior este contiene la siguiente información:
  /// Logo-Inputs(correo,contraseña)-Boton Inicio Sesion- Boton olvido contraseña
  Widget panelInicioSesion() {
    final size = MediaQuery.of(context).size;
    final tamanioSeparacion = size.height * 0.02;
    return Container(
        height: size.height * 0.63,
        color: Colors.white,
        child: Column(
          children: [
            Image(
                height: size.height * 0.23,
                image: const AssetImage('img/logo/logo_PaDonde.png')),
            SizedBox(height: tamanioSeparacion),
            const FormInicioSesion(),
            SizedBox(height: tamanioSeparacion),
            botonOlvidarContrasenia()
          ],
        ));
  }

  /// Widget para la creación del boton olvidar contraseña
  Widget botonOlvidarContrasenia() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "recuperarContrasenia");
      },
      child: const Text(
        "¿Olvido su contraseña?",
        style: TextStyle(
            color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
      ),
    );
  }

  /// Widget para UI de la pantalla, semicirculo verde
  Widget semicirculoSuperior() {
    return Positioned(
      bottom: 70,
      left: 100,
      right: 210,
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: radiusAll,
            topRight: radiusAll,
          ),
          color: Theme.of(context).primaryColor,
        ),
        child: const Icon(
          Icons.keyboard_arrow_up_outlined,
          size: 70,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Widget para UI de la pantalla, semicirculo blanco
  Widget semicirculoInferior() {
    return Positioned(
      bottom: 20,
      left: 202,
      right: 110,
      child: Container(
        padding: const EdgeInsets.only(bottom: 40),
        height: 70,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: radiusAll,
            bottomRight: radiusAll,
          ),
          color: Colors.white,
        ),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  /// Contenedor, para el fondo de pantalla del centro - Color verde
  Widget contenedorVerde() {
    return Container(
      height: 150,
      width: double.infinity,
      // Color Verde
      color: Theme.of(context).primaryColor,
    );
  }

  /// Contenedor, para el fondo de pantalla del centro -
  /// Color Blanco con bordes redondos
  Widget contenedorBlanco() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: radius,
          bottomRight: radius,
        ),
        color: Colors.white,
      ),
      height: 80,
      width: double.infinity,
    );
  }
}
