import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/main.dart'; // Import to get DailyRecord

class OverviewChart extends StatelessWidget {
  final List<DailyRecord> records;
  const OverviewChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    // Stress line
                    LineChartBarData(
                      spots: records
                          .asMap()
                          .entries
                          .map(
                            (e) => FlSpot(
                          e.key.toDouble(),
                          e.value.stressLevel.toDouble(),
                        ),
                      )
                          .toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),

                    // Sleep line (scaled to 0–10)
                    LineChartBarData(
                      spots: records
                          .asMap()
                          .entries
                          .map(
                            (e) => FlSpot(
                          e.key.toDouble(),
                          e.value.sleepQuality.toDouble() * 5,
                        ),
                      )
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),

                    // Energy line (scaled to 0–10)
                    LineChartBarData(
                      spots: records
                          .asMap()
                          .entries
                          .map(
                            (e) => FlSpot(
                          e.key.toDouble(),
                          e.value.energyLevel.toDouble() * 5,
                        ),
                      )
                          .toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // Fix repeated labels
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < records.length) {
                            final date = records[index].date;
                            // Format to show Day and Date if preferred, e.g., "Mon 15"
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('E').format(date),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 2,
                    verticalInterval: 1,
                  ),
                  borderData: FlBorderData(show: true),
                  minY: 0,
                  maxY: 10,
                  minX: 0,
                  maxX: (records.length > 1 ? records.length - 1 : 1).toDouble(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _LegendItem(color: Colors.red, label: 'Stress'),
                _LegendItem(color: Colors.blue, label: 'Sleep'),
                _LegendItem(color: Colors.green, label: 'Energy'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Daily Overview',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
