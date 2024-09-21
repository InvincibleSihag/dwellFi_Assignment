import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileList extends StatelessWidget {
  const FileList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          return ListView.builder(
            itemCount: state.files.length,
            itemBuilder: (context, index) {
              final file = state.files[index];
              return ListTile(
                title: Text(file.name),
                subtitle: Text(file.uploadDate.toString()),
              );
            },
          );
        } else {
          return const Center(child: Text('Failed to load files'));
        }
      },
    );
  }
}
