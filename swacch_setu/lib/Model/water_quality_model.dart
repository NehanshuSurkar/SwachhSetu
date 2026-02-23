import 'dart:ui';

import 'package:flutter/material.dart';

class WaterQualityRequest {
  final double ph;
  final double tds;
  final double turbidity;
  final double temperature;
  final String source;

  WaterQualityRequest({
    required this.ph,
    required this.tds,
    required this.turbidity,
    required this.temperature,
    required this.source,
  });

  Map<String, dynamic> toJson() {
    return {
      'ph': ph,
      'tds': tds,
      'turbidity': turbidity,
      'temperature': temperature,
      'source': source,
    };
  }
}

class WaterQualityResponse {
  final String status;
  final List<String> alerts;
  final DateTime timestamp;
  final double ph;
  final double tds;
  final double turbidity;
  final double temperature;

  WaterQualityResponse({
    required this.status,
    required this.alerts,
    required this.timestamp,
    required this.ph,
    required this.tds,
    required this.turbidity,
    required this.temperature,
  });

  factory WaterQualityResponse.fromJson(Map<String, dynamic> json) {
    return WaterQualityResponse(
      status: json['status'],
      alerts: List<String>.from(json['alerts']),
      timestamp: DateTime.parse(json['timestamp']),
      ph: json['ph'].toDouble(),
      tds: json['tds'].toDouble(),
      turbidity: json['turbidity'].toDouble(),
      temperature: json['temperature'].toDouble(),
    );
  }

  Color get statusColor {
    switch (status) {
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
}

class HistoryRecord {
  final int id;
  final DateTime timestamp;
  final double phLevel;
  final double tdsLevel;
  final double turbidityLevel;
  final double temperature;
  final String source;
  final String status;
  final String alerts;

  HistoryRecord({
    required this.id,
    required this.timestamp,
    required this.phLevel,
    required this.tdsLevel,
    required this.turbidityLevel,
    required this.temperature,
    required this.source,
    required this.status,
    required this.alerts,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      phLevel: json['ph_level'].toDouble(),
      tdsLevel: json['tds_level'].toDouble(),
      turbidityLevel: json['turbidity_level'].toDouble(),
      temperature: json['temperature'].toDouble(),
      source: json['source'],
      status: json['status'],
      alerts: json['alerts'],
    );
  }
}
