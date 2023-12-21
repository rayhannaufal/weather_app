import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/user_model.dart';
import 'package:weather_app/auth_pages/login_page.dart';
import 'package:hive/hive.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  late Box<UserModel> _myBox;
  String pesan = '';
  bool isRegister = false;

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box("userDB");
  }

  addAcount() {
    final passwordHash = md5.convert(utf8.encode(password.text));
    _myBox.add(
      UserModel(
        username: username.text,
        password: passwordHash.toString())
    );
    pesan = 'Register successfully';
    isRegister = true;
    
    Navigator.pushReplacement(
      context, MaterialPageRoute(
        builder: (context) => const LoginPage(),
      )
    );
  }

  register(){
    int found = 0;
    if (_myBox.values.isNotEmpty) {
      for (var i = 0; i < _myBox.values.length; i++) {
        if (username.text == _myBox.getAt(i)!.username) {
          found = i;
          break;
        }
      }
      if (username.text == _myBox.getAt(found)!.username) {
        pesan = 'Username has been used';
      }else {
        addAcount();
      }
    } if (_myBox.values.isEmpty) {
      addAcount();
    }

    SnackBar snackBar = SnackBar(
      content: Text(pesan),
      backgroundColor: (isRegister) ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
                ),
              ),
              const Text(
                'Register your account',
                style: TextStyle(
                  fontSize: 16,
        
                ),
              ),
              const SizedBox(height: 30),
              textForm(username, false, Icons.person, "Username"),
              const SizedBox(height: 10),
              textForm(password, true, Icons.lock, "Password"),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    register();
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10),
              const Text('Already have an account ?'),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(
                      builder: (context) => const LoginPage(), 
                    )
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ), 
                child: const Text('Log In'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textForm(_controller, _secure, _icon, _name) {
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