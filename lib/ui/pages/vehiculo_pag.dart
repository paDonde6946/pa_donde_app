import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/pages/card_table.dart';

class VehiculoPag extends StatefulWidget {
  const VehiculoPag({Key? key}) : super(key: key);

  @override
  _VehiculoPagState createState() => _VehiculoPagState();
}

class _VehiculoPagState extends State<VehiculoPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          panelSuperior(),
          CardTable(),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: BtnAnaranja(
              titulo: "AGREGAR VEHICULO",
            ),
          )
        ]),
      ),
    );
  }

  Widget panelSuperior() {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 150,
      child: Column(
        children: [
          Icon(
            Icons.directions_car_filled_outlined,
            size: 100,
          ),
          Text(
            "Mis Vehiculos",
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
