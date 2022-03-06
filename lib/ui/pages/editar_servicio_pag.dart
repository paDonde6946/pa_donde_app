import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/editar_servicio_form.dart';

class EditarServicioPag extends StatefulWidget {
  final Function? callbackFunction;
  const EditarServicioPag({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  State<EditarServicioPag> createState() =>
      // ignore: no_logic_in_create_state
      _EditarServicioPagState(callbackFunction);
}

class _EditarServicioPagState extends State<EditarServicioPag> {
  final Function? callbackFunction;

  _EditarServicioPagState(this.callbackFunction);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        children: [
          const SizedBox(height: 40),
          contenedorImagen(),
          EditarServicioForm(
            callbackFunction: callbackFunction,
          ),
        ],
      ),
    );
  }

  Widget contenedorImagen() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                blurRadius: 40.0,
                color: Colors.black26,
                offset: Offset(30.0, 5.0),
                spreadRadius: 20.0,
              ),
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Icon(
            Icons.map_outlined,
            size: size.width * 0.3,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  /// Encabezado de la pagina
  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;
    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Editar Servicio",
          style: TextStyle(
              fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
        ));
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
            "Editar Perfil",
            style: TextStyle(fontSize: size.width * 0.06),
          ),
        ],
      ),
    );
  }
}
