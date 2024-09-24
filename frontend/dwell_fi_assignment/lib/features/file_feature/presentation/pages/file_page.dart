import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_bloc.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_state.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/bloc/file_event.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/pages/widgets/metrics_line_chart.dart';
import 'package:flutter/material.dart';

class FilePage extends StatelessWidget {
  final int fileId;

  static route(int fileId) =>
    CupertinoPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => FileBloc(serviceLocator(), fileId),
        child: FilePage(fileId: fileId,),
      ),
    );

  const FilePage({super.key, required this.fileId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Page'),
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
            context.read<FileBloc>().add(LoadFile(fileId));
            return const Center(child: CircularProgressIndicator());
          } else if (state is FileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FileLoaded) {
            final file = state.file;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('File Details'),
                  // Display other file details here
                  Expanded(
                    child: MetricsChart(metrics: file.metaData?['metrics'] ?? []),
                  ),
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
}
