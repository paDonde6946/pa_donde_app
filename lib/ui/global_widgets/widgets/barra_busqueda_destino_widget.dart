import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_destino.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_origen.dart';

class BuscadorBarraDestino extends StatelessWidget {
  const BuscadorBarraDestino({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      width: size.width,
      child: GestureDetector(
        onTap: () async {
          final bussquedaResultado =
              await showSearch(context: context, delegate: BusquedaDestino());
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
              children: const [
                Text("Destino", style: TextStyle(color: Colors.black87)),
                Icon(Icons.add_location)
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
    if (resultado.cancelo!) return;

    if (resultado.manual!) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
