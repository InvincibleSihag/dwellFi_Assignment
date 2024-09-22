import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_event.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/material.dart';

class FileFilters extends StatelessWidget {
  const FileFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          hint: const Text('File Type'),
          items: ['Type1', 'Type2'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            serviceLocator<HomeBloc>().add(FilterFilesEvent(fileType: value, date: null, sensorType: null));
          },
        ),
        // Add more filters for date and sensor type similarly
      ],
    );
  }
}
