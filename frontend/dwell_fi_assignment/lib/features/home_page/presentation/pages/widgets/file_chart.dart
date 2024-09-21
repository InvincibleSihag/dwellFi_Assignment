import 'package:dwell_fi_assignment/core/constants/display.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileChart extends StatelessWidget {
  const FileChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded && state.filesPerDay.isNotEmpty) {
          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              // barGroups: state.files.map((file) {
              //   return BarChartGroupData(
              //     x: file.id,
              //     barRods: [
              //       BarChartRodData(
              //         toY: file.size.toDouble(),
              //         colors: [Colors.blue],
              //       ),
              //     ],
              //   );
              // }).toList(),
              // titlesData: FlTitlesData(
              //   leftTitles: SideTitles(showTitles: true),
              //   bottomTitles: SideTitles(
              //     showTitles: true,
              //     getTitles: (double value) {
              //       return state.files.firstWhere((file) => file.id == value.toInt()).name;
              //     },
              //   ),
              // ),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(xlargePadding),
            child: Text(
              'No Files Uploaded Yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          );
        }
      },
    );
  }
}
