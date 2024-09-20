import 'package:get/get_connect/http/src/exceptions/exceptions.dart';

class GenericResponseClass {
  final String status;
  final String message;
  final dynamic data;

  GenericResponseClass({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GenericResponseClass.fromJson(Map<String, dynamic> map) {
    switch (map) {
      case {
          'message': String message,
          'status': String status,
          'data': dynamic data,
        }:
        return GenericResponseClass(
          status: status,
          message: message,
          data: data,
        );
      default:
        throw UnexpectedFormat('message');
    }
  }
}
