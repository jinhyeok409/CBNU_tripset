import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'currency.dart';

class CurrencyDetails extends StatelessWidget {
  final Currency currency;
  final double rate;
  final String dateTime;

  const CurrencyDetails({
    required this.currency,
    required this.rate,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(currency.imageFileName, width: 50, height: 50),
            SizedBox(height: 2.0),
            Text(
              currency.nationName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              dateTime,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rate.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 6.0),
                Text(
                  currency.code,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(width: 6.0),
                Text(
                  '(${currency.symbol})',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}