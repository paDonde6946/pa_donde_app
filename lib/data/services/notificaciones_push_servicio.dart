import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_donde_app/blocs/blocs.dart';
import 'package:pa_donde_app/data/models/usuario_modelo.dart';
import 'package:pa_donde_app/data/services/servicios_servicio.dart';
import 'package:pa_donde_app/global/enums/acciones_notificaciones_enum.dart';
import 'package:pa_donde_app/ui/helpers/helpers.dart';
import 'package:pa_donde_app/ui/pages/chat_pag.dart';
import 'package:pa_donde_app/ui/pages/detalle_postulado_servicio_pag.dart';
import 'package:pa_donde_app/ui/pages/detalle_tu_servicio_pag.dart';
import 'package:pa_donde_app/ui/pages/inicio_pag.dart';

class ServicioPushNotificacion {
  static final StreamController<dynamic> _mensajeStream =
      StreamController.broadcast();
  static Stream<dynamic> get mensajeStream => _mensajeStream.stream;
  late BuildContext context;
  final GlobalKey<NavigatorState>? navigatorKey;

  ServicioPushNotificacion({required this.context, this.navigatorKey});

  Future<dynamic> onBackgroundMessage(RemoteMessage mensaje) async {
    // print(
    //     '===================================== onMensaje ====================================');
    // print(message);
    _mensajeStream.sink.add(mensaje.data);
    _showNotificationWithSound(
        mensaje.notification!.title, mensaje.notification!.body, mensaje.data);
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
    _showNotificationWithSound(
        mensaje.notification!.title, mensaje.notification!.body, mensaje.data);
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
    /**
     * 0 = Chat
     * 1 = Inicio Servicio
     * 2 = Finalizar Servicio
     * 3 = Cuando se postula
     */
    if (accion == AccionesNotificaciones.chat) {
      notificacionDeChat(data, token);
    } else if (accion == AccionesNotificaciones.iniciarServicio) {
      notificacionInicioServicio(data);
    } else if (accion == AccionesNotificaciones.finalizarServicio) {
      notificaconFinalizaServicio(data);
    } else if (accion == AccionesNotificaciones.postuladosServicio) {
      notificacionNuevoPostulado(data);
    }
  }

  notificacionDeChat(dynamic data, String token) {
    navigatorKey!.currentState?.push(navegarMapaFadeIn(
        context,
        ChatPag(
            servicio: data["servicio"],
            para: data["para"],
            nombre: data["nombre"],
            token: token)));
  }

  notificaconFinalizaServicio(dynamic data) async {
    Usuario usuario = BlocProvider.of<UsuarioBloc>(context).state.usuario;
    usuario.ultimoServicioCalificar = data["servicio"];
    BlocProvider.of<UsuarioBloc>(context).add(OnActualizarUsuario(usuario));

    var serviciosPostulados =
        await ServicioRServicio().darServiciosPostuladosPorUsuario();

    BlocProvider.of<ServicioBloc>(context)
        .add(OnActualizarServiciosPostulados(serviciosPostulados));

    navigatorKey!.currentState?.pushReplacement(PageRouteBuilder(
        pageBuilder: (context, __, ___) => const InicioPag(),
        transitionDuration: const Duration(milliseconds: 10)));
  }

  notificacionInicioServicio(dynamic data) async {
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
  }

  notificacionNuevoPostulado(dynamic data) async {
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

  dispose() {
    _mensajeStream.close();
  }
}
