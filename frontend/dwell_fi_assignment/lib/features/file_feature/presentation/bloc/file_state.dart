import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:equatable/equatable.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

class FileInitial extends FileState {}

class FileLoading extends FileState {}

class FileLoaded extends FileState {
  final File file;

  const FileLoaded(this.file);

  @override
  List<Object> get props => [file];
}

class FileError extends FileState {
  final String message;

  const FileError(this.message);

  @override
  List<Object> get props => [message];
}
