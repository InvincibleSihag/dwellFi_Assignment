import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MetricsChart extends StatelessWidget {
  final List<Map<String, dynamic>> metrics;

  const MetricsChart({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: metrics.map((metric) {
              final timestamp = DateTime.parse(metric['timestamp'])
                  .millisecondsSinceEpoch
                  .toDouble();
              final cpuUsage = metric['cpu_usage'].toDouble();
              return FlSpot(timestamp, cpuUsage);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            belowBarData: BarAreaData(show: true),
          ),
          LineChartBarData(
            spots: metrics.map((metric) {
              final timestamp = DateTime.parse(metric['timestamp'])
                  .millisecondsSinceEpoch
                  .toDouble();
              final memoryUsage = metric['memory_usage'].toDouble();
              return FlSpot(timestamp, memoryUsage);
            }).toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: metrics.map((metric) {
              final timestamp = DateTime.parse(metric['timestamp'])
                  .millisecondsSinceEpoch
                  .toDouble();
              final diskUsage = metric['disk_read'].toDouble();
              return FlSpot(timestamp, diskUsage);
            }).toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text('${date.hour}:${date.minute}');
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        gridData: const FlGridData(show: true),
      ),
    );
  }
}
