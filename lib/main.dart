import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/routes/routes.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            primaryColorLight: const Color.fromRGBO(232, 119, 29, 1)),
        initialRoute: 'login',
        routes: generarRutas(),
      ),
    );
  }
}
