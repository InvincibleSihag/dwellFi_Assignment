import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_repository.dart';
import 'package:fpdart/fpdart.dart';

class FileRepositoryImpl extends FileRepository {
  @override
  Future<Either<Failure, List<File>>> getFiles() async {
    return right([]);
  }

  @override
  Future<Either<Failure, File>> getFileById(int id) async {
    // Implement the logic to fetch a file by its ID
    // For now, return a dummy file
    return right(File(
      filename: 'example.json',
      size: 1234,
      type: 'sensor',
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      metaData: const {
              "server_id": "server_001",
              "server_name": "web-server-01",
              "location": "data-center-1",
              "metrics": [
                {
                  "timestamp": "2024-09-19T10:00:00Z",
                  "cpu_usage": 30,
                  "memory_usage": 60,
                  "disk_read": 150,
                  "disk_write": 200,
                  "network_in": 500,
                  "network_out": 300,
                  "response_time": 120
                },
                {
                  "timestamp": "2024-09-19T10:20:00Z",
                  "cpu_usage": 35,
                  "memory_usage": 62,
                  "disk_read": 160,
                  "disk_write": 210,
                  "network_in": 520,
                  "network_out": 310,
                  "response_time": 130
                },
                {
                  "timestamp": "2024-09-19T10:45:00Z",
                  "cpu_usage": 40,
                  "memory_usage": 65,
                  "disk_read": 155,
                  "disk_write": 215,
                  "network_in": 530,
                  "network_out": 320,
                  "response_time": 125
                },
            ]
            }
    ));
  }
}
