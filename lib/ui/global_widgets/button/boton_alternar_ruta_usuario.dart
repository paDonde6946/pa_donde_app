import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
//---------------------------------------------------------------------

class BtnAlternarRutaUsuario extends StatelessWidget {
  const BtnAlternarRutaUsuario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  //   mapaBloc.add(OnRutaAlternarUsuario());
                },
                icon: const Icon(Icons.more_horiz_rounded,
                    color: Colors.black87))),
      ),
    );
  }
}
