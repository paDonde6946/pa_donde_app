import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/ui/utils/snack_bars.dart';
//---------------------------------------------------------------------

class BtnUbicacion extends StatelessWidget {
  const BtnUbicacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapsBloc>(context);
    final localizacionBloc = BlocProvider.of<LocalizacionBloc>(context);

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
                final usuarioLocalizacion =
                    localizacionBloc.state.ultimaLocalizacion;

                /// Si no encuentra la ultima ubicacion del usuario
                if (usuarioLocalizacion == null) {
                  customShapeSnackBar(
                      context: context, titulo: 'No se encuentra la ubicación');
                  return;
                }
                mapaBloc.moverCamara(usuarioLocalizacion);
              },
              icon: const Icon(Icons.my_location, color: Colors.black87)),
        ),
      ),
    );
  }
}
