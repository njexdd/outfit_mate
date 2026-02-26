import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiToken = '';
  static const String _baseUrl = 'https://api.gismeteo.net/v4/weather';

  static const String _cacheKey = 'cached_weather_json';
  static const String _timeKey = 'cached_weather_time';
  static const String _cityKey = 'cached_city_name';

  Future<WeatherForecast> getWeather(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedCity = prefs.getString(_cityKey);
    final lastUpdateStr = prefs.getString(_timeKey);

    if (cachedCity == city && lastUpdateStr != null) {
      final lastUpdate = DateTime.parse(lastUpdateStr);
      final difference = DateTime.now().difference(lastUpdate);

      if (difference.inHours < 6) {
        final jsonStr = prefs.getString(_cacheKey);
        if (jsonStr != null) {
          print(
            " Используем данные из кэша (обновлены ${difference.inMinutes} мин. назад)",
          );
          final data = jsonDecode(jsonStr);
          return WeatherForecast.fromJson(data);
        }
      }
    }

    return _fetchFromApi(city, prefs);
  }

  Future<WeatherForecast> _fetchFromApi(
    String city,
    SharedPreferences prefs,
  ) async {
    print(" Запрос к API Gismeteo...");
    final url = Uri.parse(
      '$_baseUrl/forecast/h1?name=$city&locale=ru-BY&days=1',
    );

    final response = await http.get(
      url,
      headers: {'X-Gismeteo-Token': _apiToken},
    );

    if (response.statusCode == 200) {
      final body = response.body;

      await prefs.setString(_cacheKey, body);
      await prefs.setString(_timeKey, DateTime.now().toIso8601String());
      await prefs.setString(_cityKey, city);

      final data = jsonDecode(body);
      return WeatherForecast.fromJson(data);
    } else {
      print("Ошибка API: ${response.statusCode}");
      throw Exception('Ошибка загрузки погоды: ${response.statusCode}');
    }
  }
}
