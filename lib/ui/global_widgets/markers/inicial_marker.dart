import 'package:flutter/material.dart';

class InicialMarkerPainter extends CustomPainter {
  final int minutos;
  final String destino;

  InicialMarkerPainter({
    required this.minutos,
    required this.destino,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// Lapiz para dibujar negro
    final lapizNegro = Paint()..color = Colors.black;

    /// Lapiz para dibujar Blanco
    final lapizBlanco = Paint()..color = Colors.white;

    const double radioCirculoNegro = 20;
    const double radioCirculoBlanco = 7;

    /// Circulo negro
    canvas.drawCircle(
      Offset(radioCirculoNegro, size.height - radioCirculoNegro),
      radioCirculoNegro,
      lapizNegro,
    );

    /// Circulo blanco
    canvas.drawCircle(
      Offset(radioCirculoNegro, size.height - radioCirculoNegro),
      radioCirculoBlanco,
      lapizBlanco,
    );

    /// Dibujar una caja blanca
    final path = Path();

    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    /// Sombra
    canvas.drawShadow(path, Colors.black, 10, false);

    /// Caja
    canvas.drawPath(path, lapizBlanco);

    /// Caja negra
    const cajaNegra = Rect.fromLTWH(40, 20, 70, 80);

    canvas.drawRect(cajaNegra, lapizNegro);

    /// Textos
    /// Minutos
    final textoSpan = TextSpan(
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
      text: '$minutos',
    );

    final minutosPainter = TextPainter(
        text: textoSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        minWidth: 70,
        maxWidth: 70,
      );

    minutosPainter.paint(canvas, const Offset(40, 35));

    /// Palabra minutos
    const minutosText = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
      text: 'Min',
    );

    final minutosTextoPainter = TextPainter(
        text: minutosText,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        minWidth: 70,
        maxWidth: 70,
      );

    minutosTextoPainter.paint(canvas, const Offset(40, 68));

    /// Descripcion

    final localizacionText = TextSpan(
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
      text: destino,
    );

    final localizacionTextoPainter = TextPainter(
        maxLines: 2,
        ellipsis: '...',
        text: localizacionText,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(
        minWidth: size.width - 135,
        maxWidth: size.width - 135,
      );

    // Calculos
    final double offsetY = (destino.length > 20) ? 35 : 48;

    // pintar
    localizacionTextoPainter.paint(canvas, Offset(120, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
