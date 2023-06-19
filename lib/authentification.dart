import 'package:flutter/material.dart';
import 'package:currency/globals.dart' as utils;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late String username;
  late String identifiant;
  final formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text("Login"))),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                    height: 200,
                    width: 400,
                    child: Image.asset("images/LOGO.png")),
              ),
              const Padding(padding: EdgeInsets.all(30)),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Username"),
                            onSaved: (String? value) {
                              username = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your username";
                              } else {
                                return null;
                              }
                            }),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), labelText: "ID"),
                            onSaved: (String? value) {
                              identifiant = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your ID";
                              } else if (value.length != 4) {
                                return "Value must be 4 characters";
                              } else {
                                return null;
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 70.0, right: 70),
                        child: SizedBox(
                          width: 380,
                          child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  Map<String, dynamic> reqBody = {
                                    "username": username,
                                    "identifier": identifiant,
                                  };

                                  Map<String, String> headers = {
                                    "Content-Type":
                                        "application/json; charset=utf-8"
                                  };

                                  http
                                      .post(
                                          Uri.http(utils.baseUrlWithoutHttp,
                                              "/api/users/login/id"),
                                          body: json.encode(reqBody),
                                          headers: headers)
                                      .then((http.Response response) async {
                                    if (response.statusCode == 200) {
                                      Map<String, dynamic> result =
                                          json.decode(response.body);
                                      //SHARED PREFS
                                      _prefs.then(
                                        (value) {
                                          value.setDouble(
                                              "balance",
                                              double.parse(result["balance"]
                                                  .toString()));

                                          value.setString(
                                              "username", (result["username"]));

                                          value.setString(
                                              "_id", (result["_id"]));
                                        },
                                      );

                                      print('passssssssssssssss');
                                      Navigator.pushReplacementNamed(
                                          context, "/NavDrawer");
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              title: Text("Error"),
                                              content: Text(
                                                  "Username or ID are incorrect !"),
                                            );
                                          });
                                    }
                                  });
                                }
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
