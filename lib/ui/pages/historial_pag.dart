import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';

import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/models/vehiculo_modelo.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:pa_donde_app/global/enums/tipo_vehiculo_enum.dart';

import 'package:pa_donde_app/ui/global_widgets/widgets/cargando_widget.dart';
import 'package:pa_donde_app/ui/pages/detalle_historial_pag.dart';
//---------------------------------------------------------------------

class HistorialPag extends StatefulWidget {
  const HistorialPag({Key? key}) : super(key: key);

  @override
  _HistorialPagState createState() => _HistorialPagState();
}

class _HistorialPagState extends State<HistorialPag> {
  List<Servicio>? usuarioHistorial = [];
  List<Servicio>? conductorHistorial = [];
  @override
  Widget build(BuildContext context) {
    getHistorial(context);
    // setState(() {});
    final media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(),
        body: (usuarioHistorial == null || conductorHistorial == null)
            ? Cargando(size: media)
            : _tabSection());
  }

  PreferredSizeWidget appBar() {
    final size = MediaQuery.of(context).size;

    return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Historial",
          style: TextStyle(
              fontSize: size.width * 0.055, fontWeight: FontWeight.bold),
        ));
  }

  Widget subTitulosDelServicio({subtitulo}) {
    return Text(subtitulo,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

  Widget textoDelServicio({texto}) {
    return Text(texto);
  }

  /// Puntuacion recibida y dada del servicio
  Widget cuadroEstrella(String calificacion) {
    final media = MediaQuery.of(context).size;
    return Row(
      children: [
        Text(
          calificacion,
          style: TextStyle(fontSize: media.height * 0.02, color: Colors.black),
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: media.width * 0.04,
        ),
      ],
    );
  }

  getHistorial(context) async {
    usuarioHistorial =
        BlocProvider.of<ServicioBloc>(context).state.historialComoUsuario;
    conductorHistorial =
        BlocProvider.of<ServicioBloc>(context).state.historialComoConductor;

    if (usuarioHistorial == null || conductorHistorial == null) {
      ServicioRServicio servicioServicio = ServicioRServicio();
      var response = await servicioServicio.getHistorial();
      usuarioHistorial = response.serviciosComoUsuario;
      conductorHistorial = response.serviciosComoConductor;
      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarHistorialUsuario(usuarioHistorial));
      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarHistorialConductor(conductorHistorial));
    }
    setState(() {});
  }

  Widget _tabSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          TabBar(
              unselectedLabelColor: Theme.of(context).primaryColorLight,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColorLight),
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                const Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Usuario"),
                  ),
                ),
                const Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Conductor"),
                  ),
                ),
              ]),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.69,
            child: TabBarView(children: <Widget>[
              panelHistorialUsuario(),
              panelHistorialConductor()
            ]),
          ),
        ],
      ),
    );
  }

  Widget panelHistorialUsuario() {
    if (usuarioHistorial!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: usuarioHistorial!.length,
        itemBuilder: (context, i) =>
            cardDeServicioConductor(usuarioHistorial![i]),
      );
    }
    return sinServicios("No posee servicios como usuario");
  }

  Widget panelHistorialConductor() {
    if (conductorHistorial!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: conductorHistorial!.length,
        itemBuilder: (context, i) =>
            cardDeServicioConductor(conductorHistorial![i]),
      );
    }
    return sinServicios("No posee servicios como conductor");
  }

  Widget sinServicios(String nombre) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
            height: size.height * 0.23,
            image: const AssetImage('img/logo/logo_PaDonde.png')),
        const SizedBox(
          height: 40,
        ),
        Text(
          nombre,
          style: TextStyle(fontSize: size.width * 0.045),
        ),
      ],
    );
  }

  Widget cardDeServicioUsuario(Servicio servicio) {
    final size = MediaQuery.of(context).size;
    // final placa = _validarVehiculoServicio(servicio.idVehiculo.uid);
    final auxilio = _validarPrecioServicio(servicio.auxilioEconomico);
    final fecha = servicio.fechayhora.split("T");

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            BlocProvider.of<ServicioBloc>(context)
                .add(OnServicioSeleccionado(servicio));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DetalleHistorialServicioPag()),
            );
          },
          child: Card(
            color: Theme.of(context).backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(15),
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                validarImagen(servicio),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subTitulosDelServicio(subtitulo: "Destino"),
                        SizedBox(
                          width: size.width * 0.55,
                          child: textoDelServicio(
                              texto: servicio.nombreDestino.toString()),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 20),
                            textoDelServicio(
                                texto: fecha[0] + " " + fecha[1].split(".")[0]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitulosDelServicio(subtitulo: "Valor"),
                    textoDelServicio(texto: auxilio),
                    const SizedBox(
                      height: 5,
                    ),
                    subTitulosDelServicio(subtitulo: "Placa"),
                    textoDelServicio(texto: servicio.idVehiculo.placa),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget cardDeServicioConductor(Servicio servicio) {
    final size = MediaQuery.of(context).size;
    final placa = _validarVehiculoServicio(servicio.idVehiculo.uid);
    final auxilio = _validarPrecioServicio(servicio.auxilioEconomico);
    final fecha = servicio.fechayhora.split("T");
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            BlocProvider.of<ServicioBloc>(context)
                .add(OnServicioSeleccionado(servicio));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DetalleHistorialServicioPag()),
            );
          },
          child: Card(
            color: Theme.of(context).backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(15),
            elevation: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                validarImagen(servicio),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subTitulosDelServicio(subtitulo: "Destino"),
                        SizedBox(
                          width: size.width * 0.5,
                          child: textoDelServicio(
                              texto: servicio.nombreDestino.toString()),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 20),
                            textoDelServicio(
                                texto: fecha[0] + " " + fecha[1].split(".")[0]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subTitulosDelServicio(subtitulo: "Valor"),
                    textoDelServicio(texto: auxilio),
                    const SizedBox(
                      height: 5,
                    ),
                    subTitulosDelServicio(subtitulo: "Placa"),
                    textoDelServicio(texto: placa),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///  Valida la placa del vehiculo que va a prestar el servicio con una lista que se encuentra preCargada en el Bloc
  Vehiculo _validarVehiculoServicioV(Servicio servicio) {
    final vehiculos =
        BlocProvider.of<PreserviciosBloc>(context).state.vehiculos;

    for (var vehiculo in vehiculos) {
      if (vehiculo.uid == servicio.idVehiculo.uid) {
        return vehiculo;
      }
    }
    return Vehiculo();
  }

  Widget validarImagen(Servicio servicio) {
    final vehiculo = _validarVehiculoServicioV(servicio);
    final asset = (vehiculo.tipoVehiculo == TipoVehiculo.carro)
        ? "img/icons/carro_icon.png"
        : "img/icons/moto_icon.png";

    return Image(
      image: AssetImage(asset),
      width: 75,
    );
  }

  String _validarVehiculoServicio(String uid) {
    final vehiculos =
        BlocProvider.of<PreserviciosBloc>(context).state.vehiculos;

    for (var vehiculo in vehiculos) {
      if (vehiculo.uid == uid) {
        return vehiculo.placa;
      }
    }
    return '';
  }

  String _validarPrecioServicio(String auxilio) {
    final auxilioEconomico =
        BlocProvider.of<PreserviciosBloc>(context).state.precios;

    for (var precio in auxilioEconomico) {
      if (precio.uid == auxilio) {
        NumberFormat formato = NumberFormat("#,##0", "es_AR");
        return '\$ ' + formato.format(precio.valor);
      }
    }
    return '';
  }
}
