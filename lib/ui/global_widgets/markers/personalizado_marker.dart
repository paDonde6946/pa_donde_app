import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;

Future<BitmapDescriptor> getImagenMarker() async {
  return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(5, 5)),
      "img/icons/pin_localizacion.png");
}

Future<BitmapDescriptor> getNetworkImagenMarker() async {
  final response = await Dio().get(
      'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png',
      options: Options(responseType: ResponseType.bytes));

  final imagenCodec = await ui.instantiateImageCodec(response.data,
      targetHeight: 120, targetWidth: 120);

  final frame = await imagenCodec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

  if (data == null) {
    return await getImagenMarker();
  }

  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}
