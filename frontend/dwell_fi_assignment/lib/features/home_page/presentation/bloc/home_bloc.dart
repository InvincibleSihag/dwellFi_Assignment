import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/repository/home_page_repository.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_event.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomePageRepository homePageRepository;

  HomeBloc(this.homePageRepository) : super(HomeInitial()) {
    on<LoadFilesEvent>(_onLoadFiles);
    on<FilterFilesEvent>(_onFilterFiles);
  }

  void _onLoadFiles(LoadFilesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await homePageRepository.getFiles();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (files) => emit(HomeLoaded(files, {})),
    );
  }

  void _onFilterFiles(FilterFilesEvent event, Emitter<HomeState> emit) {
    // Implement filtering logic
  }
}
