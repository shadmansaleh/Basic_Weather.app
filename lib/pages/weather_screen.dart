import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
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

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherData? _weatherData;

  @override
  void initState() {
    super.initState();
    _weatherData = WeatherData(
      temp: 25,
      weatherState: WeatherState.rainy,
      humidity: 50,
      windSpeed: 10,
      pressure: 1013,
      forecast: [
        ForecastData(
          date: DateTime.now().add(const Duration(hours: 3)),
          temp: 24,
          weatherState: WeatherState.cloudy,
        ),
        ForecastData(
          date: DateTime.now().add(const Duration(hours: 6)),
          temp: 23,
          weatherState: WeatherState.rainy,
        ),
        ForecastData(
          date: DateTime.now().add(const Duration(hours: 9)),
          temp: 12,
          weatherState: WeatherState.snowy,
        ),
        ForecastData(
          date: DateTime.now().add(const Duration(hours: 12)),
          temp: 22,
          weatherState: WeatherState.snowy,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // main card of todays weather
              PrimaryWeatherBlock(
                temp: _weatherData!.temp,
                weatherState: _weatherData!.weatherState,
              ),

              // Weather forecast section
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Weather Forecast",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: WeatherForecast(
                            forecastData: _weatherData!.forecast))
                  ],
                ),
              ),

              // Additional info section
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Additional Information",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AdditionalInfoCard(
                              title: "Humidity",
                              value: "${_weatherData!.humidity}%",
                              icon: Icons.water_drop,
                            ),
                            AdditionalInfoCard(
                              title: "Wind Speed",
                              value: "${_weatherData!.windSpeed} km/h",
                              icon: Icons.air,
                            ),
                            AdditionalInfoCard(
                              title: "Pressure",
                              value: "${_weatherData!.pressure} hPa",
                              icon: Icons.speed,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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

class PrimaryWeatherBlock extends StatelessWidget {
  const PrimaryWeatherBlock(
      {super.key, required this.temp, required this.weatherState});

  final double temp;
  final WeatherState weatherState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Text(
              "${temp.toString()}°C",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Icon(
              weatherState.icon,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              weatherState.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherForecast extends StatelessWidget {
  const WeatherForecast({
    super.key,
    required this.forecastData,
  });

  final List<ForecastData> forecastData;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: forecastData
            .map((data) => WeatherForecastSmallCard(forecastData: data))
            .toList(),
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
              "${forecastData.date.hour}:00",
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
    return Center(
      child: Container(
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
      ),
    );
  }
}
