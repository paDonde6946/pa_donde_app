import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:pa_donde_app/data/services/autencicacion_servicio.dart';
import 'package:pa_donde_app/global/entorno_variable_global.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  test("Autenticacion - Login Response HTTP", () {
    Future<http.Response> _mockRequest(http.Request request) async {
      if (request.url.toString().startsWith(
          'https://10.0.2.2:3001/app/login/usuario/felipe@unbosque.edu.co/1234')) {
        return http.Response(
            File('test/test_resources/inicio_sesion_response_json.json')
                .readAsStringSync(),
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            });
      }
      return http.Response('Error: Unknown endpoint', 404);
    }
  });
}