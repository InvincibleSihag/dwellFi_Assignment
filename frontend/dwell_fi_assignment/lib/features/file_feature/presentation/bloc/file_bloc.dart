import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/socket/socket_service.dart';
import 'package:dwell_fi_assignment/features/file_feature/data/file_event_repository_impl.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_event_repository.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_event.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_state.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_repository.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileRepository fileRepository;
  late FileEventRepository fileEventRepository;
  final int fileId;

  FileBloc(this.fileRepository, this.fileId) : super(FileInitial()) {
    fileEventRepository =
        FileEventRepositoryImpl(serviceLocator<SocketService>(), fileId);
    on<LoadFile>(_onLoadFile);
    on<UpdateFile>(_onUpdateFile);
  }

  void _onLoadFile(LoadFile event, Emitter<FileState> emit) async {
    emit(FileLoading());
    try {
      final file = await fileRepository.getFileById(event.fileId);
      file.fold(
        (l) => emit(FileError(l.message)),
        (r) => emit(FileLoaded(r)),
      );
    } catch (e) {
      emit(FileError(e.toString()));
    }
  }

  void _onUpdateFile(UpdateFile event, Emitter<FileState> emit) async {
    File file = event.file.copyWith(isProcessed: false, taskStatus: 'processing');
    emit(FileLoaded(file));
    try {
      final file = await fileRepository.updateFile(event.file, event.platformFile);
      file.fold(
        (l) => emit(FileError(l.message)),
        (r) => emit(FileLoaded(r)),
      );
    } catch (e) {
      emit(FileError(e.toString()));
    } 
  }
}
