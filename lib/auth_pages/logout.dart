import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/auth_pages/login_page.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  late SharedPreferences loginData;

  void logout() {
    loginData.setBool('needLogin', true);
    loginData.setBool('session', true);
    Navigator.pushReplacement(
      context, MaterialPageRoute(
        builder: (context) => const LoginPage(), 
      )
    );
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initial();
    Future.delayed(Duration(seconds: 1), logout);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Logging Out")
          ],
        ),
      ),
    );
  }
}