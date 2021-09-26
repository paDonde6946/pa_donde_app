import 'package:flutter/material.dart';
import 'package:pa_donde_app/routes/routes.dart';
import 'package:pa_donde_app/ui/utils/snack_bars.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pa Donde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: const Color.fromRGBO(94, 153, 45, 1),
          primaryColorLight: const Color.fromRGBO(232, 119, 29, 1)),
      initialRoute: 'login',
      routes: generarRutas(),
    );
  }
}
