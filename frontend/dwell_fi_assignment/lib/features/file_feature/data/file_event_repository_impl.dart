import 'dart:async';
import 'dart:developer';

import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/entities.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_event_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dwell_fi_assignment/core/socket/socket_service.dart';

class FileEventRepositoryImpl extends FileEventRepository {
  final SocketService _socketService;
  final int fileId;
  final controller = StreamController<Either<Failure, Event>>.broadcast();

  FileEventRepositoryImpl(this._socketService, this.fileId);

  @override
  Stream<Either<Failure, Event>> getEvents() {
    _socketService.getStreamWithFileId(fileId).listen((data) {
      log('Received data: $data'); // Add this line to log the received data
      try {
        final event = _parseEvent(data);
        controller.add(Right(event));
      } catch (e) {
        log('Error parsing event: $e'); // Add this line to log the error
        controller.add(Left(Failure(e.toString())));
      }
    });
    return controller.stream;
  }

  Event _parseEvent(dynamic data) {
    log('Parsing event: $data');
    if (data is! Map<String, dynamic>) {
      throw Exception('Data is not a valid map');
    }
    if (data['event_name'] is! String) {
      throw Exception('event_name is not a String');
    }
    switch (data['event_name']) {
      case 'FileProcessed':
        return FileProcessed(
          eventName: data['event_name'],
          isMajor: data['is_major'] ?? false,
          statusCode: data['status_code'] ?? 200,
          statusMessage: data['status_message'] ?? "File processed successfully",
          file: File.fromJson(data['file']),
        );
      case 'FileProcessError':
        return FileProcessError(
          eventName: data['event_name'],
          isMajor: data['is_major'] ?? false,
          statusCode: data['status_code'] ?? 400,
          statusMessage: data['status_message'] ?? "File processing failed",
          fileAnomaly: FileAnomaliesBase(
            fileId: data['file_anomaly']['file_id'],
            data: data['file_anomaly']['data'],
          ),
        );
      default:
        throw Exception('Unknown event type');
    }
  }
}
