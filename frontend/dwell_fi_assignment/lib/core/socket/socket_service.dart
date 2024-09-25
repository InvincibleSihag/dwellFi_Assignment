import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

abstract class SocketService {
  void disconnect();
  void send(String event, dynamic data);
  Stream<dynamic> getStream(String eventName);
  Stream<dynamic> getStreamWithFileId(int fileId);
}

class SocketServiceImpl extends SocketService {
  final String url;
  final controller = StreamController<dynamic>.broadcast();
  late WebSocketChannel channel;

  SocketServiceImpl(this.url) {
    channel = WebSocketChannel.connect(Uri.parse(url));

    channel.stream.listen((data) {
      try {
        final parsedData = jsonDecode(data);
        controller.add(parsedData);
      } catch (e) {
        print('Error parsing data: $e');
      }
    }, onError: (error) {
      print('socket error: $error');
    }, onDone: () {
      print('socket disconnected');
    });

    print('socketconnected');
  }

  @override
  void disconnect() {
    channel.sink.close(status.goingAway);
    controller.close();
  }

  @override
  void send(String event, dynamic data) {
    channel.sink.add(data);
  }

  @override
  Stream<dynamic> getStream(String eventName) {
    return controller.stream.where((event) => event["event_name"] == eventName);
  }

  @override
  Stream<dynamic> getStreamWithFileId(int fileId) {
    log('getStreamWithFileId: $fileId');
    return controller.stream.where((event) => event["file_id"] == fileId);
  }
}
