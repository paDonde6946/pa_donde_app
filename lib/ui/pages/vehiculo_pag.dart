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
      appBar: appBar(),
      body: ListView(children: [
        // panelSuperior(),
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
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
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
    );
  }

  /// AppBar personalizado que se muestra en la parte superior de la pantalla
  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;

    return AppBar(
      toolbarHeight: 90,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              image: const AssetImage("img/icons/camioneta_icon.png"),
              width: size.width * 0.25),
          Text(
            "Mis vehículos",
            style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
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
                ? "img/icons/carro_icon.png"
                : "img/icons/moto_icon.png",
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
