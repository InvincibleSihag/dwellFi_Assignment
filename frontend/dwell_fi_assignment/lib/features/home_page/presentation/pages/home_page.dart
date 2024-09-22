import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_chart.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_filters.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/pages/widgets/file_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static route() =>
    MaterialPageRoute(
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
    );
  }
}
