import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
//---------------------------------------------------------------------

class AgregarServicioParte3 extends StatefulWidget {
  const AgregarServicioParte3({Key? key}) : super(key: key);

  @override
  State<AgregarServicioParte3> createState() => _AgregarServicioParte3State();
}

class _AgregarServicioParte3State extends State<AgregarServicioParte3> {
  final keyForm = GlobalKey<FormState>();
  final keySnackbar = GlobalKey<ScaffoldState>();

  List<String> precios = [
    '\$ 0',
    '\$ 2.000',
    '\$ 3.000',
    '\$ 4.000',
  ];
  Servicio servicio = Servicio();
  bool color = false;
  int seleccion = 0;
  final styleInput = const TextStyle(height: 0.4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios_sharp)),
              const Text("Seleccion un precio para el servicio"),
              Container(width: 30)
            ],
          ),
          listadoPrecios(),
          const SizedBox(height: 5),
          const BtnAnaranja(
            titulo: 'Finalizar',
          )
        ],
      ),
    );
  }

  Widget listadoPrecios() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [cardPrecio(precios[0], 0), cardPrecio(precios[1], 1)],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [cardPrecio(precios[2], 2), cardPrecio(precios[3], 3)],
        )
      ],
    );
  }

  Widget cardPrecio(String nombre, int posicion) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        seleccion = posicion;
        setState(() {});
      },
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(child: Text(nombre)),
          height: size.height * 0.05,
          width: size.width * 0.3,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: seleccion == posicion
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  offset: const Offset(1.0, 1.0), //(x,y)
                  blurRadius: 9.0,
                ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}
