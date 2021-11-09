import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/agregar_vehiculo_form.dart';

class AgregarVehiculo extends StatefulWidget {
  const AgregarVehiculo({Key? key}) : super(key: key);

  @override
  _AgregarVehiculoState createState() => _AgregarVehiculoState();
}

class _AgregarVehiculoState extends State<AgregarVehiculo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [_crearAppBar(), const FormAgregarVehiulo()],
        ),
      ),
    );
  }

  /// Encabezado de la pagina de registro del usuario (AppBar Modificado)
  Widget _crearAppBar() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 80,
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.directions_bike,
            size: size.width * 0.2,
          ),
          Text(
            "AGREGAR VEHICULO",
            style: TextStyle(fontSize: size.width * 0.045),
          ),
        ],
      ),
    );
  }
}
