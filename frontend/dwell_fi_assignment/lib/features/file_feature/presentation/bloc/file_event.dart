import 'package:equatable/equatable.dart';

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
