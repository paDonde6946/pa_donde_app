// ignore: import_of_legacy_library_into_null_safe
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_donde_app/blocs/chat/chat_bloc.dart';
import 'package:pa_donde_app/data/models/mensaje_modelo.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

//------------------IMPORTACIONES LOCALES------------------------------
//---------------------------------------------------------------------

class SocketServicio {
  late IO.Socket _socket;
  final _storage = const FlutterSecureStorage();

  IO.Socket get socket => _socket;
  Function get emit => socket.emit;

  String uidPara;
  String uidServicio;
  BuildContext context;

  SocketServicio(
      {this.uidPara = '', required this.uidServicio, required this.context}) {}

  void connect() async {
    final token = await _storage.read(key: 'token');

    // Dart client
    _socket = IO.io('http://192.168.1.9:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket.on('connect', (_) {});
    _socket.on('disconnect', (_) {});
    traerConversacion();

    socket.on('darConversacion', (data) => almacenarConversacion(data));
  }

  void enviarMensaje(mensaje) {
    var payload = {"servicio": uidServicio, "mensaje": mensaje};
    socket.emit('enviarMensaje', payload);
  }

  void traerConversacion() {
    var payload = {"servicio": uidServicio};
    _socket.emit('traerConversacion', payload);
  }

  void almacenarConversacion(conversacion) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    List<Mensaje> chat = mensajeFromJson(json.encode(conversacion));
    chatBloc.add(OnCargarChat(chat));
  }

  /// Desconcetar al servidor a traves de un socket
  void disconnect() {
    _socket.disconnect();
  }

  void conectar() {
    _socket.emit('conectado', 'hola');
  }
}
