import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadFilesEvent extends HomeEvent {}

class FilterFilesEvent extends HomeEvent {
  final String? fileType;

  const FilterFilesEvent({this.fileType});

  @override
  List<Object> get props => [fileType??''];
}

class UploadFileEvent extends HomeEvent {
  final PlatformFile file;

  const UploadFileEvent(this.file);

  @override
  List<Object> get props => [file];
}
