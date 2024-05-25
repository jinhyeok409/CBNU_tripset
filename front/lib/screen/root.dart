import 'package:flutter/material.dart';
import 'package:front/bottom_navigation_bar.dart';
import 'package:front/screen/schedule/schedule_page.dart';
import 'package:front/screen/home.dart';
import 'package:front/screen/post/post_list.dart';
import 'package:front/screen/chat/chat_list_page.dart';
import 'package:get/get.dart';

class Root extends GetView<BottomNavController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              Home(),
              ScheduleWidget(),
              PostList(),
              ChatListPage() // 채팅 추후 구현
            ],
          )),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
