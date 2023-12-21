import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/component/bottom_nav.dart';
import 'package:weather_app/models/user_model.dart';
import 'package:weather_app/auth_pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  late Box<UserModel> _myBox;

  late SharedPreferences loginData;
  late bool newUser;

  String pesan = 'Failed to log in';
  
  @override
  void initState() {
    super.initState();
    _myBox = Hive.box("userDB");
    session();
  } 

  session() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('needLogin') ?? true);
    if (newUser == false ) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (context) => BottomNavigation(), 
        )
      );  
    }
  }

  login() {
    
    // inisiasi loginData
    loginData.setBool('needLogin', true);
    
    // hash
    final passwordHash = md5.convert(utf8.encode(password.text));
    
    // checking
    for (var i = 0; i < _myBox.values.length; i++) {
      if (username.text == _myBox.getAt(i)!.username && passwordHash.toString() == _myBox.getAt(i)!.password) {
        loginData.setBool('needLogin', false);
        Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (context) => const BottomNavigation(),
          )
        );
        setState(() {
          pesan = "Log in successfully"; 
        });
      }
    }
    SnackBar snackBar = SnackBar(
      content: Text(pesan), 
      backgroundColor: (loginData.getBool('needLogin'))! ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/clouds.json'),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                  ),
                ),
                const Text(
                  'Log in to your account',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                textForm(username, false, Icons.person, "Username"),
                const SizedBox(height: 10),
                textForm(password, true, Icons.lock, "Password" ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(55), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ), 
                  child: const Text('Log in'),
                  
                ),
                const SizedBox(height: 10),
                const Text('Did\'nt have an account ?'),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(
                        builder: (context) => const RegisterPage(), 
                      )
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ), 
                  child: const Text('Sign Up '),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textForm(_controller, _secure, _icon ,_name) {
    return TextFormField(
      controller: _controller,
      validator: (value) {
        if (value == '') {
          return '$_name tidak boleh kosong';
        }
        return null;
      },
      obscureText: _secure,
      decoration: InputDecoration(
        prefixIcon: Icon(_icon),
        hintText: '$_name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );
  }
}