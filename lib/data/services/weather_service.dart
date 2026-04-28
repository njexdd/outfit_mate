import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherResult {
  final WeatherForecast forecast;
  final bool isFromCache;   // true → данные из кэша, нет интернета

  const WeatherResult({required this.forecast, required this.isFromCache});
}

class WeatherService {
  static const String _apiToken = '289549dd-d0e5-4e6e-a2b1-7ee28acb5c4a';
  static const String _baseUrl = 'https://api.gismeteo.net/v4/weather';

  static const String _cacheKey = 'cached_weather_json';
  static const String _timeKey = 'cached_weather_time';
  static const String _cityKey = 'cached_city_name';

  Future<WeatherResult> getWeather(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedCity = prefs.getString(_cityKey);
    final lastUpdateStr = prefs.getString(_timeKey);

    // Пробуем свежий кэш (< 6 ч, тот же город)
    if (cachedCity == city && lastUpdateStr != null) {
      final lastUpdate = DateTime.parse(lastUpdateStr);
      final difference = DateTime.now().difference(lastUpdate);

      if (difference.inHours < 6) {
        final jsonStr = prefs.getString(_cacheKey);
        if (jsonStr != null) {
          print('Используем данные из кэша (обновлены ${difference.inMinutes} мин. назад)');
          return WeatherResult(
            forecast: WeatherForecast.fromJson(jsonDecode(jsonStr)),
            isFromCache: false, // кэш свежий — интернет не нужен явно
          );
        }
      }
    }

    // Пробуем API
    return _fetchFromApi(city, prefs);
  }

  Future<WeatherResult> _fetchFromApi(
    String city,
    SharedPreferences prefs,
  ) async {
    print('Запрос к API Gismeteo...');
    final url = Uri.parse(
      '$_baseUrl/forecast/h1?name=$city&locale=ru-BY&days=1',
    );

    try {
      final response = await http
          .get(url, headers: {'X-Gismeteo-Token': _apiToken})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = response.body;
        await prefs.setString(_cacheKey, body);
        await prefs.setString(_timeKey, DateTime.now().toIso8601String());
        await prefs.setString(_cityKey, city);

        return WeatherResult(
          forecast: WeatherForecast.fromJson(jsonDecode(body)),
          isFromCache: false,
        );
      } else {
        print('Ошибка API: ${response.statusCode}');
        throw Exception('Ошибка загрузки погоды: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      // Нет интернета — отдаём устаревший кэш, если он есть
      final jsonStr = prefs.getString(_cacheKey);
      if (jsonStr != null) {
        print('Нет интернета. Используем устаревший кэш.');
        return WeatherResult(
          forecast: WeatherForecast.fromJson(jsonDecode(jsonStr)),
          isFromCache: true,   // <-- сигнализируем UI
        );
      }
      throw Exception('Нет интернета и кэш пуст');
    }
  }
}