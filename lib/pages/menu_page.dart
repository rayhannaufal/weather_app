
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/pages/weather_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  late SharedPreferences sessionData;
  late String cityName;
  late bool getSession;
  bool search = false;

  @override
  void initState() {
    super.initState();
    session();
  }

  void session() async {
    sessionData = await SharedPreferences.getInstance();
    getSession = (sessionData.getBool('blmAdaKota') ?? true);
    if (getSession == false) {
      cityName = sessionData.getString('cityName')!;
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => WeatherPage(cityName: cityName),
        ) 
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !search ? const Text('Choose City or...') : TextFormField(
          autofocus: true,
          onFieldSubmitted: (value) {
            sessionData.setBool('blmAdaKota', false);
            sessionData.setString('cityName', value);
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => WeatherPage(cityName: value),
              )
            );
          },
          decoration: const InputDecoration(
            hintText: 'Type here...'
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                search = !search;
              });
            }, icon: Icon(
              !search ? Icons.add : Icons.clear
            )
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: dummyCities.length,
          itemBuilder: (context, index) {
            return cityMenu(context, dummyCities[index].name);
          }, 
        ),
      ),
    );
  }

  Widget cityMenu (context, cityName) {
    return InkWell(
      onTap: () {
        sessionData.setBool('blmAdaKota', false);
        sessionData.setString('cityName', cityName);
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => WeatherPage(cityName: cityName), 
          )
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        shadowColor: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height/10,
          child: Center(
            child: Text(
              cityName,
              style: const TextStyle(
                fontSize: 20
              ),
            )
          )
        ),
      ),
    );
  }
}