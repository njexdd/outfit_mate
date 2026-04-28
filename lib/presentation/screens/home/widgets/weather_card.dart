import 'package:flutter/material.dart';
import '../../../../data/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherForecast? forecast;
  final VoidCallback onChangeCity;
  final bool isLoading;
  final String? errorMessage;
  final bool isOffline;

  const WeatherCard({
    super.key,
    this.forecast,
    required this.onChangeCity,
    this.isLoading = false,
    this.errorMessage,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF002984)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    forecast?.cityName ?? "Выбор города...",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onChangeCity,
                child: const Text(
                  "Изменить",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),

          if (isOffline)
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded, color: Colors.white70, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Нет интернета · данные из кэша',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Colors.white),
            )
          else if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.white54,
                    size: 56, 
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Нет интернета',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6), 
                  const Text(
                    'Погода недоступна — кэш пуст',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          else if (forecast != null)
            _buildWeatherContent(forecast!.current)
          else
            const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(WeatherHour current) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${current.temp.round()}°C",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Ощущается как ${current.feelsLike.round()}°C",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    current.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const Icon(Icons.cloud, color: Colors.white, size: 80),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _weatherInfoItem(Icons.air, "Ветер", "${current.windSpeed} м/с"),
            _weatherInfoItem(
              Icons.water_drop,
              "Влажность",
              "${current.humidity}%",
            ),
            _weatherInfoItem(
              Icons.thermostat,
              "Давление",
              "${current.pressure}",
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}
