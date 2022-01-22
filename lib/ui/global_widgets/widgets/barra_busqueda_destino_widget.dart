import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/busqueda/busqueda_bloc.dart';
import 'package:pa_donde_app/blocs/mapas/maps_bloc.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_destino.dart';
//---------------------------------------------------------------------

class BuscadorBarraDestino extends StatelessWidget {
  final String busquedaDireccion;

  const BuscadorBarraDestino({Key? key, required this.busquedaDireccion})
      : super(key: key);

  void onBusquedaResultados(
      BuildContext context, BusquedaResultado resultado) async {
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    final mapaBloc = BlocProvider.of<MapsBloc>(context);
    final localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);

    if (resultado.manual) {
      busquedaBloc.add(OnActivarMarcadorManual());
      return;
    }

    if (resultado.posicion != null) {
      final destino = await busquedaBloc.getCoordInicioYFin(
          localizacionBloc.state.ultimaLocalizacion!, resultado.posicion!);

      await mapaBloc.dibujarRutaPolyline(context, destino);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                        ? 'Destino'.toUpperCase()
                        : busquedaDireccion,
                    style: const TextStyle(color: Colors.black87)),
                const Icon(Icons.add_location)
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

  void retornoBusqueda(BuildContext context, BusquedaResultado resultado) {
    if (resultado.cancelo) return;

    if (resultado.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
