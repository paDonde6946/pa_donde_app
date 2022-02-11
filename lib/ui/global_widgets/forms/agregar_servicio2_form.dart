import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/response/pre_agregar_servicio_response.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
//---------------------------------------------------------------------

class AgregarServicioParte2 extends StatefulWidget {
  const AgregarServicioParte2({Key? key}) : super(key: key);

  @override
  State<AgregarServicioParte2> createState() => _AgregarServicioParte2State();
}

class _AgregarServicioParte2State extends State<AgregarServicioParte2> {
  List<Vehiculo> vehiculos = [
    Vehiculo(pPlaca: "JVR342", pMarca: "RENAULT"),
    Vehiculo(pPlaca: "LHK864", pMarca: "HYUNDAI"),
    Vehiculo(pPlaca: "WQF298", pMarca: "FORD"),
    // Vehiculo(pPlaca: "UYV469", pMarca: "MERCEDEZ"),
  ];

  PreAgregarServicioResponse pre = PreAgregarServicioResponse();

  Servicio servicio = Servicio();

  int seleccion = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Stack(
          children: [
            listadoCarros(),
            titulo(),
          ],
        ));
  }

  /// Metodo para crear el titulo del form y los botones superiores
  Widget titulo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              BlocProvider.of<PreserviciosBloc>(context)
                  .controller!
                  .jumpToPage(1);
            },
            icon: const Icon(Icons.arrow_back_ios_sharp)),
        const Text("Seleccion su automovil"),
        IconButton(
            onPressed: () {
              final blocPaginar = BlocProvider.of<PreserviciosBloc>(context);
              blocPaginar.controller!.jumpToPage(3);
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded)),
      ],
    );
  }

  Widget _cardCarro(String nombre, int posicion) {
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
          // margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.1,
                child: Icon(Icons.drive_eta_outlined, size: size.width * 0.10),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30),
                width: size.width * 0.6,
                child: Text(nombre),
              ),
            ],
          ),
          height: size.height * 0.05,
          width: size.width * 0.9,
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

  Widget listadoCarros() {
    return BlocBuilder<PreserviciosBloc, PreserviciosState>(
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: snapshot.vehiculos.length,
            itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _cardCarro(vehiculos[i].placa, i),
                ));
      },
    );
  }
}