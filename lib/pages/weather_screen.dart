import 'dart:convert';
import 'dart:ui';

import 'package:basic_weather/pages/forecast_cards.dart';
import 'package:basic_weather/utils/data_classes.dart';
import 'package:basic_weather/utils/info.dart';
import 'package:basic_weather/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_weather/utils/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData? _weatherData;
  Future getCurrentWeather() async {
    final String apiKey = Secrets.OPEN_WEATHER_API_KEY;

    const String city = "Chittagong,bd";
    const int count = 8;
    const String unit = "metric";

    Position position = await getPosition();

    // final res = await http.get(Uri.parse(
    //     "https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$unit&cnt=$count&APPID=$apiKey"));
    final res = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=$unit&cnt=$count&appid=$apiKey"));

    if (res.statusCode != 200) {
      throw "Failed to fetch (res: ${res.statusCode} ${res.body})";
    }

    final data = jsonDecode(res.body);

    final currentData = data["list"][0];
    double temp = currentData['main']['temp'].toDouble();
    double tempFeelsLike = currentData['main']['feels_like'].toDouble();
    String weatherDescription = currentData['weather'][0]['description'];
    double humidity = currentData['main']['humidity'].toDouble();
    double pressure = currentData['main']['pressure'].toDouble();
    double windSpeed = currentData['wind']['speed'].toDouble();
    double visibility = currentData['visibility'].toDouble() / 1000;
    int timezoneOffset = data['city']['timezone'];
    DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(
            data['city']['sunrise'] * 1000,
            isUtc: true)
        .add(Duration(seconds: timezoneOffset));
    DateTime sunset = DateTime.fromMillisecondsSinceEpoch(
            data['city']['sunset'] * 1000,
            isUtc: true)
        .add(Duration(seconds: timezoneOffset));

    final now = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    if (sunrise.isBefore(now)) sunrise = sunrise.add(const Duration(days: 1));
    if (sunset.isBefore(now)) sunset = sunset.add(const Duration(days: 1));
    final showSunrise = sunrise.difference(now) < sunset.difference(now);

    WeatherState weatherState =
        weatherStateFromOpenWeatherString(currentData['weather'][0]['main']);

    List<ForecastData> forecasts = (data["list"] as List)
        .map((forecast) => ForecastData(
              date: DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000,
                      isUtc: true)
                  .add(Duration(seconds: timezoneOffset)),
              temp: forecast['main']['temp'].toDouble(),
              weatherState: weatherStateFromOpenWeatherString(
                  forecast['weather'][0]['main']),
            ))
        .toList();

    setState(() {
      _weatherData = WeatherData(
          temp: temp,
          weatherDescription: weatherDescription,
          feelsLike: tempFeelsLike,
          weatherState: weatherState,
          humidity: humidity,
          windSpeed: windSpeed,
          pressure: pressure,
          visibility: visibility,
          sunrise: sunrise,
          sunset: sunset,
          showSunrise: showSunrise,
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
                      description: _weatherData!.weatherDescription,
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
                                  icon: Icons.thermostat_outlined,
                                ),
                                AdditionalInfoCard(
                                  title: "Humidity",
                                  value: "${_weatherData!.humidity}%",
                                  icon: Icons.water_drop_outlined,
                                ),
                                AdditionalInfoCard(
                                  title: "Wind Speed",
                                  value: "${_weatherData!.windSpeed} m/s",
                                  icon: Icons.air,
                                ),
                                _weatherData!.showSunrise
                                    ? AdditionalInfoCard(
                                        title: "Sunrise",
                                        value: DateFormat.jm()
                                            .format(_weatherData!.sunrise),
                                        icon: Icons.wb_sunny_outlined)
                                    : AdditionalInfoCard(
                                        title: "Sunset",
                                        value: DateFormat.jm()
                                            .format(_weatherData!.sunset),
                                        icon: Icons.bedtime_outlined),
                                AdditionalInfoCard(
                                  title: "Pressure",
                                  value: "${_weatherData!.pressure} hPa",
                                  icon: Icons.speed,
                                ),
                                AdditionalInfoCard(
                                    title: "Visibility",
                                    value: "${_weatherData!.visibility} km",
                                    icon: Icons.remove_red_eye_outlined),
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
      {super.key,
      required this.temp,
      required this.description,
      required this.weatherState});

  final double temp;
  final String description;
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
                      description.toTitleString(),
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
