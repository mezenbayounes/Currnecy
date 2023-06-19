import 'package:currency/authentification.dart';
import 'package:currency/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CryptoWallet.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late int currentIndex = 0;
  final List<Widget> interfaces = [
    menu(),
    CryptoWallet(),
    Authentication(),
    Authentication()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Crypto Wallet")),
      ),
      body: interfaces[currentIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.wallet,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(width: 10),
                  Text("My crypto-currencies",
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
                ],
              ),
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.wallet,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(width: 10),
                  Text("Login",
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
                ],
              ),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text("Logout",
                      style: TextStyle(fontSize: 20, color: Colors.red))
                ],
              ),
              onTap: () async {
                /*setState(() {
                  currentIndex = 2;
                });
                Navigator.pop(context); */
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear(); // Clear the shared preferences

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Authentication()),
                  (route) => false, // Remove all existing routes from the stack
                );
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
