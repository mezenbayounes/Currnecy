import 'package:currency/authentification.dart';
import 'package:flutter/material.dart';

import 'Currency.dart';
import 'CurrenyDetails.dart';

class CurrencyItem extends StatelessWidget {
  final Currency currency;
  final String id;

  const CurrencyItem({Key? key, required this.currency, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrencyDetails(currency: currency, id: id),
            //builder: (context) => Authentication(),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            child: Row(children: [
              Image.asset(
                "images/${currency.image}",
                width: 50,
                height: 50,
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency.name!,
                      style: const TextStyle(fontSize: 25),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "${currency.code!}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "${currency.unitPrice!}",
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
