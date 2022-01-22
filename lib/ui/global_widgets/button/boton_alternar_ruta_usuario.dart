import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

class BtnAlternarRutaUsuario extends StatelessWidget {
  const BtnAlternarRutaUsuario({Key? key}) : super(key: key);

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
            child: IconButton(
                onPressed: () {
                  mapaBloc.add(OnRutaAlternarUsuario());
                },
                icon: const Icon(Icons.more_horiz_rounded,
                    color: Colors.black87))),
      ),
    );
  }
}
