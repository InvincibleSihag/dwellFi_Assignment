import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

abstract class HomePageRepository {
  Future<Either<Failure, dynamic>> getFiles();
  Future<Either<Failure, File>> uploadFile(PlatformFile platformFile);
}
