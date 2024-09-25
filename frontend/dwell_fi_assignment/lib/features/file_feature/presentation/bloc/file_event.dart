import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class LoadFile extends FileEvent {
  final int fileId;

  const LoadFile(this.fileId);

  @override
  List<Object> get props => [fileId];
}

class UpdateFile extends FileEvent {
  final File file;
  final PlatformFile platformFile;

  const UpdateFile(this.file, this.platformFile);

  @override
  List<Object> get props => [file, platformFile];
}
