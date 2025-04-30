import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/item_quantity.dart';

class ItemBarChart extends StatelessWidget {
  final List<ItemQuantity> data;
  final String title;

  const ItemBarChart({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    // Calculate max Y value rounded up to nearest multiple of 20
    final maxY = (data.map((e) => e.quantity).reduce(max) / 20).ceil() * 20.0;
    final barWidth = 35.0;
    final totalWidth = (data.length * (barWidth + 30)) + 100;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      alignment: BarChartAlignment.spaceAround,
                      groupsSpace: 30,
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: false,
                        drawVerticalLine: false,
                      ),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            //Use the name for the X axis
                            // getTitlesWidget:
                            //     (value, meta) => Text(data[value.toInt()].name),

                            //Use the image for the X axis
                            getTitlesWidget: (value, meta) {
                              final imageUrl = data[value.toInt()].imageUrl;
                              return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Image.asset(
                                  imageUrl,
                                  width: 40,
                                  height: 40,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.error_outline),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            reservedSize: 45,
                            getTitlesWidget: (value, meta) {
                              if (value % 20 == 0) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return SizedBox(height: 100);
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ), // Disable right axis
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups:
                          data.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return BarChartGroupData(
                              x: index,
                              barsSpace: 10,
                              barRods: [
                                BarChartRodData(
                                  toY: item.quantity,

                                  color: item.barColor,
                                  width: barWidth,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
