import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

import 'package:pa_donde_app/ui/global_widgets/markers/markers.dart';

/// Metodo que permite convertir el Widget Marker personalizado Inicial a una imagen
Future<BitmapDescriptor> getComenzarMarkerPersonalizado(
    int minutos, String destino) async {
  return await _getMarkerPainter(
      InicialMarkerPainter(minutos: minutos, destino: destino));
}

/// Metodo que permite convertir el Widget Marker personalizado Final a una imagen
Future<BitmapDescriptor> getFinalMarkerPersonalizado(
    String destino, int kilometros, BuildContext context, int duracion) async {
  return await _getMarkerPainter(FinallMarkerPainter(
      kilometros: kilometros,
      destino: destino,
      context: context,
      duracion: duracion));
}

// Funcion generica para convertir un CustomPainter a BitmapDescriptor
Future<BitmapDescriptor> _getMarkerPainter(CustomPainter markerPainter,
    {double width = 350, double height = 150}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

  markerPainter.paint(canvas, ui.Size(width, height));

  final picture = recorder.endRecording();

  final image = await picture.toImage(width.toInt(), height.toInt());

  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}
