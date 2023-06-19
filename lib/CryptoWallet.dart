import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency/globals.dart' as utils;

import 'Currency.dart';
import 'CurrencyItem.dart';

class CryptoWallet extends StatefulWidget {
  const CryptoWallet({super.key});

  @override
  State<CryptoWallet> createState() => _CryptoWalletState();
}

class _CryptoWalletState extends State<CryptoWallet> {
  List<Currency> currnecies = [];
  double balance = 0;
  String username = "";
  String _id = "";

  late Future<bool> CurrenciesFetched;

  Future<bool> fetchCurrenciesFromServer() async {
    http.Response response =
        await http.get(Uri.http(utils.baseUrlWithoutHttp, "/api/currencies"));

    List<dynamic> currenciesRetreived = json.decode(response.body);

    for (var currency in currenciesRetreived) {
      currnecies.add(Currency(
        id: currency["_id"],
        description: currency["description"],
        image: currency["image"],
        code: currency["code"].toString(),
        unitPrice: double.parse(currency["unitPrice"].toString()),
        name: currency["name"],
      ));
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    balance = pref.getDouble("balance")!;
    username = pref.getString("username")!;
    _id = pref.getString("_id")!;

    return true;
  }

  @override
  void initState() {
    CurrenciesFetched = fetchCurrenciesFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: FutureBuilder(
      future: CurrenciesFetched,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  "$username",
                  style: TextStyle(fontSize: 25),
                ),
                Text("$balance DT",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.all(10)),
              ]),
              const Padding(padding: EdgeInsets.all(10)),
              Expanded(
                child: ListView.builder(
                  itemCount: currnecies.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        child: CurrencyItem(
                      currency: currnecies[index],
                      id: _id,
                    ));
                  },
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    ));
  }
}
