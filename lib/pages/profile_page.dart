import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/auth_pages/login_page.dart';
import 'package:weather_app/load_data/data.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late SharedPreferences loginData;

  void initial() async {
    loginData = await SharedPreferences.getInstance();
  }

  void logout() {
    loginData.setBool('login', true);
      loginData.setBool('session', true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    SnackBar snackBar = SnackBar(content: Text('Berhasil keluar'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.network(
                  'https://rayhannaufal.github.io/img/profile.jpeg',
                  height: MediaQuery.sizeOf(context).height/3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Rayhan Naufal Anwar', 
                style: TextStyle(
                  fontWeight: FontWeight.w500
                ),
              ),
              const Text('124120020'),
              const SizedBox(height: 10),
              const Text('Lahir di Sleman, 4 September'),
              const SizedBox(
                width: 300,
                child: Text(
                  'Hobi saya adalah bermain game, mendengarkan musik, dan menonton film',
                  textAlign: TextAlign.center,
                )
              ),
              const SizedBox(height: 10),
              const Text(
                "Kesan & Pesan",
                style: TextStyle(
                  fontWeight: FontWeight.w500, 
                  fontSize: 16
                ),
              ),
              const SizedBox(
                width: 300,
                child: Text(
                  'Mata kuliah ini sangat mengasah kemampuan self-learning saya',
                  textAlign: TextAlign.center,
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => const CekData(),
            )
          );
        },
        child: const Icon(Icons.people),
      ),
    );
  }
}
