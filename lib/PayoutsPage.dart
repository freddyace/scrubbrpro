import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PayoutsPage extends StatelessWidget {
  const PayoutsPage({Key? key}) : super(key: key);

  final List<double> mockWeeklyEarnings = const [50.0, 75.0, 100.0, 65.0, 120.0, 90.0, 40.0];

  List<BarChartGroupData> _buildBarGroups(List<double> earnings) {
    return List.generate(earnings.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: earnings[index],
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final barGroups = _buildBarGroups(mockWeeklyEarnings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${mockWeeklyEarnings.reduce((a, b) => a + b).toStringAsFixed(2)} total',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            AspectRatio(
              aspectRatio: 1.4,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 150,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
