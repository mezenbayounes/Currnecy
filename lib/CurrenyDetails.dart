import 'dart:convert';
import 'dart:ffi';

import 'package:currency/CryptoWallet.dart';
import 'package:currency/menu.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'globals.dart' as utils;
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'Currency.dart';

class CurrencyDetails extends StatefulWidget {
  final Currency currency;
  late int amount;
  final String id;

  CurrencyDetails({Key? key, required this.currency, required this.id})
      : super(key: key);

  @override
  State<CurrencyDetails> createState() => _CurrencyDetailsState();
}

class _CurrencyDetailsState extends State<CurrencyDetails> {
  late int quantity = 2;
  final formKey = GlobalKey<FormState>();
  Future<bool> fetchCurrenciesFromServer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.currency.name!)),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  "images/${widget.currency.image}",
                  height: 200,
                  width: 400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.currency.name!,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "[${widget.currency.code}]",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.currency.unitPrice} DT',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                "${widget.currency.description}",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          5.0), // Customize the border radius
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 232, 213, 213)), // C
                    ),
                    hintText: widget.id,
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 211, 198, 197)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 90, right: 90),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Amount',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 211, 198, 197))),
                      onSaved: (String? value) {
                        quantity = int.parse(value!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Amout";
                        } else {
                          return null;
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.shopping_basket_rounded),
        label: const Text("Acheter"),
        onPressed: () async {
          String userID = widget.id;
          String? nameCrypto = widget.currency.name;
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            Map<String, dynamic> reqBody = {
              "quantity": quantity,
              "currencyId": widget.currency.id
            };

            Map<String, String> headers = {
              "Content-Type": "application/json; charset=utf-8"
            };

            http
                .post(
                    Uri.http(
                        utils.baseUrlWithoutHttp, "/api/currencies/$userID"),
                    body: json.encode(reqBody),
                    headers: headers)
                .then((http.Response response) async {
              if (response.statusCode == 200) {
                Map<String, dynamic> result = json.decode(response.body);
                //SHARED PREFS
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Succes"),
                        content:
                            Text("you just bought $quantity $nameCrypto  !"),
                      );
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text("Error"),
                        content: Text("No available funds!"),
                      );
                    });
              }
            });
          }
        },
      ),
    );
  }
}
