import 'package:flutter/material.dart';

enum WeatherState {
  sunny,
  cloudy,
  rainy,
  snowy,
  thunderstorm,
  foggy,
  windy,
  unknown
}

extension WeatherStateIcon on WeatherState {
  IconData get icon {
    switch (this) {
      case WeatherState.sunny:
        return Icons.wb_sunny;
      case WeatherState.cloudy:
        return Icons.cloud;
      case WeatherState.rainy:
        return Icons.cloudy_snowing;
      case WeatherState.snowy:
        return Icons.ac_unit;
      case WeatherState.thunderstorm:
        return Icons.flash_on;
      case WeatherState.foggy:
        return Icons.blur_on;
      case WeatherState.windy:
        return Icons.air;
      case WeatherState.unknown:
      default:
        return Icons.help_outline;
    }
  }
}

class ForecastData {
  final DateTime date;
  final double temp;
  final WeatherState weatherState;

  ForecastData({
    required this.date,
    required this.temp,
    required this.weatherState,
  });
}

class WeatherData {
  final double temp;
  final WeatherState weatherState;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final List<ForecastData> forecast;

  WeatherData({
    required this.temp,
    required this.weatherState,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.forecast,
  });
}
