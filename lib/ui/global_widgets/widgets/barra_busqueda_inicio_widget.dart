import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/data/models/servicio_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_origen.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class BuscadorBarraInicio extends StatefulWidget {
  const BuscadorBarraInicio({Key? key, required this.callbackFunction})
      : super(key: key);
  final Function? callbackFunction;

  @override
  State<BuscadorBarraInicio> createState() =>
      // ignore: no_logic_in_create_state
      _BuscadorBarraInicioState(callbackFunction);
}

class _BuscadorBarraInicioState extends State<BuscadorBarraInicio> {
  String busquedaDireccion = '';
  final Function? callbackFunction;

  _BuscadorBarraInicioState(this.callbackFunction);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final preServicioBloc = BlocProvider.of<PreserviciosBloc>(context);

    /// Metodo que permite validar si ya se hizo una busqueda actualizar el nombre y activar el marcador mmanual
    void onBusquedaResultados(
        BuildContext context, BusquedaResultado resultado) async {
      final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);

      if (resultado.nombreDestino != null) {
        busquedaDireccion = resultado.nombreDestino!;
        preServicioBloc.add(
            OnCrearServicio(Servicio(pNombreOrigen: resultado.nombreDestino!)));
        setState(() {});
      }

      if (resultado.manual) {
        busquedaBloc.add(OnActivarMarcadorManual());
        return;
      }
      setState(() {});
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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.width * 0.025),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    preServicioBloc.state.servicio.nombreOrigen ?? 'Origen',
                    // overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: preServicioBloc.state.servicio.nombreOrigen != null
                          ? Colors.black
                          : Theme.of(context).primaryColor,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ),
              ),
              const Icon(Icons.push_pin_outlined)
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

  Future<void> retornoBusqueda(
      BuildContext context, BusquedaResultado resultado) async {
    if (resultado.cancelo) return;

    if (resultado.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
