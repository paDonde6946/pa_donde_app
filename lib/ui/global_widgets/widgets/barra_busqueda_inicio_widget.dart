import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:pa_donde_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:pa_donde_app/data/models/busqueda_resultados_modelo.dart';
import 'package:pa_donde_app/ui/global_widgets/search/busqueda_origen.dart';

class BuscadorBarraInicio extends StatelessWidget {
  // final void Function()? function;

  const BuscadorBarraInicio({Key? key}) : super(key: key);

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
          final bussquedaResultado = await showSearch(
              context: context, delegate: BusquedaOrigen(proximidad!));
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
                Text("Origen", style: TextStyle(color: Colors.black87)),
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

  void retornoBusqueda(BuildContext context, BusquedaResultado resultado) {
    if (resultado.cancelo!) return;

    if (resultado.manual!) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
