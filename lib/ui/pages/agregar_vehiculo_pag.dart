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
          children: [appBar(context), const FormAgregarVehiulo()],
        ),
      ),
    );
  }

  /// Encabezado de la pagina de registro del usuario (AppBar Modificado)
  PreferredSizeWidget appBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Agregar Vehículo",
          style: TextStyle(
              fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
        ));
  }
}
