import 'package:dwell_fi_assignment/core/utilities/utils.dart';
import 'package:dwell_fi_assignment/features/file_feature/presentation/pages/file_page.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';
import 'package:flutter/cupertino.dart';
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
                isThreeLine: true,
                leading: const Icon(Icons.file_present),
                title: Text(file.filename),
                subtitle: Text(getDateFormattedText(file.updatedAt)),
                trailing: (file.isProcessed != null && file.isProcessed!)
                    ? Column(
                        children: [
                          const Icon(Icons.check, color: Colors.green),
                          Text(file.taskStatus ?? 'Unknown'),
                        ],
                      )
                    : Column(
                        children: [
                          (file.taskStatus != null &&
                                  file.taskStatus == 'processing')
                              ? const CupertinoActivityIndicator()
                              : const Icon(Icons.info, color: Colors.red),
                          Text(file.taskStatus ?? 'Unknown'),
                        ],
                      ),
                // trailing: (file.isProcessed != null && file.isProcessed!) ? const Icon(Icons.check) : const CupertinoActivityIndicator(),
                onTap: () {
                  if(file.isProcessed != null && file.isProcessed!){
                    Navigator.of(context).push(FilePage.route(file.id, file.filename));
                  }
                },
              );
            },
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Failed to load files'));
        }
      },
    );
  }
}
