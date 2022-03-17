// ignore: import_of_legacy_library_into_null_safe
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_donde_app/blocs/chat/chat_bloc.dart';
import 'package:pa_donde_app/data/models/mensaje_modelo.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

//------------------IMPORTACIONES LOCALES------------------------------
//---------------------------------------------------------------------

class SocketServicio {
  late IO.Socket _socket;
  // ignore: unused_field
  final _storage = const FlutterSecureStorage();

  IO.Socket get socket => _socket;
  Function get emit => socket.emit;

  BuildContext context;
  Mensaje datosMensaje;
  String token;

  SocketServicio(
      {required this.datosMensaje,
      required this.context,
      required this.token}) {
    // Dart client
    // _socket = IO.io('http://192.168.1.9:3001', {
    _socket = IO.io('http://192.168.71.1:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket.on('connect', (_) {});
    _socket.on('disconnect', (_) => disconnect);
    traerConversacion();

    _socket.on('darConversacion', (data) => almacenarConversacion(data));
  }

  void connect() async {}

  void enviarMensaje(mensaje) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    Mensaje mensajeGuardar = datosMensaje;
    mensajeGuardar.mensaje = mensaje;
    chatBloc.agregarMensajeConversacion(mensajeGuardar);
    _socket.emit('enviarMensaje', mensajeGuardar.toJson());
  }

  void traerConversacion() {
    _socket.emit('traerConversacion', datosMensaje.toJson());
  }

  void recivirMensaje(mensaje) {
    print("Holaaaaaaaaa");
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    Mensaje mensajeRecivido = Mensaje.fromJson(mensaje);
    chatBloc.agregarMensajeConversacion(mensajeRecivido);
  }

  void almacenarConversacion(conversacion) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    List<Mensaje> chat = mensajeFromJson(json.encode(conversacion));
    chatBloc.add(OnCargarChat(chat));
    _socket.on('recivirMensaje', (data) => recivirMensaje(data));
  }

  /// Desconcetar al servidor a traves de un socket
  void disconnect() {
    // final chatBloc = BlocProvider.of<ChatBloc>(context);
    // chatBloc.eliminarConversacion();
    _socket.disconnect();
  }

  void conectar() {
    _socket.emit('conectado', 'hola');
  }
}
