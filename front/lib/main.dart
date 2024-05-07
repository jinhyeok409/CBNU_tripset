import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:front/screen/detail_page.dart';
import 'package:get/get.dart';
>>>>>>> Stashed changes
import 'screen/login.dart';
import 'screen/detail_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // env 파일 넣기

// import 'screen/home.dart'; // 홈화면 디버깅시 추가

void main() async {
  await dotenv.load(fileName: ".env");
  String serverUri = dotenv.env['SERVER_URI']!;
  print('서버 URI: $serverUri');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetailPage(),
    ),
  );
}

// 홈화면 디버깅용
// void main() {
//   runApp(const MaterialApp(home: Home()));
// }
