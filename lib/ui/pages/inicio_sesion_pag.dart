import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pa_donde_app/ui/global_widgets/forms/inicio_sesion_form.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/registro_usuario_form.dart';
import 'package:pa_donde_app/ui/global_widgets/labels/labels.dart';

class InicioSesionPag extends StatefulWidget {
  @override
  _InicioSesionPagState createState() => _InicioSesionPagState();
}

class _InicioSesionPagState extends State<InicioSesionPag> {
  double tamanioDispostivo = 768;

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
          panelInicioSesion(),
          Stack(
            children: [
              Container(
                  height: 150,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Text("ff")),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: radius,
                    bottomRight: radius,
                  ),
                  color: Colors.white,
                ),
                height: 80,
                width: double.infinity,
              ),
              Positioned(
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
                  child: Icon(
                    Icons.keyboard_arrow_up_outlined,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 202,
                right: 110,
                child: Container(
                  padding: EdgeInsets.only(bottom: 40),
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
              ),
            ],
          ),

          /////////////////////////////////////////////////
          panelRegistro()
        ],
      ),
    );
  }

  Widget panelRegistro() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              child: Text(
                'Crear Cuenta',
                style: TextStyle(
                    fontSize: 30,
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

  Widget panelInicioSesion() {
    final size = MediaQuery.of(context).size;
    return Container(
        height: 500,
        padding: EdgeInsets.symmetric(horizontal: 40),
        color: Colors.white,
        child: Column(
          children: [
            Image(
                height: size.height * 0.23,
                image: AssetImage('img/logo/logo_PaDonde.png')),
            const SizedBox(height: 20),
            const FormInicioSesion(),
            // const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                print("hola");
                Navigator.pushReplacementNamed(context, "recuperarContrasenia");
              },
              child: const Text(
                "¿Olvido su contraseña?",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ));
  }
}
