import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MetricsChart extends StatelessWidget {
  final List<Map<String, dynamic>> metrics;

  const MetricsChart({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: LineChart(
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
              belowBarData: BarAreaData(show: true, color: Colors.blue.shade50),
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
              belowBarData: BarAreaData(show: true, color: Colors.red.shade50),
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
              belowBarData:
                  BarAreaData(show: true, color: Colors.green.shade50),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 100,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2), // Format the value to one decimal place
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval:
                    36000,
                getTitlesWidget: (value, meta) {
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Text(
                    '${date.hour}:${date.minute.toString().padLeft(2, '0')}', // Format minutes with leading zero
                    style: const TextStyle(
                        fontSize: 10),
                  );
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
      ),
    );
  }
}
