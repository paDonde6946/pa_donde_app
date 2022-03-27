import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:http/http.dart' as http;

import 'package:mime_type/mime_type.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';
import 'package:pa_donde_app/global/enums/tipo_vehiculo_enum.dart';
import 'package:pa_donde_app/ui/global_widgets/button/boton_anaranja.dart';
import 'package:pa_donde_app/ui/global_widgets/show_dialogs/calificar_show.dart';
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
  var imageFile;

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
      floatingActionButton:
          FloatingActionButton(onPressed: () => _showSelectionDialog(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                "De donde quiere seleccionar la foto?",
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
                        _openGallery(context);
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
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
      print(imageFile);
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);

    imageFile = picture;

    String fileName = imageFile.path.split("/").last;

    // FormData formData = FormData.fromMap({
    //   'file': await MultipartFile.fromFile(imageFile!.path, filename: fileName)
    // });

    // Dio dio = Dio();

    // // URL para crear el prestador de servicios - conexion
    // final url = Uri.http(EntornoVariable.host, '/cargarLicenciaConduccion');

    // final response = await dio.post(
    //     '${EntornoVariable.host}/cargarLicenciaConduccion',
    //     data: formData);

    // File file = File(imageFile.path);
    // file.path;
    // print(imageFile);

    /// Create storage que permite almacenar el token en el dispositivo fisico
    final _storage = const FlutterSecureStorage();

    String? token = await _storage.read(key: 'token');

    final url = Uri.http(EntornoVariable.host, "/app/cargarLicenciaConduccion");

    // final mimeType = mime(imageFile!.path).split('/').last; // image/jpeg

    final imageUplodReques = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imageFile.path);

    imageUplodReques.fields['jwt'] = token;
    imageUplodReques.fields['tipoDocumento'] = '1';

    imageUplodReques.files.add(file);

    final streamResponse = await imageUplodReques.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
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
              image: const AssetImage("img/icons/carro_icon.png"),
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

  /// Panel superior verde (Titulo de la pagina)
  Widget panelSuperior() {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      height: 100,
      child: Column(
        children: [
          // Icon(
          //   Icons.directions_car_filled_outlined,
          //   size: size.height * 0.1,
          // ),
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
