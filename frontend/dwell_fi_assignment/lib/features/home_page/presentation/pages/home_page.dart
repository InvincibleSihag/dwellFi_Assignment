import 'dart:developer';

import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_event.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_chart.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_filters.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_list.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static route() =>
    CupertinoPageRoute(
      builder: (context) => const HomePage(),
    );

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Column(
        children: [
          FileChart(),
          FileFilters(),
          Expanded(child: FileList()),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickFile(context),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return const Icon(Icons.upload_file);
          }
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
