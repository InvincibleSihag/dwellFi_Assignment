import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const PieChartWidget({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.blue,
              value: metrics['cpu_usage'].toDouble(),
              title: 'CPU',
              radius: 150,
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: metrics['memory_usage'].toDouble(),
              title: 'Memory',
              radius: 150,
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.green,
              value: metrics['disk_read'].toDouble(),
              title: 'Disk Read',
              radius: 150,
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: metrics['disk_write'].toDouble(),
              title: 'Disk Write',
              radius: 150,
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.purple,
              value: metrics['network_in'].toDouble(),
              title: 'Network In',
              radius: 150,
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.teal,
              value: metrics['network_out'].toDouble(),
              title: 'Network Out',
              radius: 150,
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          startDegreeOffset: -90,
        ),
      ),
    );
  }
}
