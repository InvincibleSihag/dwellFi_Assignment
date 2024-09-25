import 'dart:developer';

import 'package:dwell_fi_assignment/core/notification/notification_service.dart';
import 'package:dwell_fi_assignment/features/file_feature/data/file_event_repository_impl.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/entities.dart';
import 'package:dwell_fi_assignment/features/file_feature/domain/file_event_repository.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_bloc.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_state.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_event.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/pages/widgets/metrics_line_chart.dart';
import 'package:flutter/material.dart';

class FilePage extends StatefulWidget {
  final int fileId;
  final String filename;
  static route(int fileId, String filename) =>
    CupertinoPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => FileBloc(serviceLocator(), fileId),
        child: FilePage(fileId: fileId, filename: filename),
      ),
    );

  const FilePage({super.key, required this.fileId, required this.filename});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {

  late FileEventRepository fileEventRepository;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fileEventRepository = FileEventRepositoryImpl(serviceLocator(), widget.fileId);
    fileEventRepository.getEvents().listen((event) {
      log('Event: $event');
      event.fold((l) { 
        log('Error: $l');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.toString())),
        );
        }, (r) {
          log('Event: $r');
          if(r is FileProcessed){
            if (!kIsWeb) {
                  serviceLocator<LocalNotificationService>()
                      .showNotification(r.eventName, r.statusMessage);
                } else {
                  serviceLocator<LocalNotificationService>().showCustomNotification(
                      _scaffoldKey.currentContext!,
                r.eventName,
                r.statusMessage);
            }
          }
          if(r is FileProcessError){
            if (!kIsWeb) {
                  serviceLocator<LocalNotificationService>()
                      .showNotification(r.eventName, r.statusMessage);
                } else {
                  serviceLocator<LocalNotificationService>().showCustomNotification(
                      _scaffoldKey.currentContext!,
                r.eventName,
                r.statusMessage);
            }
          }
          _scaffoldKey.currentContext!.read<FileBloc>().add(LoadFile(widget.fileId));
        });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('File: ${widget.filename}'),
      ),
      body: BlocConsumer<FileBloc, FileState>(
        listener: (context, state) {
          if (state is FileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is FileInitial) {
            context.read<FileBloc>().add(LoadFile(widget.fileId));
            return const Center(child: CircularProgressIndicator());
          } else if (state is FileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FileLoaded) {
            final file = state.file;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Display other file details here
                  Expanded(
                    child: MetricsChart(metrics: file.metaData?['metrics'].cast<Map<String, dynamic>>() ?? []),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(Colors.blue, 'CPU Usage'),
                      const SizedBox(width: 8),
                      _buildLegendItem(Colors.red, 'Memory Usage'),
                      const SizedBox(width: 8),
                      _buildLegendItem(Colors.green, 'Disk Read'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('File Status: ${file.taskStatus}, Size: ${file.size}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ElevatedButton(onPressed: (){
                  }, child: const Text('Update File'))
                ],
              ),
            );
          } else if (state is FileError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
