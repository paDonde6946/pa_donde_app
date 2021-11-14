import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/routes/routes.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

import 'package:pa_donde_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:pa_donde_app/bloc/mapa/mapa_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AutenticacionServicio(),
        ),
      ],

      /// Bloc Provider
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MiUbicacionBloc(),
          ),
          BlocProvider(
            create: (context) => MapaBloc(),
          )
        ],
        child: MaterialApp(
          title: 'Pa Donde',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: const Color.fromRGBO(94, 153, 45, 1),
              primaryColorLight: const Color.fromRGBO(232, 119, 29, 1)),
          initialRoute: 'validarInicioSesion',
          routes: generarRutas(),
        ),
      ),
    );
  }
}
