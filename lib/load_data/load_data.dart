import 'dart:convert';

import 'package:http/http.dart' as http;

class LoadData {
  static const baseURL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;
  LoadData(this.apiKey);

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$baseURL/weather?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      return jsonBody;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getForecast(String cityName) async {
    final response = await http.get(Uri.parse('$baseURL/forecast?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      return jsonBody;
    } else {
      throw Exception('Failed to load data');
    }
  }
}