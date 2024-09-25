import 'dart:developer';

import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_event.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_chart.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_filters.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_list.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notification/notification_service.dart';
import '../../../../core/socket/socket_service.dart';
import '../../../file_feature/domain/entities.dart' as file_entities;

class HomePage extends StatefulWidget {
  static route() => CupertinoPageRoute(
        builder: (context) => const HomePage(),
      );

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    serviceLocator<SocketService>().getStream("Notification").listen((onData) {
      log('Notification: $onData');
      file_entities.Notification notification =
          file_entities.Notification.fromJson(onData);
      if (!kIsWeb) {
        serviceLocator<LocalNotificationService>()
            .showNotification(notification.title, notification.description);
      } else {
        serviceLocator<LocalNotificationService>().showCustomNotification(
            _scaffoldKey.currentContext!,
            notification.title,
            notification.description);
      }
      serviceLocator<HomeBloc>().add(LoadFilesEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<HomeBloc>()..add(LoadFilesEvent()),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: const Column(
          children: [
            Expanded(child: FileChart()),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FileFilters(),
            ),
            Expanded(child: FileList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _pickFile(context),
          child: const Icon(Icons.upload_file),
        ),
      ),
    );
  }

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    // log(result.toString());
    if (result != null) {
      PlatformFile file = result.files.first;
      // Dispatch the event to upload the file
      serviceLocator<HomeBloc>().add(UploadFileEvent(file));
    }
  }
}
