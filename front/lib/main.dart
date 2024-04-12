import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // env 파일 넣기

void main() async {
  await dotenv.load(fileName: ".env");
  String serverUri = dotenv.env['SERVER_URI']!;
  print('서버 URI: $serverUri');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    ),
  );
}
