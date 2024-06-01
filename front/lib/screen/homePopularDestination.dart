import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget popularDestinations(String img, String city, String country) {
  return Container(
    padding: EdgeInsets.fromLTRB(2, 2, 2, 3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
    height: 152,
    width: 95,
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          img,
          height: 114,
          width: 91,
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          city,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          country,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(172, 171, 171, 100),
          ),
        ),
      ],
    ),
  );
}
