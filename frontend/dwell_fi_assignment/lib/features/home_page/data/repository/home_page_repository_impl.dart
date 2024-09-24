import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dwell_fi_assignment/core/common/models/file_models.dart';
import 'package:dwell_fi_assignment/core/constants/constants.dart';
import 'package:dwell_fi_assignment/core/error/failures.dart';
import 'package:dwell_fi_assignment/features/home_page/domain/repository/home_page_repository.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

class HomePageRepositoryImpl extends HomePageRepository {
  @override
  Future<Either<Failure, List<File>>> getFiles() async {
    // Mock data for now
    final List<File> files = [
      File(
          filename: 'example1.json',
          size: 1234,
          type: 'sensor',
          id: 1,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
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
              }
            ]
          }),
      File(
          filename: 'example2.json',
          size: 2345,
          type: 'log',
          id: 2,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now(),
          metaData: const {
            "server_id": "server_002",
            "server_name": "web-server-02",
            "location": "data-center-2",
            "metrics": [
              {
                "timestamp": "2024-09-18T10:00:00Z",
                "cpu_usage": 40,
                "memory_usage": 70,
                "disk_read": 250,
                "disk_write": 300,
                "network_in": 600,
                "network_out": 400,
                "response_time": 140
              }
            ]
          }),
      File(
          filename: 'example3.json',
          size: 3456,
          type: 'config',
          id: 3,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          updatedAt: DateTime.now(),
          metaData: const {
            "server_id": "server_003",
            "server_name": "web-server-03",
            "location": "data-center-3",
            "metrics": [
              {
                "timestamp": "2024-09-17T10:00:00Z",
                "cpu_usage": 50,
                "memory_usage": 80,
                "disk_read": 350,
                "disk_write": 400,
                "network_in": 700,
                "network_out": 500,
                "response_time": 160
              }
            ]
          }),
    ];
    try {
      final response = await Dio().get('${backendUrl}files/files/');
      if (response.statusCode == 200) {
        final fileData = response.data;
        // log("File data");
        // log(fileData.toString());

        // final files = fileData.map((e) => File.fromJson(e)).toList();
        List<File> files = [];
        for (var file_data in fileData) {
          files.add(File.fromJson(file_data));
        }
        return right(files);
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
        'files': [
          MultipartFile.fromBytes(platformFile.bytes!,
              filename: platformFile.name)
        ],
        'file_data_create_form':
            '{\n"filename": "${platformFile.name}",\n"type": "server_sensor"\n}'
      });

      var dio = Dio();
      var response = await dio.request(
        'http://127.0.0.1:8000/files/uploadfile/',
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
          createdAt: DateTime.parse(fileData['createdAt']),
          updatedAt: DateTime.parse(fileData['updatedAt']),
          metaData: fileData['metaData'],
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
