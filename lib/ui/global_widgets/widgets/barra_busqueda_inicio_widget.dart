import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pa_donde_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:pa_donde_app/bloc/mapa/mapa_bloc.dart';
import 'package:pa_donde_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/data/services/trafico_servicio.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_origen.dart';

import 'package:polyline_do/polyline_do.dart' as Poly;

class BuscadorBarraInicio extends StatelessWidget {
  final String busquedaDireccion;

  BuscadorBarraInicio({Key? key, required this.busquedaDireccion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      width: size.width,
      child: GestureDetector(
        onTap: () async {
          final proximidad =
              BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
          final historial =
              BlocProvider.of<BusquedaBloc>(context).state.historial;
          final bussquedaResultado = await showSearch(
              context: context,
              delegate:
                  BusquedaOrigen(proximidad!, historial, busquedaDireccion));
          retornoBusqueda(context, bussquedaResultado!);
        },
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.width * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    busquedaDireccion == ""
                        ? '¿ Donde es el servicio?'.toUpperCase()
                        : busquedaDireccion,
                    style: TextStyle(color: Colors.black87)),
                Icon(Icons.location_searching)
              ],
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> retornoBusqueda(
      BuildContext context, BusquedaResultado resultado) async {
    if (resultado.cancelo!) return;

    if (resultado.manual!) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }

    // Calcular la ruta en base al valor: Result
    final traficoServicio = TraficoServicio();
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = resultado.posicion;

    final rutaResponse =
        await traficoServicio.getCoordsInicioYFin(inicio, destino!);

    final geometry = rutaResponse.routes![0].geometry;
    final duracion = rutaResponse.routes![0].duration;
    final distancia = rutaResponse.routes![0].distance;

    final points = Poly.Polyline.Decode(encodedString: geometry!, precision: 6);

    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();

    mapaBloc
        .add(OnCrearRutaInicioDestino(rutaCoordenadas, distancia!, duracion!));

    /// Agregar historial
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    busquedaBloc.add(OnAgregarHistorial(resultado));
  }
}
