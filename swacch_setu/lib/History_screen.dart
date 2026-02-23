// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:swacch_setu/Model/alert_system.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   bool _isTankSelected = true;
//   final List<WaterQualityRecord> _records = [];

//   @override
//   void initState() {
//     super.initState();
//     _generateMockData();
//   }

//   void _generateMockData() {
//     final now = DateTime.now();
//     for (int i = 30; i >= 0; i--) {
//       final date = now.subtract(Duration(days: i));
//       _records.add(
//         WaterQualityRecord(
//           date: date,
//           tankPh: 7.0 + (math.Random().nextDouble() * 1.5 - 0.5),
//           tankTds: 200 + (math.Random().nextDouble() * 100 - 50),
//           tapPh: 7.2 + (math.Random().nextDouble() * 1.0 - 0.3),
//           tapTds: 220 + (math.Random().nextDouble() * 80 - 40),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Water Quality Trends',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),
//                   // Toggle Buttons
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildToggleButton(
//                             label: 'Tank Water',
//                             isSelected: _isTankSelected,
//                             onTap: () => setState(() => _isTankSelected = true),
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildToggleButton(
//                             label: 'Tap Water',
//                             isSelected: !_isTankSelected,
//                             onTap:
//                                 () => setState(() => _isTankSelected = false),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Graph
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.03),
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(
//                         show: true,
//                         drawVerticalLine: false,
//                         getDrawingHorizontalLine: (value) {
//                           return FlLine(
//                             color: Colors.grey.shade200,
//                             strokeWidth: 1,
//                           );
//                         },
//                       ),
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 40,
//                             getTitlesWidget: (value, meta) {
//                               return Text(
//                                 value.toInt().toString(),
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 30,
//                             interval: 5,
//                             getTitlesWidget: (value, meta) {
//                               int index = value.toInt();
//                               if (index >= 0 &&
//                                   index < _records.length &&
//                                   index % 5 == 0) {
//                                 return Text(
//                                   DateFormat(
//                                     'dd MMM',
//                                   ).format(_records[index].date),
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 );
//                               }
//                               return const Text('');
//                             },
//                           ),
//                         ),
//                         topTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         rightTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//                       borderData: FlBorderData(
//                         show: true,
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       minX: 0,
//                       maxX: 30,
//                       minY: 0,
//                       maxY: 400,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots:
//                               _records.asMap().entries.map((entry) {
//                                 return FlSpot(
//                                   entry.key.toDouble(),
//                                   _isTankSelected
//                                       ? entry.value.tankPh *
//                                           30 // Scale pH for visibility
//                                       : entry.value.tapPh * 30,
//                                 );
//                               }).toList(),
//                           isCurved: true,
//                           color: const Color(0xFF00A8E8),
//                           barWidth: 3,
//                           isStrokeCapRound: true,
//                           dotData: const FlDotData(show: false),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: const Color(0xFF00A8E8).withOpacity(0.1),
//                           ),
//                         ),
//                         if (!_isTankSelected)
//                           LineChartBarData(
//                             spots:
//                                 _records.asMap().entries.map((entry) {
//                                   return FlSpot(
//                                     entry.key.toDouble(),
//                                     entry.value.tapTds.toDouble(),
//                                   );
//                                 }).toList(),
//                             isCurved: true,
//                             color: const Color(0xFFFF6B6B),
//                             barWidth: 3,
//                             isStrokeCapRound: true,
//                             dotData: const FlDotData(show: false),
//                             belowBarData: BarAreaData(
//                               show: true,
//                               color: const Color(0xFFFF6B6B).withOpacity(0.1),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Legend
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildLegendItem(
//                     color: const Color(0xFF00A8E8),
//                     label: 'pH Level',
//                   ),
//                   const SizedBox(width: 20),
//                   _buildLegendItem(
//                     color: const Color(0xFFFF6B6B),
//                     label: 'TDS (ppm)',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildToggleButton({
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF00A8E8) : Colors.transparent,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey.shade600,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLegendItem({required Color color, required String label}) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:swacch_setu/Model/water_quality_model.dart';
import 'package:swacch_setu/Services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isTankSelected = true;
  List<HistoryRecord> _records = [];
  bool _isLoading = true;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  Future<void> _fetchHistoryData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getWaterHistory(
        source: _isTankSelected ? 'tank' : 'tap',
        limit: 30,
      );

      setState(() {
        _records = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load history: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Water Quality Trends',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  // Toggle Buttons
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildToggleButton(
                            label: 'Tank Water',
                            isSelected: _isTankSelected,
                            onTap: () {
                              setState(() => _isTankSelected = true);
                              _fetchHistoryData();
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildToggleButton(
                            label: 'Tap Water',
                            isSelected: !_isTankSelected,
                            onTap: () {
                              setState(() => _isTankSelected = false);
                              _fetchHistoryData();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Graph or Loading/Error State
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _errorMessage != null
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 48,
                                  color: Colors.red.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading data',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchHistoryData,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                          : _records.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.show_chart_rounded,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No historical data',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.shade200,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= 0 &&
                                          index < _records.length &&
                                          index % 5 == 0) {
                                        return Text(
                                          DateFormat(
                                            'dd MMM',
                                          ).format(_records[index].timestamp),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                        );
                                      }
                                      return const Text('');
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
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              minX: 0,
                              maxX: _records.length.toDouble() - 1,
                              minY: 0,
                              maxY: 400,
                              lineBarsData: [
                                LineChartBarData(
                                  spots:
                                      _records.asMap().entries.map((entry) {
                                        return FlSpot(
                                          entry.key.toDouble(),
                                          _isTankSelected
                                              ? entry.value.phLevel * 30
                                              : entry.value.phLevel * 30,
                                        );
                                      }).toList(),
                                  isCurved: true,
                                  color: const Color(0xFF00A8E8),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: const Color(
                                      0xFF00A8E8,
                                    ).withOpacity(0.1),
                                  ),
                                ),
                                LineChartBarData(
                                  spots:
                                      _records.asMap().entries.map((entry) {
                                        return FlSpot(
                                          entry.key.toDouble(),
                                          entry.value.tdsLevel.toDouble(),
                                        );
                                      }).toList(),
                                  isCurved: true,
                                  color: const Color(0xFFFF6B6B),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: const Color(
                                      0xFFFF6B6B,
                                    ).withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
            ),

            // Legend
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(
                    color: const Color(0xFF00A8E8),
                    label: 'pH Level',
                  ),
                  const SizedBox(width: 20),
                  _buildLegendItem(
                    color: const Color(0xFFFF6B6B),
                    label: 'TDS (ppm)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A8E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
