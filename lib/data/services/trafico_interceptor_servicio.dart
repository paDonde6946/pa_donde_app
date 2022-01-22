import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1IjoicGFkb25kZSIsImEiOiJja3cwMnhhaGo5cDNrMm9xcHZ1aHp3MG5sIn0.xK7J4icnMawVN-_Qx0t_9g';

class TraficoInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': 'true',
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': 'false',
      'access_token': accessToken,
      'language': 'es',
    });

    super.onRequest(options, handler);
  }
}
