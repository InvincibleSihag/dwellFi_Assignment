import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadFilesEvent extends HomeEvent {}

class FilterFilesEvent extends HomeEvent {
  final String? fileType;
  final DateTime? date;
  final String? sensorType;

  const FilterFilesEvent({required this.fileType, required this.date, required this.sensorType});

}
