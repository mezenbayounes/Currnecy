import 'package:currency/CryptoWallet.dart';
import 'package:currency/DrawerNav.dart';
import 'package:flutter/material.dart';

import 'authentification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const Authentication(),
        "/NavDrawer": (context) => const NavDrawer(),
       
      },
      initialRoute: "/",
    );
  }
}
