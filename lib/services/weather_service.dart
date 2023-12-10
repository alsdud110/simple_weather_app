import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const url = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async {
    String finalUrl = "$url?q=$cityName&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(finalUrl));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<List<String>> getCurrentCity() async {
    // 위치 접근 허용인지 확인
    LocationPermission permission = await Geolocator.checkPermission();

    // 거부상태면 퍼미션 요청
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // ignore: unused_local_variable
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // arguments 에 position.latitude(위도)), position.logntitude(경도) 를 넣어줘야함 // 에뮬레이터에서는 그걸 못 가져와서 하드코딩으로 우리집 박아놓음
    List<Placemark> placemarks =
        await placemarkFromCoordinates(37.585486, 127.034974);

    String? city = placemarks[0].locality;

    String? fullLocation =
        "${placemarks[0].country} ${placemarks[0].administrativeArea} ${placemarks[0].subLocality} ***";

    List<String> location = [];
    location.add(city ?? "SEOUL");
    location.add(fullLocation);
    return location;
  }
}
