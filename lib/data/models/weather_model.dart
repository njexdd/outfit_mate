class WeatherForecast {
  final String cityName;
  final List<WeatherHour> hourly;

  WeatherForecast({required this.cityName, required this.hourly});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final forecast = json['forecast'];

    final times = List<String>.from(forecast['time']);
    final temps = List<num>.from(forecast['temperature_air']);
    final feelsLike = List<num?>.from(forecast['temperature_heat_index']);
    final descriptions = List<String>.from(forecast['description']);
    final icons = List<String>.from(forecast['icon_weather']);
    final winds = List<num?>.from(forecast['wind_speed']);
    final humidity = List<num?>.from(forecast['humidity']);
    final pressure = List<num?>.from(forecast['pressure']);

    List<WeatherHour> hourlyList = [];

    for (int i = 0; i < times.length; i++) {
      hourlyList.add(
        WeatherHour(
          time: DateTime.parse(times[i]),
          temp: temps[i].toDouble(),
          feelsLike: feelsLike[i]?.toDouble() ?? temps[i].toDouble(),
          description: descriptions[i],
          iconCode: icons[i],
          windSpeed: winds[i]?.toDouble() ?? 0.0,
          humidity: humidity[i]?.toInt() ?? 0,
          pressure: pressure[i]?.toInt() ?? 0,
        ),
      );
    }

    return WeatherForecast(
      cityName: location['name'] ?? 'Неизвестно',
      hourly: hourlyList,
    );
  }

  WeatherHour get current {
    final now = DateTime.now().toUtc();
    return hourly.reduce((a, b) {
      final diffA = a.time.difference(now).abs();
      final diffB = b.time.difference(now).abs();
      return diffA < diffB ? a : b;
    });
  }
}

class WeatherHour {
  final DateTime time;
  final double temp;
  final double feelsLike;
  final String description;
  final String iconCode;
  final double windSpeed;
  final int humidity;
  final int pressure;

  WeatherHour({
    required this.time,
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
  });
}
