import 'package:flutter/material.dart';
import 'package:front/screen/calendar_page.dart';
import 'package:get/get.dart';
import 'screen/home.dart';
import 'screen/post_list.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed('/home');
        break;
      case 1:
        Get.toNamed('/calendar');
        break;
      case 2:
        Get.toNamed('/postList');
        break;
      case 3:
        // 채팅 추후 구현
        // Get.to(Chat());
        break;
      default:
        break;
    }
  }
}

List<IconData> navIcons = [
  Icons.home,
  Icons.event_available,
  Icons.diversity_3,
  Icons.chat,
];

List<String> navTitle = ['Home', 'Plan', 'Community', 'Chat'];

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController =
        Get.put(BottomNavController());
    final double iconSize =
        MediaQuery.of(context).size.width * 0.08; // 아이콘 크기를 화면 너비의 8%로 설정
    final double navBarHeight =
        MediaQuery.of(context).size.height * 0.1; // 하단바 높이를 화면 높이의 10%로 설정
    final double horizontal_margin =
        MediaQuery.of(context).size.width * 0.08; // 아이콘 간격을 화면 너비의 8%로 설정
    final double vertical_margin =
        MediaQuery.of(context).size.width * 0.06; // 아이콘 간격을 화면 너비의 8%로 설정
    return Obx(
      () => Container(
        width: double.infinity,
        height: navBarHeight,
        decoration: BoxDecoration(
          color: Color(0xFFB0D1F8),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: navIcons.map((icon) {
            int index = navIcons.indexOf(icon);
            bool isSelected = bottomNavController.selectedIndex.value == index;
            return Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  bottomNavController.changeTabIndex(index);
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontal_margin,
                          vertical: vertical_margin),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: isSelected ? Colors.blue : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
