import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/global/enums/tipo_vehiculo_enum.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/card_vehiculo_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/cargando_widget.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/agregar_vehiculo_pag.dart';
import 'package:pa_donde_app/ui/pages/editar_vehiculo_pag.dart';
import 'package:pa_donde_app/data/services/vehiculo_servicio.dart';
//---------------------------------------------------------------------

class VehiculoPag extends StatefulWidget {
  const VehiculoPag({Key? key}) : super(key: key);

  @override
  _VehiculoPagState createState() => _VehiculoPagState();
}

class _VehiculoPagState extends State<VehiculoPag> {
  List<Vehiculo> vehiculos = [];
  var vehiculoServicio = VehiculoServicio();
  bool cargar = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getVehiculos();
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          panelSuperior(),
          (cargar)
              ? Cargando(
                  size: size,
                )
              : Column(
                  children: [
                    Table(children: funcionPrueba()),
                    const SizedBox(height: 20),
                    Container(
                      width: size.width * 1,
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.2),
                      child: BtnAnaranja(
                        function: () {
                          SchedulerBinding.instance!.addPostFrameCallback((_) {
                            Navigator.of(context).push(navegarMapaFadeIn(
                                context, const AgregarVehiculo()));
                          });
                        },
                        titulo: "Agregar Vehículo",
                      ),
                    )
                  ],
                )
        ]),
      ),
    );
  }

  /// Panel superior verde (Titulo de la pagina)
  Widget panelSuperior() {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      height: 120,
      child: Column(
        children: [
          Icon(
            Icons.directions_car_filled_outlined,
            size: size.height * 0.1,
          ),
          Text(
            "Mis Vehiculos",
            style: TextStyle(fontSize: size.width * 0.06),
          ),
        ],
      ),
    );
  }

  /// Construcción de cada TableRow con sus dos parejas de cards de Vehiculos.
  List<TableRow> funcionPrueba() {
    int count = 0;
    List<TableRow> arreglo = [];
    List<Widget> arreglo2 = [];

    for (int i = 0; i < vehiculos.length; i++) {
      arreglo2.add(GestureDetector(
        onTap: () {
          Navigator.of(context).push(navegarMapaFadeIn(
              context,
              EditarVehiculo(
                vehiculo: vehiculos[i],
              )));

          // Navigator.pushNamed(context, 'editarVehiculo', arguments: vehiculos[i]);
        },
        child: CardVehiculo(
            icon: (vehiculos[i].tipoVehiculo == TipoVehiculo.carro)
                ? Icons.car_rental
                : Icons.motorcycle_rounded,
            color: Colors.black,
            placa: vehiculos[i].placa,
            marca: vehiculos[i].marca,
            validar: true),
      ));
      count++;
      if (count == 2) {
        arreglo.add(TableRow(children: arreglo2));
        count = 0;
        arreglo2 = [];
      }
    }
    if (arreglo2.isNotEmpty) {
      arreglo2.add(const CardVehiculo(
          color: Colors.black, placa: "", marca: "", validar: false));
      arreglo.add(TableRow(children: arreglo2));
    }
    return arreglo;
  }

  getVehiculos() async {
    vehiculos = BlocProvider.of<PreserviciosBloc>(context).vehiculos!;
  }
}
