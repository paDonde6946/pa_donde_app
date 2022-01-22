import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/busqueda/busqueda_bloc.dart';
// import 'package:pa_donde_app/blocs/mapa/mapa_bloc.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_origen.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class BuscadorBarraInicio extends StatelessWidget {
  final String busquedaDireccion;

  const BuscadorBarraInicio({Key? key, required this.busquedaDireccion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void onBusquedaResultados(
        BuildContext context, BusquedaResultado resultado) async {
      final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
      final mapaBloc = BlocProvider.of<MapsBloc>(context);
      final localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);

      if (resultado.manual) {
        busquedaBloc.add(OnActivarMarcadorManual());
        return;
      }

      // if (resultado.posicion != null) {
      //   final destino = await busquedaBloc.getCoordInicioYFin(
      //       localizacionBloc.state.ultimaLocalizacion!, resultado.posicion!);

      //   await mapaBloc.dibujarRutaPolyline(context, destino);
      // }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      width: size.width,
      child: GestureDetector(
        onTap: () async {
          final resultado =
              await showSearch(context: context, delegate: BusquedaOrigen());
          if (resultado == null) return;
          onBusquedaResultados(context, resultado);
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
                        ? 'Origen'.toUpperCase()
                        : busquedaDireccion,
                    style: const TextStyle(color: Colors.black87)),
                const Icon(Icons.location_searching)
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
    if (resultado.cancelo) return;

    if (resultado.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
