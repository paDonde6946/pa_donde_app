import 'package:flutter/material.dart';

class InicioSesionPag extends StatefulWidget {
  @override
  _InicioSesionPagState createState() => _InicioSesionPagState();
}

class _InicioSesionPagState extends State<InicioSesionPag> {
  final radius = const Radius.circular(50);
  final radiusAll = const Radius.circular(100);

  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (index) {
          pageChanged(index);
        },
        scrollDirection: Axis.vertical,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: [
                Container(
                  height: 600,
                  color: Colors.red,
                ),
                Positioned(
                    bottom: 110,
                    right: 200,
                    left: 120,
                    child: Container(
                      height: 80,
                      width: 100,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_drop_up_outlined,
                            color: Colors.black,
                            size: 100,
                          )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(radius),
                          color: Colors.red),
                    )),
                Positioned(
                    bottom: 110,
                    right: 100,
                    left: 230,
                    child: Container(
                      height: 80,
                      width: 80,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.black,
                            size: 100,
                          )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(radius),
                          color: Colors.red),
                    ))
              ],
            ),
          ),
          /////////////////////////////////////////////////
          Container(
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: [
                Container(
                  height: 200,
                  color: Colors.blue,
                ),
                Positioned(
                    top: 160,
                    right: 200,
                    left: 120,
                    child: Container(
                      height: 80,
                      width: 100,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_drop_up_outlined,
                            color: Colors.black,
                            size: 100,
                          )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(radius),
                          color: Colors.red),
                    )),
                Positioned(
                    top: 150,
                    right: 100,
                    left: 230,
                    child: Container(
                      height: 80,
                      width: 80,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.black,
                            size: 100,
                          )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(radius),
                          color: Colors.red),
                    ))
              ],
            ),
          ),
        ],
      )),
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
