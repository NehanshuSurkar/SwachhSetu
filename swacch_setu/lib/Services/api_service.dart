import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swacch_setu/Model/water_quality_model.dart';

class ApiService {
  static const String baseUrl =
      // 'https://a5e0-2409-40c2-10-be96-d7b-623f-516d-5e55.ngrok-free.app';
      'http://172.16.217.102:8000';

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
          'ngrok-skip-browser-warning': 'true',
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
          'ngrok-skip-browser-warning': 'true',
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
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/water-quality/latest'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(const Duration(seconds: 5));

      print('Latest reading response: ${response.statusCode}');
      print('Latest reading body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Check if response contains message (no records)
        // if (data.containsKey('message') || data.containsKey('status')) {
        //   print('No records found in database');
        //   return null;
        // }
        if (data.containsKey('message')) {
          return null;
        }
        return HistoryRecord.fromJson(data);
      } else {
        print('Failed to load latest reading: ${response.statusCode}');
        return null; // Return null instead of throwing
      }
    } catch (e) {
      print('Latest reading error: $e');
      return null; // Return null on error
    }
  }
}
