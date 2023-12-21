import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/load_data/load_data.dart';

class ForecastPage extends StatefulWidget {
  final String cityName;
  const ForecastPage({super.key, required this.cityName});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  final _loadData = LoadData('91b1d970b23cef05a86dbdd048cb991f');

  String getIcon(String? mainCondition) { 
    if (mainCondition == null) {
      return 'assets/Sunny.png';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/PartlyCloudy.png';
      case 'rain':
      case 'shower rain':
      case 'drizzle':
        return 'assets/Rainy.png';
      case 'thunderstorm':
        return 'assets/RainThunder.png.';
      case 'clear':
        return 'assets/Sunny.png';
      default:
        return 'assets/Sunny.png';
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 5),
            Text(
              widget.cityName.toUpperCase(),
              style: const TextStyle(
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _loadData.getForecast(widget.cityName),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          if (snapshot.hasData) {
            ForecastModel forecast = ForecastModel.fromJson(snapshot.data);
            return ListView.builder(
              itemCount: forecast.list!.length,
              itemBuilder: (context, index) {
                var ramalan = forecast.list![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    color: Colors.blue[400],
                    shadowColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width/4,
                            child: Image.asset(
                              getIcon(ramalan.weather![0].main),
                              height: 80,
                            ),
                          ),
                          Column(
                            children: [
                              Text(ramalan.weather![0].main!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22
                              ),),
                              Text(
                                ramalan.weather![0].description!,
                                style: const TextStyle(
                                  color: Colors.white60
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${ramalan.main!.temp!.round()}°C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                DateFormat('MMM d, HH:mm').format(dateFormat.parse(ramalan.dtTxt!)), 
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }, 
            );
          } if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to Load Data'
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        },
      ),
    );
  }
}