import 'dart:developer';

import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String eventName;
  final bool isMajor;

  const Event({this.eventName = "", this.isMajor = false});

  @override
  List<Object> get props => [eventName, isMajor];
}

class FileProcessed extends Event {
  final int statusCode;
  final String statusMessage;
  final File file;

  const FileProcessed({
    super.eventName,
    super.isMajor,
    this.statusCode = 200,
    this.statusMessage = "File processed successfully",
    required this.file,
  });

  @override
  List<Object> get props => super.props..addAll([statusCode, statusMessage, file]);
}

class FileProcessError extends Event {
  final int statusCode;
  final String statusMessage;
  final FileAnomaliesBase fileAnomaly;

  const FileProcessError({
    super.eventName,
    super.isMajor,
    this.statusCode = 400,
    this.statusMessage = "File processing failed",
    required this.fileAnomaly,
  });

  @override
  List<Object> get props => super.props..addAll([statusCode, statusMessage, fileAnomaly]);
}

class Notification extends Event {
  final String userId;
  final String title;
  final String description;

  const Notification({
    super.eventName,
    super.isMajor,
    required this.userId,
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => super.props..addAll([userId, title, description]);

  factory Notification.fromJson(Map<String, dynamic> json) {
    log(json.runtimeType.toString());
    log(json.toString());
    return Notification(
      userId: json["user_id"] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      isMajor: json["is_major"] as bool,
      eventName: json["event_name"] as String,
    );
  }
}

class FileAnomaliesBase extends Equatable {
  final int fileId;
  final String data;

  const FileAnomaliesBase({
    required this.fileId,
    required this.data,
  });

  @override
  List<Object> get props => [fileId, data];
}

