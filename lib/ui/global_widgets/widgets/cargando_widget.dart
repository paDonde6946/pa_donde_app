// ignore: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';

class Cargando extends StatelessWidget {
  final Size size;

  Cargando({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              height: size.height * 0.23,
              image: const AssetImage('img/logo/logo_PaDonde.png')),
          const SizedBox(
            height: 40,
          ),
          CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            strokeWidth: 5,
          )
        ],
      ),
    );
  }
}
