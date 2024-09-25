import 'dart:convert';
import 'dart:developer';

import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/constants/constants.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_repository.dart';
import 'package:file_picker/file_picker.dart';
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
  
  @override
  Future<Either<Failure, File>> updateFile(File file, PlatformFile platformFile) async {
    log("Updating file");
    try {
      var data = FormData.fromMap({
        'file': [
          MultipartFile.fromBytes(platformFile.bytes!,
              filename: platformFile.name, contentType: DioMediaType.parse("application/json"))
        ],
        'file_update_form':
            '{\n"filename": "${platformFile.name}",\n"type": "server_sensor"\n}'
        // 'file_update_form': json.encode({
        //   'filename': platformFile.name,
        //   'type': file.type,
        //   'task_status': file.taskStatus,
        //   'is_processed': file.isProcessed,
        //   'meta_data': file.metaData,
        // })
      });

      var dio = Dio();
      var response = await dio.request(
        '${backendUrl}files/updatefile/${file.id}',
        options: Options(
          method: 'PUT',
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        final fileData = response.data;
        final file = File(
          filename: fileData['filename'],
          size: fileData['size'],
          type: fileData['type'],
          id: fileData['id'],
          isProcessed: fileData['is_processed'],
          taskStatus: fileData['task_status'],
          createdAt: DateTime.parse(fileData['created_at']),
          updatedAt: DateTime.parse(fileData['updated_at']),
          metaData: fileData['meta_data'],
        );
        return right(file);
      } else {
        return left(Failure('Failed to update file'));
      }
    } catch (e) {
      log("Error updating file");
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }
}
