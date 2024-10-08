import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/constants/constants.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/repository/home_page_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

class HomePageRepositoryImpl extends HomePageRepository {
  Map<DateTime, int> filesPerDay = {};

  @override
  Future<Either<Failure, dynamic>> getFiles() async {
    try {
      final response = await Dio().get('${backendUrl}files/files/');
      if (response.statusCode == 200) {
        final fileData = response.data;
        List<File> files = [];
        filesPerDay = {};
        for (var file_data in fileData) {
          File file = File.fromJson(file_data);
          files.add(file);
          DateTime uploadDate = DateTime.parse(file.createdAt.toString());
          DateTime dateOnly =
              DateTime(uploadDate.year, uploadDate.month, uploadDate.day);
          if (filesPerDay.containsKey(dateOnly)) {
            filesPerDay[dateOnly] = filesPerDay[dateOnly]! + 1;
          } else {
            filesPerDay[dateOnly] = 1;
          }
        }
        files.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return right({'files': files, 'filesPerDay': filesPerDay});
      } else {
        return left(Failure('Failed to get files'));
      }
    } catch (e) {
      log("Error getting files");
      log(e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, File>> uploadFile(PlatformFile platformFile) async {
    log("Uploading file");
    try {
      var data = FormData.fromMap({
        'file': [
          MultipartFile.fromBytes(platformFile.bytes!,
              filename: platformFile.name,
              contentType: DioMediaType.parse("application/json"))
        ],
        'file_data_create_form':
            '{\n"filename": "${platformFile.name}",\n"type": "server_metadata"\n}'
      });

      var dio = Dio();
      var response = await dio.request(
        '${backendUrl}files/uploadfile/',
        options: Options(
          method: 'POST',
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      log("Response");
      log(response.data.toString());
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
        return left(Failure('Failed to upload file'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
