import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:equatable/equatable.dart';
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<File> files;
  final Map<DateTime, int> filesPerDay;

  const HomeLoaded(this.files, this.filesPerDay);

  @override
  List<Object> get props => [files, filesPerDay];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
