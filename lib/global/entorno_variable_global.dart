import 'dart:io';

class EntornoVariable {
  static String host = Platform.isAndroid ? '10.0.2.2:3001' : 'localhost:3001';

  // static String socketURL = Platform.isAndroid
  //     ? 'http://10.0.2.2:3001/app/usuarioServicio'
  //     : 'localhost:3001/app/usuarioServicio';
}
