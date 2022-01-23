import 'package:flutter/material.dart';

class FinallMarkerPainter extends CustomPainter {
  final int kilometros;
  final String destino;
  final int duracion;
  final BuildContext context;

  FinallMarkerPainter({
    required this.kilometros,
    required this.destino,
    required this.duracion,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// Lapiz para dibujar verde
    final lapizVerde = Paint()..color = Theme.of(context).primaryColor;

    /// Lapiz para dibujar Blanco
    final lapizBlanco = Paint()..color = Colors.white;

    const double radioCirculoNegro = 20;
    const double radioCirculoBlanco = 7;

    /// Circulo negro
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height - radioCirculoNegro),
      radioCirculoNegro,
      lapizVerde,
    );

    /// Circulo blanco
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height - radioCirculoNegro),
      radioCirculoBlanco,
      lapizBlanco,
    );

    /// Dibujar una caja blanca
    final path = Path();

    path.moveTo(10, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(size.width * 0.55, 100);
    path.quadraticBezierTo(
        size.width * 0.5, size.height - 30, size.width * 0.5, 125);

    path.quadraticBezierTo(
        size.width * 0.5, size.height - 30, size.width * 0.43, 100);
    path.lineTo(10, 100);

    /// Sombra
    canvas.drawShadow(path, Colors.black, 10, false);

    lapizBlanco.style = PaintingStyle.fill;
    lapizBlanco.strokeWidth = 5.0;

    /// Caja
    canvas.drawPath(path, lapizBlanco);

    /// Caja verde
    const cajaVerde = Rect.fromLTWH(10, 20, 70, 80);
    const cajaVerde2 = Rect.fromLTWH(270, 20, 70, 80);

    canvas.drawRect(cajaVerde, lapizVerde);
    canvas.drawRect(cajaVerde2, lapizVerde);

    /// Textos

    /// KILOMETROS
    final textoSpan = TextSpan(
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
      text: '$kilometros',
    );

    final kmPainter = TextPainter(
        text: textoSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        minWidth: 70,
        maxWidth: 70,
      );

    kmPainter.paint(canvas, const Offset(10, 35));

    /// Palabra kilometros
    const palabraKMText = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
      text: 'KM',
    );

    final kmTextoPainter = TextPainter(
        text: palabraKMText,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        minWidth: 70,
        maxWidth: 70,
      );

    kmTextoPainter.paint(canvas, const Offset(10, 68));

    /// Descripcion
    final localizacionText = TextSpan(
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
      text: destino,
    );

    final localizacionTextoPainter = TextPainter(
        maxLines: 3,
        ellipsis: '...',
        text: localizacionText,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        minWidth: 180,
        maxWidth: 180,
      );

    // Calculos
    final double offsetY = (destino.length > 20) ? 25 : 48;

    // pintar
    localizacionTextoPainter.paint(canvas, Offset(85, offsetY));

    /// DURACION
    final duracionText = TextSpan(
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
      text: duracion.toString(),
    );

    final duracionTextoPainter = TextPainter(
        maxLines: 3,
        ellipsis: '...',
        text: duracionText,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        minWidth: 70,
        maxWidth: 70,
      );

    duracionTextoPainter.paint(canvas, const Offset(270, 35));

    /// Palabra Minutos
    const palabraMinutosText = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
      text: 'MIN',
    );

    final minutosTextoPainter = TextPainter(
        text: palabraMinutosText,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(
        minWidth: 70,
        maxWidth: 70,
      );

    minutosTextoPainter.paint(canvas, const Offset(270, 68));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
