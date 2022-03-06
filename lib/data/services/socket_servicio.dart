import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//------------------IMPORTACIONES LOCALES------------------------------
//---------------------------------------------------------------------

class SocketServicio with ChangeNotifier {
  late IO.Socket _socket;

  IO.Socket get socket => _socket;
  Function get emit => socket.emit;
  final _storage = const FlutterSecureStorage();

  void connect() async {
    final token = await _storage.read(key: 'token');

    // Dart client
    _socket = IO.io('http://localhost:3001/', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket.on('connect', (_) {
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      notifyListeners();
    });
  }

  /// Desconcetar al servidor a traves de un socket
  void disconnect() {
    _socket.disconnect();
  }
}
