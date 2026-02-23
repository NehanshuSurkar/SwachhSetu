import 'package:flutter/material.dart';
import 'package:swacch_setu/Model/alert_system.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<AlertModel> _alerts = [
    AlertModel(
      title: 'High Turbidity Detected',
      description: 'Turbidity levels exceeded safe limit (3.2 NTU)',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      severity: AlertSeverity.high,
      parameter: 'Turbidity',
    ),
    AlertModel(
      title: 'pH Level Unstable',
      description: 'pH reading at 5.8 - below optimal range',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      severity: AlertSeverity.medium,
      parameter: 'pH Level',
    ),
    AlertModel(
      title: 'Temperature Spike',
      description: 'Water temperature increased by 3°C in 1 hour',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      severity: AlertSeverity.low,
      parameter: 'Temperature',
    ),
    AlertModel(
      title: 'TDS Level Warning',
      description: 'TDS approaching maximum limit (480 ppm)',
      time: DateTime.now().subtract(const Duration(days: 1)),
      severity: AlertSeverity.medium,
      parameter: 'TDS',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Alerts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_alerts.length} New',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: _buildAlertCard(alert),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(AlertModel alert) {
    Color severityColor;
    IconData severityIcon;

    switch (alert.severity) {
      case AlertSeverity.high:
        severityColor = const Color(0xFFE74C3C);
        severityIcon = Icons.warning_rounded;
        break;
      case AlertSeverity.medium:
        severityColor = const Color(0xFFFFA000);
        severityIcon = Icons.error_rounded;
        break;
      case AlertSeverity.low:
        severityColor = const Color(0xFF3498DB);
        severityIcon = Icons.info_rounded;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: severityColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: severityColor.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(severityIcon, color: severityColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: severityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              alert.parameter,
                              style: TextStyle(
                                fontSize: 10,
                                color: severityColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alert.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, hh:mm a').format(alert.time),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
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
        ),
      ),
    );
  }
}
