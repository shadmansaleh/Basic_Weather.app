import 'dart:convert';
import 'dart:ui';

import 'package:basic_weather/pages/forecast_cards.dart';
import 'package:basic_weather/utils/data_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData? _weatherData;
  Future getCurrentWeather() async {
    final String apiKey = dotenv.env['OPEN_WEATHER_API_KEY'] ?? "";
    const String city = "Chittagong,bd";
    const int count = 8;
    const String unit = "metric";

    final res = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$unit&cnt=$count&APPID=$apiKey"));
    if (res.statusCode != 200) {
      throw "Failed to fetch (res: ${res.statusCode} ${res.body})";
    }

    final data = jsonDecode(res.body);

    final currentData = data["list"][0];
    double temp = currentData['main']['temp'];
    double tempFeelsLike = currentData['main']['feels_like'];
    double humidity = currentData['main']['humidity'].toDouble();
    double pressure = currentData['main']['pressure'].toDouble();
    double windSpeed = currentData['wind']['speed'];
    WeatherState weatherState =
        weatherStateFromOpenWeatherString(currentData['weather'][0]['main']);

    List<ForecastData> forecasts = [];
    for (var forecast in data["list"]) {
      forecasts.add(ForecastData(
        date: DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000,
                isUtc: true)
            .add(const Duration(hours: 6)),
        temp: forecast['main']['temp'],
        weatherState:
            weatherStateFromOpenWeatherString(forecast['weather'][0]['main']),
      ));
    }

    setState(() {
      _weatherData = WeatherData(
          temp: temp,
          feelsLike: tempFeelsLike,
          weatherState: weatherState,
          humidity: humidity,
          windSpeed: windSpeed,
          pressure: pressure,
          forecast: forecasts);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
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
            onPressed: () {
              setState(() {
                _weatherData = null;
              });
              getCurrentWeather();
            },
          ),
        ],
      ),
      body: _weatherData == null
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SingleChildScrollView(
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
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              runSpacing: 12,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                AdditionalInfoCard(
                                  title: "Feels Like",
                                  value: "${_weatherData!.feelsLike}°C",
                                  icon: Icons.thermostat,
                                ),
                                AdditionalInfoCard(
                                  title: "Humidity",
                                  value: "${_weatherData!.humidity}%",
                                  icon: Icons.water_drop,
                                ),
                                AdditionalInfoCard(
                                  title: "Wind Speed",
                                  value: "${_weatherData!.windSpeed} m/s",
                                  icon: Icons.air,
                                ),
                                AdditionalInfoCard(
                                  title: "Pressure",
                                  value: "${_weatherData!.pressure} hPa",
                                  icon: Icons.speed,
                                ),
                              ],
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
