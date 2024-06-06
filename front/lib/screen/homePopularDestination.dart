import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget popularDestinations(
    BuildContext context, String img, String city, String country) {
  return Container(
    padding: EdgeInsets.fromLTRB(2, 2, 2, 3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
    height: MediaQuery.of(context).size.height * 0.22, //152,
    width: MediaQuery.of(context).size.width * 0.29, //95,
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center, //CrossAxisAlignment.start,
      children: [
        Image.asset(
          img,
          height: MediaQuery.of(context).size.height * 0.15, // 112,
          width: MediaQuery.of(context).size.width * 0.28, //91,
          fit: BoxFit.fitWidth,
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