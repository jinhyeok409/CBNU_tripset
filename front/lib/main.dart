import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:front/screen/calendar/meeting_provider.dart';
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

void main() async {
  await dotenv.load(fileName: ".env");
  String serverUri = dotenv.env['SERVER_URI']!;
  print('서버 URI: $serverUri');

  Get.put(PostListScrollController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MeetingProvider(),
        ),
      ],
      child: GetMaterialApp(
        // 달력에서 한글을 출력하기 위한 코드들
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ko', 'KR'),
        ],
        locale: const Locale('ko', 'KR'),
        // get 라우팅
        getPages: [
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
          GetPage(name: '/calendar', page: () => CalendarWidget()),
        ],
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}
