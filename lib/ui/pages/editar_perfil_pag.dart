import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/global_widgets/forms/editar_perfil_form.dart';

class EditarPerfilPag extends StatefulWidget {
  final Function? callbackFunction;

  const EditarPerfilPag({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _EditarPerfilPagState createState() =>
      // ignore: no_logic_in_create_state
      _EditarPerfilPagState(callbackFunction);
}

class _EditarPerfilPagState extends State<EditarPerfilPag> {
  final Function? callbackFunction;

  _EditarPerfilPagState(this.callbackFunction);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: body());
  }

  Widget body() {
    return ListView(
      children: [
        const SizedBox(height: 40),
        contenedorImagen(),
        FormEditarPerfil(callbackFunction: callbackFunction)
      ],
    );
  }

  Widget imagen() {
    return const Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: FadeInImage(
          image: NetworkImage(
              'https://media.istockphoto.com/vectors/people-icon-logo-isolated-on-white-background-vector-id1183215612?k=20&m=1183215612&s=170667a&w=0&h=GcHhIXJBau012RiKnc4LjvJC9PDzdELjtPqjdfW3QKk='),
          placeholder: AssetImage('img/gif/cargando.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          height: 300.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget contenedorImagen() {
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
          child: imagen(),
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
          "Editar perfil",
          style: TextStyle(
              fontSize: size.width * 0.055, fontWeight: FontWeight.bold),
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
            "Editar perfil",
            style: TextStyle(fontSize: size.width * 0.06),
          ),
        ],
      ),
    );
  }
}
