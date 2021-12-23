import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/blocs/busqueda/busqueda_bloc.dart';
import 'package:pa_donde_app/blocs/mapa/mapa_bloc.dart';
import 'package:pa_donde_app/blocs/mi_ubicacion/mi_ubicacion_bloc.dart';

class BtnUbicacion extends StatelessWidget {
  const BtnUbicacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final ubicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);

    return Material(
      elevation: 10,
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 25,
          child: IconButton(
              onPressed: () {
                final destino = ubicacionBloc.state.ubicacion;
                BlocProvider.of<BusquedaBloc>(context)
                    .add(OnActivarMarcadorManual());
                mapaBloc.moverCamara(destino!);
              },
              icon: const Icon(Icons.my_location, color: Colors.black87)),
        ),
      ),
    );
  }
}
