class Weather {
  final String name;
  final String weather;
  final double temperature;

  const Weather({
    required this.name,
    required this.weather,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      name: json['name'],
      weather: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}
