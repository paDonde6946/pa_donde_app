import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class BtnSeguirUsuario extends StatelessWidget {
  const BtnSeguirUsuario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapsBloc>(context);

    return Material(
      elevation: 10,
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 25,
          child: BlocBuilder<MapsBloc, MapsState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    mapaBloc.add(OnIniciarSeguirUsuario());
                  },
                  icon: Icon(
                      state.seguirUsuario
                          ? Icons.directions_run_outlined
                          : Icons.hail_outlined,
                      color: Colors.black87));
            },
          ),
        ),
      ),
    );
  }
}
