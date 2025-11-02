import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  bool isLoading = false;
  String city = "Goa";
  double? temperature;
  String? weatherDescription;
  List<Map<String, dynamic>> history = [];

  Future<void> fetchWeather(String cityName) async {
    setState(() => isLoading = true);

    try {
      final url =
          "https://api.open-meteo.com/v1/forecast?latitude=15.5&longitude=73.8&current_weather=true";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data["current_weather"]["temperature"];
          weatherDescription = "${data["current_weather"]["weathercode"]}";
          city = cityName;
          history.insert(0, {
            "city": city,
            "temp": temperature,
            "desc": weatherDescription,
          });
        });
      } else {
        throw Exception("Failed to load weather");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error fetching data")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void clearHistory() {
    setState(() => history.clear());
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App (REST API)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearHistory,
            tooltip: "Clear History",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Enter City",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) fetchWeather(value);
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : temperature != null
                    ? Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text("$city"),
                          subtitle: Text("Temp: $temperature°C"),
                          trailing: const Icon(Icons.cloud),
                        ),
                      )
                    : const Text("No data"),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "Search History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text("No history"))
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final h = history[index];
                        return Card(
                          child: ListTile(
                            title: Text(h["city"]),
                            subtitle:
                                Text("Temp: ${h["temp"]}°C | Code: ${h["desc"]}"),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
