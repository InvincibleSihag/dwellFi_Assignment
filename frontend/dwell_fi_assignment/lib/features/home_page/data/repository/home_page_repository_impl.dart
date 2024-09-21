import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/entities/file.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/repository/home_page_repository.dart';
import 'package:fpdart/fpdart.dart';

class HomePageRepositoryImpl extends HomePageRepository {
  @override
  Future<Either<Failure, List<File>>> getFiles() async {
    // Mock data for now
    final files = [
      File(name: 'File1', uploadDate: DateTime.now(), fileType: 'Type1', sensorType: 'Sensor1'),
      File(name: 'File2', uploadDate: DateTime.now().subtract(const Duration(days: 1)), fileType: 'Type2', sensorType: 'Sensor2'),
    ];
    return right(files);
  }
}
