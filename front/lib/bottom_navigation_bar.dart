import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    // 해당 인덱스의 페이지로 이동하기 추후 구현
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
    return Obx(
      () => Container(
        width: double.infinity,
        height: 85,
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
                      margin: EdgeInsets.only(
                        top: 20,
                        bottom: 0,
                        left: 35,
                        right: 35,
                      ),
                      child: Icon(
                        icon,
                        size: 32,
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
