import 'package:flutter/material.dart';
import 'package:pa_donde_app/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pa Donde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(94, 153, 45, 1),
      ),
      initialRoute: 'login',
      routes: generarRutas(),
    );
  }
}
