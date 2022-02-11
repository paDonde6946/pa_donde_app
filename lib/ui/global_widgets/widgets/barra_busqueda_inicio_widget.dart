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

    /// Metodo que permite validar si ya se hizo una busqueda actualizar el nombre y activar el marcador mmanual
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
          // Activa el buscador
          final resultado =
              await showSearch(context: context, delegate: BusquedaOrigen());
          if (resultado == null) return;
          onBusquedaResultados(context, resultado);
        },
        child: Material(
          elevation: 5,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.width * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  busquedaDireccion == "" ? 'Origen' : busquedaDireccion,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: size.width * 0.04,
                  ),
                ),
                const Icon(Icons.push_pin_outlined)
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
