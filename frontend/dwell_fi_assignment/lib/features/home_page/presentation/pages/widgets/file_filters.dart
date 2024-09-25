import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_event.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileFilters extends StatefulWidget {
  const FileFilters({super.key});

  @override
  _FileFiltersState createState() => _FileFiltersState();
}

class _FileFiltersState extends State<FileFilters> {
  String? _selectedFileType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          final fileTypes = state.files.map((file) => file.type).toSet().toList();
          return Row(
            children: [
              DropdownButton<String>(
                hint: const Text('File Type'),
                value: _selectedFileType,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All'),
                  ),
                  ...fileTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFileType = value;
                  });
                  context.read<HomeBloc>().add(FilterFilesEvent(fileType: value));
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
