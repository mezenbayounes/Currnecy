import 'package:currency/CryptoWallet.dart';
import 'package:currency/authentification.dart';
import 'package:flutter/material.dart';

class menu extends StatefulWidget {
  const menu({super.key});

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  int index = 0;
  final Pages = [
    CryptoWallet(),
    Authentication(),
    Center(child: Text('profile'))
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index) => setState(() => this.index = index),
        height: 60,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home,
                  color: Color.fromARGB(255, 30, 65, 239), size: 35),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.directions_car_outlined),
              selectedIcon: Icon(Icons.directions_car,
                  color: Color.fromARGB(255, 30, 65, 239), size: 35),
              label: 'My Cars'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings,
                  color: Color.fromARGB(255, 30, 65, 239), size: 35),
              label: 'Settings'),
        ],
      ),
    );
  }
}
