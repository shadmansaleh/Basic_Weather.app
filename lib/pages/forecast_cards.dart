import 'package:basic_weather/utils/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherForecast extends StatelessWidget {
  const WeatherForecast({
    super.key,
    required this.forecastData,
  });

  final List<ForecastData> forecastData;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: forecastData
              .map((data) => WeatherForecastSmallCard(forecastData: data))
              .toList(),
        ),
      ),
    );
  }
}

// small blocks for showing future forecast
class WeatherForecastSmallCard extends StatelessWidget {
  const WeatherForecastSmallCard({super.key, required this.forecastData});

  final ForecastData forecastData;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              DateFormat.j().format(forecastData.date),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Icon(forecastData.weatherState.icon, size: 40, color: Colors.white),
            const SizedBox(height: 4),
            Text("${forecastData.temp.toString()}°C"),
          ],
        ),
      ),
    );
  }
}

// small blocks for additional information
class AdditionalInfoCard extends StatelessWidget {
  const AdditionalInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
