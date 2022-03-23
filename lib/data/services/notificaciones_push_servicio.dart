// import 'dart:async';
// import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';

class ServicioPushNotificacion {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   final _mensajesStreamControl = StreamController<String>.broadcast();
//   Stream<String> get mensajesStram => _mensajesStreamControl.stream;
//   late BuildContext context;

//   static Future<dynamic> onBackgroundMessage(
//       Map<String, dynamic> message) async {
//     print(
//         '===================================== onMensaje ====================================');
//     print(message);

//     if (message.containsKey('data')) {
//       // Handle data message
//       final dynamic data = message['data'];
//     }

//     if (message.containsKey('notification')) {
//       // Handle notification message
//       final dynamic notification = message['notification'];
//     }
//   }

  initNotifications(BuildContext pContext) async {
//     this.context = pContext;
//     await _firebaseMessaging.requestNotificationPermissions();
//     final token = await _firebaseMessaging.getToken();
//     print('===== Token ====');
//     print(token);

//     _firebaseMessaging.configure(
//       onMessage: Platform.isIOS ? null : onMessage,
//       onBackgroundMessage: Platform.isIOS ? null : onBackgroundMessage,
//       onLaunch: Platform.isIOS ? null : onLaunch,
//       onResume: Platform.isIOS ? null : onResume,
//     );
  }

//   Future<dynamic> onMessage(Map<String, dynamic> menssage) async {
//     print(
//         '===================================== onMensaje ====================================');
//     print(menssage['data']);

//     final argumento = menssage['data']['para'];
//     _mensajesStreamControl.sink.add(argumento);
//   }

//   Future<dynamic> onLaunch(Map<String, dynamic> menssage) async {
//     print(
//         '===================================== onLaunch ================================================================');
//     print(menssage['data']);

//     final argumento = menssage['data']['para'];
//     _mensajesStreamControl.sink.add(argumento);
//   }

//   Future<dynamic> onResume(Map<String, dynamic> menssage) async {
//     print(
//         '===================================== onResume ====================================');
//     print(menssage['data']);

//     final argumento = menssage['data']['para'];
//     _mensajesStreamControl.sink.add(argumento);
//   }

//   void validador(data) async {
//     /**
//      * 0 = Chat
//      * 1 = Aceptacion Servicio
//      * 2 = Nuevo postulado
//      */

//     final accion = data['accion'];
//     String argumento = '';
//     if (accion == 0) {
//       argumento = 'chat';
//     } else if (accion == 1) {
//     } else if (accion == 2) {}
//     _mensajesStreamControl.sink.add(argumento);
//   }

//   dispose() {
//     _mensajesStreamControl?.close();
//   }
}
