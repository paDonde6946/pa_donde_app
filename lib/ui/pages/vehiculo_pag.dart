import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/global/enums/tipo_vehiculo_enum.dart';

import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/informativo_show.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/validacion_show.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/card_vehiculo_widget.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/cargando_widget.dart';

import 'package:pa_donde_app/ui/pages/agregar_vehiculo_pag.dart';
import 'package:pa_donde_app/ui/pages/editar_vehiculo_pag.dart';

import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/services/vehiculo_servicio.dart';

import 'package:pa_donde_app/ui/helpers/helpers.dart';

import 'package:pa_donde_app/ui/utils/snack_bars.dart';

import 'package:pa_donde_app/data/models/usuario_modelo.dart';
//---------------------------------------------------------------------

class VehiculoPag extends StatefulWidget {
  const VehiculoPag({Key? key}) : super(key: key);

  @override
  _VehiculoPagState createState() => _VehiculoPagState();
}

class _VehiculoPagState extends State<VehiculoPag> {
  List<Vehiculo> vehiculos = [];
  Usuario usuario = Usuario();
  var vehiculoServicio = VehiculoServicio();
  bool cargar = false;
  // ignore: prefer_typing_uninitialized_variables
  var imageFile;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    /// Obtener informacion de usuario y vehiculos de la  BD
    usuario = BlocProvider.of<UsuarioBloc>(context).state.usuario;
    vehiculos = BlocProvider.of<PreserviciosBloc>(context).vehiculos!;

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
                  vehiculos.isNotEmpty
                      ? Table(children: funcionPrueba())
                      : sinVehiculos('No tiene vehículos en este momento.'),
                  const SizedBox(height: 20),
                  Container(
                    width: size.width * 1,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: usuario.licenciaConduccion == null
                        ? agregarLicencia()
                        : agregarVehiculo(),
                  )
                ],
              )
      ]),
    );
  }

  Widget agregarVehiculo() {
    return BtnAnaranja(
      function: () {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context)
              .push(navegarMapaFadeIn(context, const AgregarVehiculo()));
        });
      },
      titulo: "Agregar Vehículo",
    );
  }

  Widget agregarLicencia() {
    return BtnAnaranja(
      function: () => mostrarShowDialogValidar(
          context: context,
          titulo: 'Licencia de conducción',
          contenido:
              "Debe de subir su licencia de conducción para poder agregar un vehículo.",
          funtionContinuar: () {
            Navigator.of(context, rootNavigator: true).pop(context);
            _showSelectionDialog(context);
          },
          icono: Icons.image_rounded),
      titulo: "Agregar Licencia de Conducción",
    );
  }

  _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                "¿De dónde quiere seleccionar la foto?",
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.collections),
                          SizedBox(width: 20),
                          Text("Galeria"),
                        ],
                      ),
                      onTap: () {
                        _abrirGaleria(context);
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(width: 20),
                          Text("Camara"),
                        ],
                      ),
                      onTap: () {
                        _abrirCamara(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _abrirGaleria(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context, rootNavigator: true).pop(context);

    validarLicenciaConduccion();
  }

  void _abrirCamara(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context, rootNavigator: true).pop(context);

    validarLicenciaConduccion();
  }

  validarLicenciaConduccion() async {
    if (imageFile == null) {
      customShapeSnackBar(
          context: context, titulo: "No ha elegido ninguna imagen");
    } else {
      final cargue =
          await VehiculoServicio().cargarLicenciaConduccion(imageFile);
      // ignore: unnecessary_null_comparison
      if (cargue != null) {
        mostrarShowDialogInformativo(
            context: context,
            titulo: "Lincencia de conducción",
            contenido: "La imagen seleccionada ha sido subida exitosamente");
        usuario.licenciaConduccion = "";
        setState(() {});
      } else {
        customShapeSnackBar(
            context: context, titulo: "No se ha podido subir la imagen");
      }
    }
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

  /// Muestra una imagen cuando no tiene ningun vehiculo registrado
  Widget sinVehiculos(String nombre) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          nombre,
          style: TextStyle(fontSize: size.width * 0.04),
        ),
        const SizedBox(height: 20),
        Image(
            height: size.height * 0.15,
            image: const AssetImage('img/logo/logo_PaDonde.png')),
        const SizedBox(height: 50),
      ],
    );
  }
}
