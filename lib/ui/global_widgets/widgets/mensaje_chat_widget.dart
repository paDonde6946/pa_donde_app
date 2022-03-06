import 'package:flutter/material.dart';

class MensajeChatWidget extends StatelessWidget {
  final String texto;
  final bool mio;
  final AnimationController animationController;

  const MensajeChatWidget(
      {Key? key,
      required this.texto,
      required this.mio,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: _mensaje(context, mio),
        ),
      ),
    );
  }

  Widget _mensaje(context, mio) {
    return Align(
        alignment: (mio) ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5, left: 50, right: 10),
          padding: const EdgeInsets.all(8.0),
          child: Text(texto,
              style: (mio)
                  ? TextStyle(color: Theme.of(context).primaryColor)
                  : TextStyle(color: Theme.of(context).primaryColorLight)),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(114, 209, 237, 1),
              borderRadius: BorderRadius.circular(20)),
        ));
  }
}
