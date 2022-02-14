import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/busqueda/busqueda_bloc.dart';
import 'package:pa_donde_app/blocs/mapas/mapas_bloc.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/data/services/trafico_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_destino.dart';
import 'package:pa_donde_app/ui/global_widgets/widgets/barra_busqueda_inicio_widget.dart';
//---------------------------------------------------------------------

class BuscadorBarraDestino extends StatefulWidget {
  const BuscadorBarraDestino({Key? key}) : super(key: key);

  @override
  State<BuscadorBarraDestino> createState() => _BuscadorBarraDestinoState();
}

class _BuscadorBarraDestinoState extends State<BuscadorBarraDestino> {
  String busquedaDireccion = '';

  void onBusquedaResultados(
      BuildContext context, BusquedaResultado resultado) async {
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    final mapaBloc = BlocProvider.of<MapsBloc>(context);
    final localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);
    final preServicioBloc = BlocProvider.of<PreserviciosBloc>(context);
    Servicio servicio = Servicio();

    if (resultado.manual) {
      busquedaBloc.add(OnActivarMarcadorManual());
      return;
    }

    if (resultado.nombreDestino != null) {
      busquedaDireccion = resultado.nombreDestino!;
      servicio.nombreDestino = resultado.nombreDestino!;

      servicio.nombreOrigen = preServicioBloc.servicio?.nombreOrigen;
      if (preServicioBloc.servicio?.nombreOrigen == null) {
        TraficoServicio traficoServicio = TraficoServicio();
        final respuesta = await traficoServicio.getInformacionPorCoordenas(
            localizacionBloc.state.ultimaLocalizacion!);
        servicio.nombreOrigen = respuesta.textEs;
        preServicioBloc.add(OnBusquedaInicioServicio(respuesta.textEs!));
        setState(() {});
      }
    }

    if (resultado.posicion != null) {
      final destino = await busquedaBloc.getCoordInicioYFin(
          localizacionBloc.state.ultimaLocalizacion!, resultado.posicion!);

      await mapaBloc.dibujarRutaPolyline(context, destino);
      servicio.rutaDestino = destino;
      servicio.polylineRuta = preServicioBloc.state.servicio.polylineRuta;
      preServicioBloc.add(OnCrearServicio(servicio));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final preServicioBloc = BlocProvider.of<PreserviciosBloc>(context);

    setState(() {});
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      width: size.width,
      child: GestureDetector(
        onTap: () async {
          final resultado =
              await showSearch(context: context, delegate: BusquedaDestino());
          if (resultado == null) return;
          onBusquedaResultados(context, resultado);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.width * 0.025),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                preServicioBloc.servicio?.nombreDestino ?? 'Destino',
                style: TextStyle(
                  color: preServicioBloc.state.servicio.nombreDestino != null
                      ? Colors.black
                      : Theme.of(context).primaryColor,
                  fontSize: size.width * 0.04,
                ),
              ),
              const Icon(Icons.location_on)
            ],
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).primaryColor, width: 1)),
          ),
        ),
      ),
    );
  }

  void retornoBusqueda(BuildContext context, BusquedaResultado resultado) {
    if (resultado.cancelo) return;

    if (resultado.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
