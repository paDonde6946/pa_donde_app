// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pa_donde_app/blocs/busqueda/busqueda_bloc.dart';

class MarcardorManual extends StatelessWidget {
  const MarcardorManual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return contenido(context);
        } else {
          return Container();
        }
      },
    );
  }

  Widget contenido(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -12),
        child: BounceInDown(
          from: 100,
          child: Icon(
            Icons.location_on,
            size: 45,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
