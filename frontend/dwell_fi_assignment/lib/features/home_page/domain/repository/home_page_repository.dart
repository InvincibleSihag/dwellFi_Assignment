import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/entities/file.dart';
import 'package:fpdart/fpdart.dart';

abstract class HomePageRepository {
  Future<Either<Failure, List<File>>> getFiles();
}

