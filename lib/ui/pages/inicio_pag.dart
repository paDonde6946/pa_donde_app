import 'package:flutter/material.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/ui/pages/perfil_pag.dart';
import 'package:pa_donde_app/ui/pages/principal_pag.dart';
import 'package:pa_donde_app/ui/pages/vehiculo_pag.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class InicioPag extends StatefulWidget {
  InicioPag({Key? key}) : super(key: key);

  @override
  _InicioPagState createState() => _InicioPagState();
}

class _InicioPagState extends State<InicioPag> {
  /* Variables Auxiliares */
  int _index = 1;
  final _estilo = const TextStyle();
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  /*----------------------*/

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AutenticacionServicio>(context).autenticando;

    print(usuario);
    print("=================");

    return Scaffold(
        body: _llamarPagina(_index), bottomNavigationBar: footerCustom());
  }

  /*-- Método al hacer tap sobre algún icono del BottomNavigationBar --*/
  void onTabTapped(int index) {
    setState(() => _index = index);
  }

  /*--Widget para cambio de páginas con respecto al BottomNavigationBar --*/
  Widget _llamarPagina(int paginaActual) {
    switch (paginaActual) {
      case 1:
        return PrincipalPag();
      case 0:
        return VehiculoPag();
      case 2:
        return PerfilPag();

      default:
        return InicioPag();
    }
  }

  Widget footerCustom() {
    final media = MediaQuery.of(context).size;

    final tammanioIconos =
        (media.height <= 780) ? media.width * 0.05 : media.width * 0.07;
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 0,
      height: 60.0,
      items: [
        Icon(Icons.directions_car_filled_outlined,
            size: tammanioIconos, color: Colors.black),
        Icon(Icons.home_outlined, size: tammanioIconos, color: Colors.black),
        Icon(Icons.person_outlined, size: tammanioIconos, color: Colors.black),
      ],
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      onTap: onTabTapped,
      buttonBackgroundColor: Theme.of(context).primaryColor,
      animationCurve: Curves.easeInSine,
      animationDuration: const Duration(milliseconds: 600),
      letIndexChange: (index) => true,
    );
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
