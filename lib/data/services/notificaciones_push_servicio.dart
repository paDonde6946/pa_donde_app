import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';

class ServicioPushNotificacion {
  static final StreamController<dynamic> _mensajeStream =
      StreamController.broadcast();
  static Stream<dynamic> get mensajeStream => _mensajeStream.stream;
  late BuildContext context;
  final GlobalKey<NavigatorState>? navigatorKey;

  ServicioPushNotificacion({required this.context, this.navigatorKey}) {}
  static Future<dynamic> onBackgroundMessage(RemoteMessage mensaje) async {
    Map<String, dynamic> message = mensaje.data;
    print(
        '===================================== onMensaje ====================================');
    print(message);
    _mensajeStream.sink.add(mensaje.data);
  }

  Future<String> initNotifications() async {
    await Firebase.initializeApp();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(onLaunch);
    return token!;
  }

  Future<dynamic> onLaunch(RemoteMessage mensaje) async {
    print('=============================== ON LAUNCH ========================');
    print(mensaje.data);

    _showNotificationWithSound(
        mensaje.notification!.title, mensaje.notification!.body, mensaje.data);

    // _mensajeStream.sink.add(mensaje.data);
  }

  Future _showNotificationWithSound(titulo, mensaje, data) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: accion);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      titulo,
      mensaje,
      platformChannelSpecifics,
      payload: jsonEncode(data),
    );
  }

  accion(dynamic data) async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    data = jsonDecode(data);
    navigatorKey!.currentState?.push(navegarMapaFadeIn(
        context,
        ChatPag(
            servicio: data["servicio"],
            para: data["para"],
            nombre: data["nombre"],
            token: token)));
  }

  dispose() {
    _mensajeStream.close();
  }
}
