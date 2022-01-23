import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1IjoicGFkb25kZSIsImEiOiJja3cwMnZndjMxYXV1MnBxaXdiNWwxYWE0In0.KarZCsSvtXjCHQLFMWzftg';

class LugararesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'autocomplete': 'true',
      'language': "es",
      'country': 'co',
    });

    super.onRequest(options, handler);
  }
}
