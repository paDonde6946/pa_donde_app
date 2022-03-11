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
          margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(texto,
              style: const TextStyle(color: Colors.black87, fontSize: 15)),
          decoration: BoxDecoration(
              color: (mio)
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(10)),
        ));
  }
}
