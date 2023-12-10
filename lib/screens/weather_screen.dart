import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // api key
  final _weatherService =
      WeatherService(apiKey: "998ed3296156701ac3c2ed31790fa2d5");
  Weather? _weather;
  String _fullLocation = "";

  // fetch weather
  _fetchWeather() async {
    // get the current city
    List<String> cityList = await _weatherService.getCurrentCity();
    String cityName = cityList[0];

    try {
      // get the weather by current city
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
        _fullLocation = cityList[1];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "assets/sunny.json";
    }

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloud.json";
      case "rain":
        return "assets/rain.json";
      case "drizzle":
      case "shower rain":
        return "assets/rain.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.location_on_sharp,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _fullLocation,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            const Spacer(),
            Text(
              "${_weather?.temperature.round()}°",
              style: const TextStyle(
                fontSize: 34,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
