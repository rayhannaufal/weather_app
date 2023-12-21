import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/load_data/load_data.dart';
import 'package:weather_app/pages/forecast_page.dart';


class WeatherPage extends StatefulWidget {
  final String cityName;
  const WeatherPage({super.key, required this.cityName});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //convert waktu
  static const List<String> waktu = <String>['WIB', 'WITA', 'WIT', 'GMT'];
  int hour = 0;
  
  changeTimeZone(param) {
    switch (param) {
      case 'GMT':
        hour = 17;
      case 'WIB':
        hour = 0;
      case 'WITA':
        hour = 1;
      case 'WIT':
        hour = 2;
    }
    setState(() {
      hour;
    });
  }

  // forecast date formatter
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  // load api and key
  final _loadData = LoadData('91b1d970b23cef05a86dbdd048cb991f');

  // session
  late SharedPreferences loginData;
  void initial() async {
    loginData = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  String getAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/cloudy.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/clouds.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

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
        leading: IconButton(
          onPressed: () {
            // remove session
            loginData.setBool('blmAdaKota', true);
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 5),
            Text(
              widget.cityName.toUpperCase(),
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [

              // WEATHER
              FutureBuilder(
                future: _loadData.getWeather(widget.cityName),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                  if (snapshot.hasData) {
                    WeatherModel weather = WeatherModel.fromJson(snapshot.data);

                    var sunrise = DateFormat('HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(weather.sys!.sunrise!*1000).add(Duration(hours: hour))
                    ); 

                    var sunset = DateFormat('HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(weather.sys!.sunset!*1000).add(Duration(hours: hour))
                    ); 

                    return Column(
                      children: [
                        Lottie.asset(getAnimation(weather.weather![0].main)),
                        Text(
                          '${weather.weather?[0].main} / ${(weather.main!.temp!).round()}°C',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),

                        Text(
                          weather.weather![0].description!,
                          style: const TextStyle(
                            color: Colors.white70
                          ),
                        ),
                        const SizedBox(height: 20),

                        // DETAIL WEATHER
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  color: Colors.blue[400],
                                  shadowColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width/2.5,
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        info('Sunrise', sunrise),
                                        const SizedBox(height: 5),
                                        info('Sunset', sunset),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                DropdownMenu<String>(
                                  label: const Text('Choose time'),
                                  initialSelection: waktu.first,
                                  onSelected: (String? value) {
                                    changeTimeZone(value);
                                  },
                                  dropdownMenuEntries: waktu.map<DropdownMenuEntry<String>>((String value) {
                                    return DropdownMenuEntry<String>(
                                      value: value, 
                                      label: value,
                                    );
                                  }).toList(),
                                  inputDecorationTheme: InputDecorationTheme(
                                    floatingLabelAlignment: FloatingLabelAlignment.center,
                                    floatingLabelStyle: const TextStyle(
                                      color: Colors.white70
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Colors.white70
                                      )
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )
                                  ),
                                  textStyle: const TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  color: Colors.blue[400],
                                  shadowColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width/1.9,
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        info('Real feel', '${weather.main!.feelsLike?.round()}°C'),
                                        const SizedBox(height: 5),
                                        info('Humidity', '${weather.main?.humidity}%'),
                                        const SizedBox(height: 5),
                                        info('Preassure', '${weather.main!.pressure}'),
                                        const SizedBox(height: 5),
                                        info('Visibility', '${weather.visibility!/1000} km'),
                                        const SizedBox(height: 5),
                                        info('Wind', '${(weather.wind!.speed!/3.6).round()} km/h'),
                                      ],
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to Load Data'
                      ),
                    );
                  } else {
                    return const  Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20,),


              // FORECAST
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Forecast',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white
                      ),
                    ),
                    RawMaterialButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastPage(cityName: widget.cityName),));
                    }, child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: _loadData.getForecast(widget.cityName),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                    if (snapshot.hasData) {
                      ForecastModel forecast = ForecastModel.fromJson(snapshot.data);
                      return SizedBox(
                        height: 220,
                        child: ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var ramalan = forecast.list![index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                              color: Colors.blue[400],
                              shadowColor: Colors.transparent,
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width/3,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        getIcon(ramalan.weather![0].main),
                                        width: 100,
                                      ),
                                      Text(
                                        '${ramalan.main!.temp!.round()}°C',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        ramalan.weather![0].main!,
                                        style: const TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        DateFormat.Hm().format(dateFormat.parse(ramalan.dtTxt!)),textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white70
                                        ),),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }, 
                        ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget info(placeholder, content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          placeholder,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70
          ),
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ),
      ],
    );
  }
}