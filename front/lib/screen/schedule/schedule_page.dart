import 'package:flutter/material.dart';
import 'package:front/screen/schedule/add_schedule_page.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleWidget extends StatefulWidget {
  @override
  State<ScheduleWidget> createState() => _ScheduleWidget();
}

class _ScheduleWidget extends State<ScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("📅 나의 일정"),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/suitcase_woman.svg",
                ),
                const SizedBox(height: 16), // 간격을 위한 SizedBox 추가
                Text(
                  "아직 일정이 없으시네요",
                  style: TextStyle(
                    fontSize: 20, // 글씨 크기 설정
                    fontWeight: FontWeight.bold, // 글씨 두께 설정
                  ),
                ),
                Text(
                  "신나는 여행 일정을 간편하게 만들어보세요",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16), // 텍스트와 버튼 사이의 간격
                ElevatedButton(
                  onPressed: () {
                    // 일정 추가 버튼 클릭 시 동작
                    Get.to(AddScheduleWidget());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "새로운 일정 만들기",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: GetBuilder<BottomNavController>(
          //     init: BottomNavController(),
          //     builder: (controller) => BottomNavBar(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
