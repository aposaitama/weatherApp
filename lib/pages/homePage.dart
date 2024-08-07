import 'dart:convert';

import 'package:fetch_data/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final txtStyle = TextStyle(
      fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black26);
  Weather? w;
  Future<Weather> _fetchWeather(String name) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$name&appid=02f6f502b14e76492d5e67c1a369ffa4&units=metric'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Weather.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Weather');
    }
  }

  void initState() {
    super.initState();
    _fetchWeather('Cherkasy').then((weather) {
      setState(() {
        w = weather;
      });
    });
  }

  final cityName = TextEditingController();

  String getWeatherAnimation(String? weather) {
    if (weather == null) return 'assets/sunny.json';
    switch (weather.toLowerCase()) {
      case 'clouds':
        return 'lib/assets/cloud.json';
      case 'rain':
        return 'lib/assets/rain.json';
      case 'snow':
        return 'lib/assets/snowwy.json';
      default:
        return 'lib/assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 50,
              child: TextField(
                controller: cityName,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: GestureDetector(
                onTap: () async {
                  try {
                    Weather weather = await _fetchWeather(cityName.text);
                    setState(() {
                      w = weather;
                    });
                  } catch (e) {}
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                      color: Colors.orange),
                  width: 100,
                  height: 100,
                  child: Center(child: Text('ClickMe')),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text('${w?.name}',
            style:
                txtStyle //TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
        Lottie.asset(getWeatherAnimation(w?.weather)),
        Text(
          w?.temperature?.round().toString() ?? 'Loading...',
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black26),
        ),
        // Text(w?.name?.toString() ?? 'Loading...'),

        Text(
          w?.weather?.toString() ?? 'Loading...',
          style: txtStyle,
        ),
      ]),
    );
  }
}
