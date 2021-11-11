import 'package:flutter/material.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/ui/pages/perfil_pag.dart';
import 'package:pa_donde_app/ui/pages/principal_pag.dart';
import 'package:pa_donde_app/ui/pages/ruta_pag.dart';
import 'package:pa_donde_app/ui/pages/vehiculo_pag.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//---------------------------------------------------------------------

class InicioPag extends StatefulWidget {
  const InicioPag({Key? key}) : super(key: key);

  @override
  _InicioPagState createState() => _InicioPagState();
}

class _InicioPagState extends State<InicioPag> {
  /* Variables Auxiliares */
  int _index = 1;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  /*----------------------*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _llamarPagina(_index), bottomNavigationBar: footerCustom());
  }

  /// Método al hacer tap sobre algún icono del BottomNavigationBar
  void onTabTapped(int index) {
    setState(() => _index = index);
  }

  /// Widget para cambio de páginas con respecto al BottomNavigationBar
  Widget _llamarPagina(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return const PrincipalPag();
      case 2:
        return const VehiculoPag();
      case 3:
        return PerfilPag();
      case 1:
        return RutaPag();

      default:
        return const PrincipalPag();
    }
  }

  /// Widget encargado de la creación del BottomNavigationBar
  Widget footerCustom() {
    final media = MediaQuery.of(context).size;

    final tammanioIconos =
        (media.height <= 780) ? media.width * 0.05 : media.width * 0.07;
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 1,
      height: 60.0,
      items: [
        Icon(Icons.home_outlined, size: tammanioIconos, color: Colors.black),
        Icon(Icons.map_outlined, size: tammanioIconos, color: Colors.black),
        Icon(Icons.directions_car_filled_outlined,
            size: tammanioIconos, color: Colors.black),
        Icon(Icons.person_outlined, size: tammanioIconos, color: Colors.black),
      ],
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      onTap: onTabTapped,
      buttonBackgroundColor: Theme.of(context).primaryColor,
      animationCurve: Curves.easeInSine,
      animationDuration: const Duration(milliseconds: 600),
      letIndexChange: (index) => true,
    );
  }
}
