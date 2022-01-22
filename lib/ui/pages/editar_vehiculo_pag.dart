import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/editar_vehiculo_form.dart';

class EditarVehiculo extends StatelessWidget {
  final Vehiculo? vehiculo;
  const EditarVehiculo({Key? key, required this.vehiculo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: ListView(
          children: [
            FormEditarVehiulo(
              vehiculo: vehiculo,
            )
          ],
        ),
      ),
    );
  }

  /// Encabezado de la pagina de registro del usuario (AppBar Modificado)
  // Widget _crearAppBar() {
  //   final size = MediaQuery.of(context).size;
  //   return Container(
  //     height: 80,
  //     color: Theme.of(context).primaryColor,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           Icons.directions_bike,
  //           size: size.width * 0.2,
  //         ),
  //         Text(
  //           "Editar Vehículo",
  //           style: TextStyle(fontSize: size.width * 0.045),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Encabezado de la pagina
  PreferredSizeWidget appBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Editar Vehículo",
          style: TextStyle(
              fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
        ));
  }
}
