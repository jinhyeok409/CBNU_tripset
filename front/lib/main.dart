import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:front/bottom_navigation_bar.dart';
import 'package:front/screen/calendar/meeting_provider.dart';
import 'package:front/screen/schedule_page.dart';
import 'package:front/screen/root.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'controller/post_list_scroll_controller.dart';
import 'screen/home.dart';
import 'screen/login.dart';
import 'screen/register.dart';
import 'screen/calendar_page.dart';
import 'screen/post_list.dart';
import 'screen/detail_page.dart';
import 'screen/write_page.dart';
import 'screen/chat_list_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  String serverUri = dotenv.env['SERVER_URI']!;
  print('서버 URI: $serverUri');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // get 라우팅
      getPages: [
        GetPage(
          name: '/root',
          page: () => Root(),
        ),
        GetPage(name: '/home', page: () => Home()),
        GetPage(
          name: '/login',
          page: () => Login(),
        ),
        GetPage(
          name: '/register',
          page: () => Register(),
        ),
        GetPage(name: '/postList', page: () => PostList()),
        GetPage(
          name: '/postWrite',
          page: () => PostPage(),
        ),
        GetPage(
          name: '/postDetail',
          page: () => PostDetailPage(),
        ),
        GetPage(
          name: '/postEdit',
          page: () => EditPostPage(),
        ),
        GetPage(name: '/schedule', page: () => ScheduleWidget()),
        GetPage(name: '/chatRoomList', page: () => ChatListPage()),
      ],
      // 컨트롤러 바인딩
      initialBinding: AppBinding(),
      // 고전 네비게이션
      //initialRoute: '/',
      // routes: {
      //   '/Root': (context) => Root(),
      //   // '/second': (context) => SecondScreen(),
      // },
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostListScrollController(), permanent: true);
    Get.put(BottomNavController());
  }
}
