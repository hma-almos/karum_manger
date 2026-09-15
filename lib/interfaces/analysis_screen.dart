import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:karum_manger/models/accepted.dart';

class AnalyticsView extends StatelessWidget {
  final List<Accepted> acceptedOrders;

  const AnalyticsView({
    Key? key,
    required this.acceptedOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Theme Palette based on design reference
    const primaryColor = Color(0xFF535170);
    const primaryDark = Color(0xFF4A4960);
    const backgroundColor = Color(0xFFEFEFEF);

    // 1. Revenue calculations
    double runningTotal = 0;
    final List<FlSpot> moneySpots = [];
    for (int i = 0; i < acceptedOrders.length; i++) {
      runningTotal += acceptedOrders[i].price;
      moneySpots.add(FlSpot(i.toDouble(), runningTotal));
    }

    // 2. Cities distribution calculation
    final Map<String, int> cityCounts = {};
    for (var item in acceptedOrders) {
      final gov = item.order.governorate;
      cityCounts[gov] = (cityCounts[gov] ?? 0) + 1;
    }
    final List<MapEntry<String, int>> sortedCities = cityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 3. Unique user growth calculation
    final Set<String> uniqueAddresses = {};
    final List<FlSpot> peopleSpots = [];
    for (int i = 0; i < acceptedOrders.length; i++) {
      uniqueAddresses.add(acceptedOrders[i].order.detailedAddress);
      peopleSpots.add(FlSpot(i.toDouble(), uniqueAddresses.length.toDouble()));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildChartCard(
                title: 'الارباح',
                primaryColor: primaryColor,
                borderColor: primaryDark,
                child: moneySpots.isEmpty
                    ? _buildEmptyState()
                    : LineChart(_buildLineChartData(moneySpots, primaryColor)),
              ),
              const SizedBox(height: 24),
              _buildChartCard(
                title: 'المستخدمين',
                primaryColor: primaryColor,
                borderColor: primaryDark,
                child: peopleSpots.isEmpty
                    ? _buildEmptyState()
                    : LineChart(_buildLineChartData(peopleSpots, primaryColor)),
              ),
              const SizedBox(height: 24),
              _buildChartCard(
                title: 'المحافظات الأكثر استخداماً',
                primaryColor: primaryColor,
                borderColor: primaryDark,
                child: sortedCities.isEmpty
                    ? _buildEmptyState()
                    : BarChart(_buildBarChartData(sortedCities, primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required Color primaryColor,
    required Color borderColor,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 12.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              letterSpacing: -0.3,
            ),
          ),
        ),
        Container(
          height: 220,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: borderColor, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  LineChartData _buildLineChartData(List<FlSpot> spots, Color primaryColor) {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => primaryColor,
          tooltipBorderRadius: const BorderRadius.all(Radius.circular(12)) ,        
          ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: primaryColor,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withOpacity(0.2),
                primaryColor.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartData _buildBarChartData(
    List<MapEntry<String, int>> sortedCities,
    Color primaryColor,
  ) {
    return BarChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < sortedCities.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    sortedCities[index].key,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      barGroups: sortedCities
          .asMap()
          .entries
          .map(
            (entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value.toDouble(),
                  color: primaryColor,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'لا توجد بيانات',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}