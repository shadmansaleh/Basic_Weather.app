import 'dart:ui';

import 'package:basic_weather/pages/forecast_cards.dart';
import 'package:basic_weather/utils/data_classes.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
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
              PrimaryWeatherCard(
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
                    Center(
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

class PrimaryWeatherCard extends StatelessWidget {
  const PrimaryWeatherCard(
      {super.key, required this.temp, required this.weatherState});

  final double temp;
  final WeatherState weatherState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 8,
          color: Theme.of(context).splashColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Padding(
                padding: const EdgeInsets.all(40),
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
            ),
          ),
        ),
      ),
    );
  }
}
