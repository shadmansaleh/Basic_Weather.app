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

WeatherState weatherStateFromOpenWeatherString(String state) {
  switch (state.toLowerCase()) {
    case 'sun':
      return WeatherState.sunny;
    case 'clouds':
      return WeatherState.cloudy;
    case 'rain':
      return WeatherState.rainy;
    case 'snow':
      return WeatherState.snowy;
    case 'thunderstorm':
      return WeatherState.thunderstorm;
    case 'fog':
      return WeatherState.foggy;
    case 'wind':
      return WeatherState.windy;
    case 'clear':
      return WeatherState.sunny;
    default:
      return WeatherState.unknown;
  }
}

extension WeatherRaineIcon on WeatherState {
  IconData get icon {
    switch (this) {
      case WeatherState.sunny:
        return Icons.wb_sunny_outlined;
      case WeatherState.cloudy:
        return Icons.cloud_outlined;
      case WeatherState.rainy:
        return Icons.cloudy_snowing;
      case WeatherState.snowy:
        return Icons.ac_unit_outlined;
      case WeatherState.thunderstorm:
        return Icons.flash_on_outlined;
      case WeatherState.foggy:
        return Icons.blur_on_outlined;
      case WeatherState.windy:
        return Icons.air_outlined;
      case WeatherState.unknown:
      default:
        return Icons.help_outline_outlined;
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
  final double feelsLike;
  final String weatherDescription;
  final WeatherState weatherState;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final double visibility;
  final DateTime sunrise;
  final DateTime sunset;
  final bool showSunrise;
  final List<ForecastData> forecast;

  WeatherData({
    required this.temp,
    required this.feelsLike,
    required this.weatherDescription,
    required this.weatherState,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.showSunrise,
    required this.forecast,
  });
}
