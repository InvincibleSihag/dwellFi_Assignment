import 'package:dwell_fi_assignment/core/constants/display.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_bloc.dart';
import 'package:dwell_fi_assignment/features/home_page/presentation/bloc/home_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FileChart extends StatelessWidget {
  const FileChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded && state.filesPerDay.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(64.0),
            child: BarChart(
              BarChartData(
                borderData:
                    FlBorderData(border: Border.all(color: Colors.black)),
                alignment: BarChartAlignment.spaceAround,
                barGroups: state.filesPerDay.entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key.millisecondsSinceEpoch,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        color: Colors.blue,
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final formattedDate = DateFormat('MM/dd').format(date);
                        return Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toString(),
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
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
