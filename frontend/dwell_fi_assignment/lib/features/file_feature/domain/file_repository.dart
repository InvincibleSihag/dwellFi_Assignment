
import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class FileRepository {
  Future<Either<Failure, List<File>>> getFiles();
  Future<Either<Failure, File>> getFileById(int fileId);
}
