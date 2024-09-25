import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/repository/home_page_repository.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_event.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomePageRepository homePageRepository;
  List<File> allFiles = [];

  HomeBloc(this.homePageRepository) : super(HomeInitial()) {
    on<LoadFilesEvent>(_onLoadFiles);
    on<FilterFilesEvent>(_onFilterFiles);
    on<UploadFileEvent>(_onUploadFile);
  }

  void _onLoadFiles(LoadFilesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await homePageRepository.getFiles();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) {
        allFiles = data["files"];
        emit(HomeLoaded(allFiles, data["filesPerDay"]));
      },
    );
  }

  void _onFilterFiles(FilterFilesEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final filteredFiles = event.fileType == null || event.fileType!.isEmpty
          ? allFiles
          : allFiles.where((file) => file.type == event.fileType).toList();
      emit(HomeLoaded(filteredFiles, currentState.filesPerDay));
    }
  }

  void _onUploadFile(UploadFileEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await homePageRepository.uploadFile(event.file);
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (file) => add(LoadFilesEvent()),
    );
  }
}
