import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';

class ServicioPushNotificacion {
  static StreamController<dynamic> _mensajeStream =
      StreamController.broadcast();
  static Stream<dynamic> get mensajeStream => _mensajeStream.stream;
  late BuildContext context;

  static Future<dynamic> onBackgroundMessage(RemoteMessage mensaje) async {
    print("woooooooooooooow");
    Map<String, dynamic> message = mensaje.data;
    print(
        '===================================== onMensaje ====================================');
    _mensajeStream.sink.add(mensaje.data);
  }

  Future<String> initNotifications(BuildContext pContext) async {
    await Firebase.initializeApp();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    this.context = pContext;
    String? token = await firebaseMessaging.getToken();
    print('===== Token FIRE BASE ====');
    print(token);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(onLaunch);
    return token!;
  }

//   Future<dynamic> onMessage(Map<String, dynamic> menssage) async {
//     print(
//         '===================================== onMensaje ====================================');
//     print(menssage['data']);

//     final argumento = menssage['data']['para'];
//     _mensajesStreamControl.sink.add(argumento);
//   }

  Future<dynamic> onLaunch(RemoteMessage mensaje) async {
    print('=============================== ON LAUNCH ========================');
    print('Message data: ${mensaje.data}');

    // await validador(message.data);

    _mensajeStream.sink.add(mensaje.data);

    if (mensaje.notification != null) {
      print('Message also contained a notification: ${mensaje.notification}');
    }
  }

//   Future<dynamic> onResume(Map<String, dynamic> menssage) async {
//     print(
//         '===================================== onResume ====================================');
//     print(menssage['data']);

//     final argumento = menssage['data']['para'];
//     _mensajesStreamControl.sink.add(argumento);
//   }

  validador(data) async {
    /**
     * 0 = Chat
     * 1 = Aceptacion Servicio
     * 2 = Nuevo postulado
     */

    final accion = data['accion'];
    if (accion == 0) {
      const _storage = FlutterSecureStorage();
      final token = await _storage.read(key: 'token');

      // Navigator.pushReplacement(
      //     context,
      // PageRouteBuilder(
      // pageBuilder: (context, __, ___) => ChatPag(
      //     data['servicio'], data['para'], data['nombre'], token),
      // transitionDuration: const Duration(milliseconds: 10)));
    } else if (accion == 1) {
    } else if (accion == 2) {}
  }

  dispose() {
    _mensajeStream.close();
  }
}
