import 'dart:developer';

import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/constants/constants.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

class FileRepositoryImpl extends FileRepository {
  @override
  Future<Either<Failure, List<File>>> getFiles() async {
    return right([]);
  }

  @override
  Future<Either<Failure, File>> getFileById(int id) async {
    try {
      final response = await Dio().get('${backendUrl}files/files/$id/');
      if (response.statusCode == 200) {
        final fileData = response.data;
        // log('File data: $fileData');
        // log('File data type: ${fileData.runtimeType}');
        final file = File(
          filename: fileData['filename'],
          size: fileData['size'],
          type: fileData['type'],
          id: fileData['id'],
          taskStatus: fileData['task_status'],
          isProcessed: fileData['is_processed'],
          createdAt: DateTime.parse(fileData['created_at']),
          updatedAt: DateTime.parse(fileData['updated_at']),
          metaData: fileData['meta_data'],
        );
        log('File: $file');
        return right(file);
      } else {
        return left(Failure('Failed to get file by ID'));
      }
    } catch (e) {
      log("Error getting file by ID");
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
}
