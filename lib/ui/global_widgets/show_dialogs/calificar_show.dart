import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pa_donde_app/blocs/blocs.dart';

mostrarShowDialogCalificar({
  required BuildContext context,
  required String titulo,
  required String contenido,
  required IconData icono,
  required void Function()? funtionContinuar,
  void Function()? funtionCancelar,
}) {
  final size = MediaQuery.of(context).size;

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Text(
              titulo,
              style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: Theme.of(context).primaryColorLight),
            ),
          ),
          elevation: 2,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  BlocProvider.of<ServicioBloc>(context)
                      .add(OnCalificarAUsuario(rating.toInt()));
                },
              ),
              Text(
                contenido,
                style: TextStyle(fontSize: size.width * 0.043),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: funtionContinuar,
              child: Text(
                'CONTINUAR',
                style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      });
}
