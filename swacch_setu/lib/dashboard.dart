// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final DateTime _lastUpdated = DateTime.now();

//   // Water quality parameters
//   final double _phLevel = 7.2;
//   final double _turbidity = 1.8;
//   final double _tds = 245;
//   final double _temperature = 24.5;

//   String get _waterStatus {
//     if (_phLevel >= 6.5 && _phLevel <= 8.5 && _turbidity < 2.0 && _tds < 300) {
//       return 'Safe';
//     } else if (_phLevel >= 6.0 &&
//         _phLevel <= 9.0 &&
//         _turbidity < 3.0 &&
//         _tds < 500) {
//       return 'Moderate';
//     } else {
//       return 'Unsafe';
//     }
//   }

//   Color get _statusColor {
//     switch (_waterStatus) {
//       case 'Safe':
//         return const Color(0xFF00A86B);
//       case 'Moderate':
//         return const Color(0xFFFFA000);
//       case 'Unsafe':
//         return const Color(0xFFE74C3C);
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             await Future.delayed(const Duration(seconds: 1));
//           },
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 // Main Status Card
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [_statusColor.withOpacity(0.7), _statusColor],
//                     ),
//                     borderRadius: BorderRadius.circular(25),
//                     boxShadow: [
//                       BoxShadow(
//                         color: _statusColor.withOpacity(0.3),
//                         blurRadius: 15,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Water Quality',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 6,
//                                   height: 6,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   _waterStatus,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           const Icon(
//                             Icons.water_drop_rounded,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                           const SizedBox(width: 10),
//                           Text(
//                             '${_phLevel.toStringAsFixed(1)} pH',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 36,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildStatusIndicator(
//                             icon: Icons.thermostat_rounded,
//                             label: 'Temperature',
//                             value: '${_temperature.toStringAsFixed(1)}°C',
//                           ),
//                           _buildStatusIndicator(
//                             icon: Icons.water_drop_rounded,
//                             label: 'TDS',
//                             value: '${_tds.toStringAsFixed(0)} ppm',
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Last Updated
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.access_time_rounded,
//                         size: 14,
//                         color: Colors.grey.shade500,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         'Last updated: ${DateFormat('hh:mm a').format(_lastUpdated)}',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // Water Parameters Grid
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 15,
//                   childAspectRatio: 0.9,
//                   children: [
//                     _buildParameterCard(
//                       title: 'pH Level',
//                       value: _phLevel.toStringAsFixed(1),
//                       unit: 'pH',
//                       icon: Icons.science_rounded,
//                       color: const Color(0xFF00A8E8),
//                       minValue: 0,
//                       maxValue: 14,
//                       currentValue: _phLevel,
//                       status:
//                           _phLevel >= 6.5 && _phLevel <= 8.5
//                               ? 'Optimal'
//                               : 'Warning',
//                     ),
//                     _buildParameterCard(
//                       title: 'Turbidity',
//                       value: _turbidity.toStringAsFixed(1),
//                       unit: 'NTU',
//                       icon: Icons.water_rounded,
//                       color: const Color(0xFF40E0D0),
//                       minValue: 0,
//                       maxValue: 5,
//                       currentValue: _turbidity,
//                       status: _turbidity < 2.0 ? 'Clear' : 'Cloudy',
//                     ),
//                     _buildParameterCard(
//                       title: 'TDS',
//                       value: _tds.toStringAsFixed(0),
//                       unit: 'ppm',
//                       icon: Icons.grain_rounded,
//                       color: const Color(0xFF0077BE),
//                       minValue: 0,
//                       maxValue: 500,
//                       currentValue: _tds / 100, // Scale for gauge
//                       status: _tds < 300 ? 'Good' : 'High',
//                     ),
//                     _buildParameterCard(
//                       title: 'Temperature',
//                       value: _temperature.toStringAsFixed(1),
//                       unit: '°C',
//                       icon: Icons.thermostat_rounded,
//                       color: const Color(0xFFFF6B6B),
//                       minValue: 0,
//                       maxValue: 40,
//                       currentValue: _temperature,
//                       status: _temperature > 25 ? 'Warm' : 'Normal',
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // Source Selection
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.03),
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildSourceButton(
//                           icon: Icons.water_drop_rounded,
//                           label: 'Tank',
//                           isSelected: true,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildSourceButton(
//                           icon: Icons.tapas_rounded,
//                           label: 'Tap',
//                           isSelected: false,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusIndicator({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.white70, size: 16),
//         const SizedBox(width: 6),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(color: Colors.white70, fontSize: 10),
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildParameterCard({
//     required String title,
//     required String value,
//     required String unit,
//     required IconData icon,
//     required Color color,
//     required double minValue,
//     required double maxValue,
//     required double currentValue,
//     required String status,
//   }) {
//     double percentage = (currentValue - minValue) / (maxValue - minValue);
//     percentage = percentage.clamp(0.0, 1.0);

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: color, size: 18),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color:
//                       status == 'Optimal' ||
//                               status == 'Clear' ||
//                               status == 'Good' ||
//                               status == 'Normal'
//                           ? const Color(0xFF00A86B).withOpacity(0.1)
//                           : const Color(0xFFFFA000).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color:
//                         status == 'Optimal' ||
//                                 status == 'Clear' ||
//                                 status == 'Good' ||
//                                 status == 'Normal'
//                             ? const Color(0xFF00A86B)
//                             : const Color(0xFFFFA000),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Text(
//             title,
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 5),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(width: 2),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 3),
//                 child: Text(
//                   unit,
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           // Mini progress bar
//           ClipRRect(
//             borderRadius: BorderRadius.circular(3),
//             child: LinearProgressIndicator(
//               value: percentage,
//               backgroundColor: color.withOpacity(0.2),
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//               minHeight: 4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSourceButton({
//     required IconData icon,
//     required String label,
//     required bool isSelected,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color:
//             isSelected
//                 ? const Color(0xFF00A8E8).withOpacity(0.1)
//                 : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected ? const Color(0xFF00A8E8) : Colors.grey.shade300,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? const Color(0xFF00A8E8) : Colors.grey,
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? const Color(0xFF00A8E8) : Colors.grey,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swacch_setu/Model/water_quality_model.dart';
import 'package:swacch_setu/Services/api_service.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  late DateTime _lastUpdated;

  // Water quality parameters
  double _phLevel = 7.2;
  double _turbidity = 1.8;
  double _tds = 245;
  double _temperature = 24.5;
  String _selectedSource = 'tank';
  String _waterStatus = 'Safe';
  List<String> _alerts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _lastUpdated = DateTime.now();
    _fetchLatestReading();
  }

  Future<void> _fetchLatestReading() async {
    setState(() => _isLoading = true);

    try {
      final latest = await _apiService.getLatestReading();
      if (latest != null) {
        setState(() {
          _phLevel = latest.phLevel;
          _tds = latest.tdsLevel;
          _turbidity = latest.turbidityLevel;
          _temperature = latest.temperature;
          _waterStatus = latest.status;
          _lastUpdated = latest.timestamp;
        });
      }
    } catch (e) {
      print('Error fetching latest reading: $e');
      // Keep using mock data if API fails
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkWaterQuality() async {
    setState(() => _isLoading = true);

    try {
      // Generate random values within realistic ranges
      final random = Random();

      // pH: between 4.0 and 10.0 (acidic to alkaline)
      final randomPh = 4.0 + random.nextDouble() * 6.0;

      // TDS: between 100 and 800 ppm
      final randomTds = 100 + random.nextDouble() * 700;

      // Turbidity: between 0.5 and 10.0 NTU
      final randomTurbidity = 0.5 + random.nextDouble() * 9.5;

      // Temperature: between 10 and 40°C
      final randomTemperature = 10 + random.nextDouble() * 30;

      // Update UI with random values immediately
      setState(() {
        _phLevel = randomPh;
        _tds = randomTds;
        _turbidity = randomTurbidity;
        _temperature = randomTemperature;
      });

      final request = WaterQualityRequest(
        ph: _phLevel,
        tds: _tds,
        turbidity: _turbidity,
        temperature: _temperature,
        source: _selectedSource,
      );

      print('Sending request: ${request.toJson()}'); // Debug print

      final response = await _apiService.checkWaterQuality(request);

      setState(() {
        _waterStatus = response.status;
        _alerts = response.alerts;
        _lastUpdated = response.timestamp;
      });

      print('Response: ${response.status} - ${response.alerts}'); // Debug print

      // Show alerts if any
      if (_alerts.isNotEmpty) {
        _showAlertsDialog();
      }
    } catch (e) {
      print('Error in check water quality: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _checkWaterQuality() async {
  //   setState(() => _isLoading = true);

  //   try {
  //     final request = WaterQualityRequest(
  //       ph: _phLevel,
  //       tds: _tds,
  //       turbidity: _turbidity,
  //       temperature: _temperature,
  //       source: _selectedSource,
  //     );

  //     final response = await _apiService.checkWaterQuality(request);

  //     setState(() {
  //       _waterStatus = response.status;
  //       _alerts = response.alerts;
  //       _lastUpdated = response.timestamp;
  //     });

  //     // Show alerts if any
  //     if (_alerts.isNotEmpty) {
  //       _showAlertsDialog();
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error: $e')));
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  void _showAlertsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Water Quality Alerts'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  _alerts
                      .map(
                        (alert) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(alert)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Color get _statusColor {
    switch (_waterStatus) {
      case 'Safe':
        return const Color(0xFF00A86B);
      case 'Moderate':
        return const Color(0xFFFFA000);
      case 'Unsafe':
        return const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchLatestReading,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Main Status Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_statusColor.withOpacity(0.7), _statusColor],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: _statusColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Water Quality',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _waterStatus,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.water_drop_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${_phLevel.toStringAsFixed(1)} pH',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatusIndicator(
                                icon: Icons.thermostat_rounded,
                                label: 'Temperature',
                                value: '${_temperature.toStringAsFixed(1)}°C',
                              ),
                              _buildStatusIndicator(
                                icon: Icons.water_drop_rounded,
                                label: 'TDS',
                                value: '${_tds.toStringAsFixed(0)} ppm',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Last Updated with Check Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Last updated: ${DateFormat('hh:mm a').format(_lastUpdated)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _checkWaterQuality,
                          icon: const Icon(Icons.science_rounded, size: 16),
                          label: Text(_isLoading ? 'Checking...' : 'Check Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A8E8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Water Parameters Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.9,
                      children: [
                        _buildParameterCard(
                          title: 'pH Level',
                          value: _phLevel.toStringAsFixed(1),
                          unit: 'pH',
                          icon: Icons.science_rounded,
                          color: const Color(0xFF00A8E8),
                          status:
                              _phLevel >= 6.5 && _phLevel <= 8.5
                                  ? 'Optimal'
                                  : 'Warning',
                        ),
                        _buildParameterCard(
                          title: 'Turbidity',
                          value: _turbidity.toStringAsFixed(1),
                          unit: 'NTU',
                          icon: Icons.water_rounded,
                          color: const Color(0xFF40E0D0),
                          status: _turbidity < 2.0 ? 'Clear' : 'Cloudy',
                        ),
                        _buildParameterCard(
                          title: 'TDS',
                          value: _tds.toStringAsFixed(0),
                          unit: 'ppm',
                          icon: Icons.grain_rounded,
                          color: const Color(0xFF0077BE),
                          status: _tds < 300 ? 'Good' : 'High',
                        ),
                        _buildParameterCard(
                          title: 'Temperature',
                          value: _temperature.toStringAsFixed(1),
                          unit: '°C',
                          icon: Icons.thermostat_rounded,
                          color: const Color(0xFFFF6B6B),
                          status: _temperature > 25 ? 'Warm' : 'Normal',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Source Selection
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Water Source',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSourceButton(
                                  icon: Icons.water_drop_rounded,
                                  label: 'Tank',
                                  isSelected: _selectedSource == 'tank',
                                  onTap: () {
                                    setState(() => _selectedSource = 'tank');
                                    _fetchLatestReading();
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSourceButton(
                                  icon: Icons.tapas_rounded,
                                  label: 'Tap',
                                  isSelected: _selectedSource == 'tap',
                                  onTap: () {
                                    setState(() => _selectedSource = 'tap');
                                    _fetchLatestReading();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParameterCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      status == 'Optimal' ||
                              status == 'Clear' ||
                              status == 'Good' ||
                              status == 'Normal'
                          ? const Color(0xFF00A86B).withOpacity(0.1)
                          : const Color(0xFFFFA000).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color:
                        status == 'Optimal' ||
                                status == 'Clear' ||
                                status == 'Good' ||
                                status == 'Normal'
                            ? const Color(0xFF00A86B)
                            : const Color(0xFFFFA000),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF00A8E8).withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00A8E8) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00A8E8) : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF00A8E8) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
