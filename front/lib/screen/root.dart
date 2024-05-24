import 'package:flutter/material.dart';
import 'package:front/bottom_navigation_bar.dart';
import 'package:front/screen/schedule_page.dart';
import 'package:front/screen/home.dart';
import 'package:front/screen/post_list.dart';
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
              // ChatPage(), // 채팅 추후 구현
            ],
          )),
      bottomNavigationBar:
          // BottomNavigationBar(
          //   currentIndex: controller.selectedIndex.value,
          //   onTap: controller.changeTabIndex,
          //   items: [
          //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.calendar_today), label: "Calendar"),
          //     BottomNavigationBarItem(icon: Icon(Icons.list), label: "Posts"),
          //     // BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"), // 채팅 추후 구현
          //   ],
          // ),
          BottomNavBar(),
    );
  }
}
