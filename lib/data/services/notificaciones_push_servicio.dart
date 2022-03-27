import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';
import 'package:pa_donde_app/ui/pages/detalle_postulado_servicio_pag.dart';
import 'package:pa_donde_app/ui/pages/detalle_servicio_pag.dart';
import 'package:pa_donde_app/ui/pages/detalle_tu_servicio_pag.dart';

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
        '1', 'channel name',
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
    var accion = int.parse(data["accion"]);
    if (accion == 0) {
      navigatorKey!.currentState?.push(navegarMapaFadeIn(
          context,
          ChatPag(
              servicio: data["servicio"],
              para: data["para"],
              nombre: data["nombre"],
              token: token)));
    } else if (accion == 1) {
    } else if (accion == 2) {
      String uidServicio = data["servicio"];
      var serviciosPostulados =
          await ServicioRServicio().darServiciosPostuladosPorUsuario();

      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarServiciosPostulados(serviciosPostulados));

      for (var servicio in serviciosPostulados) {
        if (servicio.uid == uidServicio) {
          BlocProvider.of<ServicioBloc>(context)
              .add(OnServicioSeleccionado(servicio));

          break;
        }
      }

      navigatorKey!.currentState?.push(
        MaterialPageRoute(
            builder: (context) =>
                const DetallePostuladoServicio(callbackFunction: null)),
      );
    } else if (accion == 3) {
      String uidServicio = data["servicio"];
      var serviciosDelUsuario =
          await ServicioRServicio().darServiciosCreadosPorUsuario();

      BlocProvider.of<ServicioBloc>(context)
          .add(OnActualizarServiciosDelUsuario(serviciosDelUsuario));

      for (var servicio in serviciosDelUsuario) {
        if (servicio.uid == uidServicio) {
          BlocProvider.of<ServicioBloc>(context)
              .add(OnServicioSeleccionado(servicio));
          break;
        }
      }

      navigatorKey!.currentState?.push(
        MaterialPageRoute(
            builder: (context) =>
                const DetalleTuServicio(callbackFunction: null)),
      );
    }
  }

  dispose() {
    _mensajeStream.close();
  }
}
