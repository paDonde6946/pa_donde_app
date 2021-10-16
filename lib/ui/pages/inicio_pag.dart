import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/pages/perfil_pag.dart';

class InicioPag extends StatefulWidget {
  InicioPag({Key? key}) : super(key: key);

  @override
  _InicioPagState createState() => _InicioPagState();
}

class _InicioPagState extends State<InicioPag> {
  /* Variables Auxiliares */
  int _index = 1;
  final _estilo = const TextStyle();
  /*----------------------*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PerfilPag(),
      bottomNavigationBar: footer(),
    );
  }

  /*-- Método al hacer tap sobre algún icono del BottomNavigationBar --*/
  void onTabTapped(int index) {
    setState(() => _index = index);
  }

  /*--Widget para cambio de páginas con respecto al BottomNavigationBar --*/
  Widget _llamarPagina(int paginaActual) {
    switch (paginaActual) {
      case 1:
        return InicioPag();
      case 0:
      case 2:
        return PerfilPag();

      default:
        return InicioPag();
    }
  }

  /*-- Widget encargado de la creación del BottomNavigationBar --*/
  Widget footer() {
    final media = MediaQuery.of(context).size;

    final tammanioIconos =
        (media.height <= 780) ? media.width * 0.05 : media.width * 0.07;

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: _index,
      onTap: onTabTapped,
      selectedFontSize: media.width * 0.042,
      unselectedFontSize: media.width * 0.035,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon:
              Icon(Icons.directions_car_filled_outlined, size: tammanioIconos),
          // ignore: deprecated_member_use
          title: Text("VEHICULO", style: _estilo),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: tammanioIconos),
          // ignore: deprecated_member_use
          title: Text("INICIO", style: _estilo),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_outlined, size: tammanioIconos),
          // ignore: deprecated_member_use
          title: Text("PERFIL", style: _estilo),
        )
      ],
    );
  }
}
