import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pa_donde_app/blocs/servicios/servicio_bloc.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/data/services/trafico_servicio.dart';
import 'package:pa_donde_app/routes/routes.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
//---------------------------------------------------------------------

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => UsuarioBloc()),
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => LocalizacionBloc()),
      BlocProvider(create: (context) => PreserviciosBloc()),
      BlocProvider(create: (context) => PaginasBloc()),
      BlocProvider(create: (context) => ServicioBloc()),
      BlocProvider(
          create: (context) => MapsBloc(
              localizacionBloc: BlocProvider.of<LocalizacionBloc>(context))),
      BlocProvider(
          create: (context) => BusquedaBloc(
              preserviciosBloc: BlocProvider.of<PreserviciosBloc>(context),
              traficoServicio: TraficoServicio())),
    ],
    child: const MyApp(),
  ));
}

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
      child: MaterialApp(
        title: 'Pa Donde',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(94, 153, 45, 1),
          primaryColorLight: const Color.fromRGBO(232, 119, 29, 1),
          backgroundColor: const Color.fromRGBO(238, 246, 232, 1),
        ),
        initialRoute: 'validarInicioSesion',
        routes: generarRutas(),
        localizationsDelegates: const [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('es', ''),
        ],
      ),
    );
  }
}
