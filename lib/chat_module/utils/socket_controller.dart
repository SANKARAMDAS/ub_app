import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../utils/my_urls.dart';

class SocketController {
  // static IO.Socket socket = IO.io(MyUrls.serverUrl, <String, dynamic>{
  //   'transports': ['websocket'],
  // });
 static IO.Socket socket = IO.io(MyUrls.serverUrl,
      IO.OptionBuilder()
       .setTransports(['websocket']).enableForceNewConnection().build());
}
