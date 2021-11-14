// ignore: import_of_legacy_library_into_null_safe
import 'package:custom_navigator/custom_navigator.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pa_donde_app/ui/pages/cargando_gps_pag.dart';

//------------------IMPORTACIONES LOCALES------------------------------
import 'package:pa_donde_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:pa_donde_app/ui/pages/perfil_pag.dart';
import 'package:pa_donde_app/ui/pages/principal_pag.dart';
import 'package:pa_donde_app/ui/pages/vehiculo_pag.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//---------------------------------------------------------------------

class InicioPag extends StatefulWidget {
  const InicioPag({Key? key, this.titulo}) : super(key: key);

  final String? titulo;

  @override
  _InicioPagState createState() => _InicioPagState();
}

class _InicioPagState extends State<InicioPag> {
  /* Variables Auxiliares */
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _children = [
    const PrincipalPag(),
    const CargandoGPSPag(),
    const VehiculoPag(),
    PerfilPag(),
  ];
  /*----------------------*/

  Widget _page = const CargandoGPSPag();
  int _currentIndex = 1;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomNavigator(
          navigatorKey: navigatorKey,
          home: _page,
          //Specify your page route [PageRoutes.materialPageRoute] or [PageRoutes.cupertinoPageRoute]
          pageRoute: PageRoutes.materialPageRoute,
        ),
        bottomNavigationBar: footerCustom());
  }

  /// Widget encargado de la creación del BottomNavigationBar
  Widget footerCustom() {
    final media = MediaQuery.of(context).size;

    final tammanioIconos =
        (media.height <= 780) ? media.width * 0.05 : media.width * 0.07;
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _currentIndex,
      height: 60.0,
      items: [
        Icon(Icons.home_outlined, size: tammanioIconos, color: Colors.black),
        Icon(Icons.map_outlined, size: tammanioIconos, color: Colors.black),
        Icon(Icons.directions_car_filled_outlined,
            size: tammanioIconos, color: Colors.black),
        Icon(Icons.person_outlined, size: tammanioIconos, color: Colors.black),
      ],
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      onTap: (index) {
        navigatorKey.currentState!.maybePop();
        setState(() => _page = _children[index]);
        _currentIndex = index;
        // Cnacelar el seguimiento cuando no este en la pagina de la ruta
        if (_currentIndex != 1) {
          BlocProvider.of<MiUbicacionBloc>(context)!.cancelarSeguimiento();
          setState(() {});
        }
      },
      buttonBackgroundColor: Theme.of(context).primaryColor,
      animationCurve: Curves.easeInSine,
      animationDuration: const Duration(milliseconds: 600),
      letIndexChange: (index) => true,
    );
  }
}
