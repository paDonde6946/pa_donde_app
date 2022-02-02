import 'package:flutter/material.dart';

class PruebaPag extends StatefulWidget {
  const PruebaPag({Key? key}) : super(key: key);

  @override
  State<PruebaPag> createState() => _PruebaPagState();
}

class _PruebaPagState extends State<PruebaPag> {
  PageController controller = PageController(initialPage: 1);
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 400,
        width: double.infinity,
        child: PageView(
          onPageChanged: (i) {
            page = i;
          },
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.blue,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.jumpToPage(1);
        },
      ),
    );
  }
}
