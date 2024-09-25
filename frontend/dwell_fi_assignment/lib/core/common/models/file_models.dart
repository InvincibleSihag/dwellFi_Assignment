import 'package:equatable/equatable.dart';

class File extends FileBase {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdById;
  final String? updatedById;
  final String? taskStatus;
  const File({
    required super.filename,
    required super.size,
    required super.type,
    super.isProcessed,
    super.metaData,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.createdById,
    this.updatedById,
    this.taskStatus,
  });

  @override
  List<Object?> get props => super.props..addAll([id, createdAt, updatedAt, createdById, updatedById]);

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      filename: json['filename'],
      size: json['size'],
      type: json['type'],
      isProcessed: json['is_processed'],
      taskStatus: json['task_status'],
      metaData: json['meta_data'],
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdById: json['created_by_id'],
      updatedById: json['updated_by_id'],
    );
  }

  copyWith({
    String? filename,
    int? size,
    String? type,
    bool? isProcessed,
    String? taskStatus,
    Map<String, dynamic>? metaData,
  }) {
    return File(
      filename: filename ?? this.filename,
      size: size ?? this.size,
      type: type ?? this.type,
      isProcessed: isProcessed ?? this.isProcessed,
      metaData: metaData ?? this.metaData,
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdById: createdById ?? this.createdById,
      updatedById: updatedById ?? this.updatedById,
      taskStatus: taskStatus ?? this.taskStatus,
    );
  }
}

class FileBase extends Equatable {
  final String filename;
  final int? size;
  final String type;
  final bool? isProcessed;
  final Map<String, dynamic>? metaData;

  const FileBase({
    required this.filename,
    required this.size,
    required this.type,
    this.isProcessed = false,
    this.metaData,
  });
  @override
  List<Object?> get props => [filename, size, type, isProcessed, metaData];

}

class FileCreate extends FileBase {
  const FileCreate({
    required super.filename,
    required super.size,
    required super.type,
    super.isProcessed,
    super.metaData,
  });

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'size': size,
      'type': type,
      'is_processed': isProcessed,
      'meta_data': metaData,
    };
  }
}
