
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/entities.dart';
import 'package:fpdart/fpdart.dart';

abstract class FileEventRepository {
  Stream<Either<Failure, Event>> getEvents();
}
