import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/global/enums/tipo_vehiculo_enum.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';
//---------------------------------------------------------------------

class AgregarServicioParte2 extends StatefulWidget {
  const AgregarServicioParte2({Key? key}) : super(key: key);

  @override
  State<AgregarServicioParte2> createState() => _AgregarServicioParte2State();
}

class _AgregarServicioParte2State extends State<AgregarServicioParte2> {
  int seleccion = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    validarContieneDatos();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Stack(
        children: [
          listadoCarros(),
          titulo(),
        ],
      ),
    );
  }

  /// Metodo para crear el titulo del form y los botones superiores
  Widget titulo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              final servicioBloc = BlocProvider.of<PreserviciosBloc>(context);
              servicioBloc.controller!.jumpToPage(1);
            },
            icon: const Icon(Icons.arrow_back_ios_sharp)),
        const Text("Seleccione su automóvil"),
        IconButton(
            onPressed: () {
              final servicioBloc = BlocProvider.of<PreserviciosBloc>(context);
              if (seleccion >= 0) {
                servicioBloc.servicio!.idVehiculo =
                    IdVehiculo(uid: servicioBloc.vehiculos![seleccion].uid);
                servicioBloc.add(OnCrearServicio(servicioBloc.servicio!));
                servicioBloc.controller!.jumpToPage(3);
              } else {
                mostrarShowDialogInformativo(
                    context: context,
                    titulo: 'Vehículo',
                    contenido: 'Debe de seleccionar un vehículo');
              }
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded)),
      ],
    );
  }

  /// Valida si ya se habia seleccionado un vehiculo anteriormente
  void validarContieneDatos() {
    final servicioBloc = BlocProvider.of<PreserviciosBloc>(context);

    if (servicioBloc.servicio!.idVehiculo != null) {
      int aux = 0;
      for (var vehiculo in servicioBloc.vehiculos!) {
        if (vehiculo.uid == servicioBloc.servicio!.idVehiculo.uid)
          seleccion = aux;
        aux++;
      }
    }
  }

  ///  Valida la placa del vehiculo que va a prestar el servicio con una lista que se encuentra preCargada en el Bloc
  Vehiculo _validarVehiculoServicioV(String placa) {
    final vehiculos =
        BlocProvider.of<PreserviciosBloc>(context).state.vehiculos;

    for (var vehiculo in vehiculos) {
      if (vehiculo.placa == placa) {
        return vehiculo;
      }
    }
    return Vehiculo();
  }

  Widget validarImagen(String placa) {
    final vehiculo = _validarVehiculoServicioV(placa);
    final asset = (vehiculo.tipoVehiculo == TipoVehiculo.carro)
        ? "img/icons/carro_icon.png"
        : "img/icons/moto_icon.png";

    return Image(
      image: AssetImage(asset),
      width: 75,
    );
  }

  /// Se crea la card general para poder mostrar los datos especificos de un carro
  Widget _cardCarro(String nombre, int posicion) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        seleccion = posicion;
        setState(() {});
      },
      child: Material(
        elevation: 3,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: size.width * 0.1, child: validarImagen(nombre)),
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

  /// Crea el listado de los carros del usuario
  Widget listadoCarros() {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: size.height * 0.03),
      child: BlocBuilder<PreserviciosBloc, PreserviciosState>(
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.vehiculos.length,
              itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: _cardCarro(
                        BlocProvider.of<PreserviciosBloc>(context)
                            .state
                            .vehiculos[i]
                            .placa,
                        i),
                  ));
        },
      ),
    );
  }
}
