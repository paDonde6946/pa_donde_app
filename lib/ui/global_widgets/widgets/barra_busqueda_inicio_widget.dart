import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_origen.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class BuscadorBarraInicio extends StatefulWidget {
  const BuscadorBarraInicio({Key? key}) : super(key: key);

  @override
  State<BuscadorBarraInicio> createState() => _BuscadorBarraInicioState();
}

class _BuscadorBarraInicioState extends State<BuscadorBarraInicio> {
  String busquedaDireccion = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void onBusquedaResultados(
        BuildContext context, BusquedaResultado resultado) async {
      final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);

      if (resultado.nombreDestino != null) {
        busquedaDireccion = resultado.nombreDestino!;
        setState(() {});
      }
      if (resultado.manual) {
        busquedaBloc.add(OnActivarMarcadorManual());
        return;
      }
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
