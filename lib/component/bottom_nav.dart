import 'package:flutter/material.dart';
import 'package:weather_app/auth_pages/logout.dart';
import 'package:weather_app/pages/menu_page.dart';
import 'package:weather_app/pages/convert_page.dart';
import 'package:weather_app/pages/profile_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int _selectedIndex = 0;

  late List page = [
    const MenuPage(),
    const ProfilePage(),
    const ConvertPage(),
    const Logout()
  ];


  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout'
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: onTap,
      ),
    );
  }
}