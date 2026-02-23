enum AlertSeverity { low, medium, high }

class AlertModel {
  final String title;
  final String description;
  final DateTime time;
  final AlertSeverity severity;
  final String parameter;

  AlertModel({
    required this.title,
    required this.description,
    required this.time,
    required this.severity,
    required this.parameter,
  });
}

class WaterQualityRecord {
  final DateTime date;
  final double tankPh;
  final double tankTds;
  final double tapPh;
  final double tapTds;

  WaterQualityRecord({
    required this.date,
    required this.tankPh,
    required this.tankTds,
    required this.tapPh,
    required this.tapTds,
  });
}
