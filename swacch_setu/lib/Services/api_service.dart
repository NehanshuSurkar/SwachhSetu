import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swacch_setu/Model/water_quality_model.dart';

class ApiService {
  static const String baseUrl =
      'https://2950-2409-40c2-10-be96-d7b-623f-516d-5e55.ngrok-free.app';

  // Check water quality and store in database
  Future<WaterQualityResponse> checkWaterQuality(
    WaterQualityRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/water-quality/check'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return WaterQualityResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to check water quality: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get water quality history
  Future<List<HistoryRecord>> getWaterHistory({
    String? source,
    int limit = 100,
  }) async {
    try {
      String url = '$baseUrl/api/water-quality/history?limit=$limit';
      if (source != null) {
        url += '&source=$source';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => HistoryRecord.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get latest reading
  Future<HistoryRecord?> getLatestReading() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/water-quality/latest'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('message')) {
          return null;
        }
        return HistoryRecord.fromJson(data);
      } else {
        throw Exception(
          'Failed to load latest reading: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
