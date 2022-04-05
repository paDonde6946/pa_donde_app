import 'dart:io';

class EntornoVariable {
  /// HOST DEL SERVIDOR
  static String host = Platform.isAndroid
      ? 'ec2-3-139-6-165.us-east-2.compute.amazonaws.com:3001'
      : 'ec2-3-139-6-165.us-east-2.compute.amazonaws.com:3001';
  // static String host = Platform.isAndroid ? '10.0.2.2:3001' : 'localhost:3001';

  static String socketURL = Platform.isAndroid
      ? 'http://3.139.6.165:3001/'
      : 'http://3.139.6.165:3001/';
}
