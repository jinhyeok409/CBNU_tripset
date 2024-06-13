import 'package:flutter/material.dart';
import 'package:front/screen/schedule/add_schedule_page.dart';
import 'package:front/screen/schedule/detail_schedule_page.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScheduleWidget extends StatefulWidget {
  @override
  State<ScheduleWidget> createState() => _ScheduleWidget();
}

class _ScheduleWidget extends State<ScheduleWidget> {
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  void _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schedulesString = prefs.getString('schedules');
    if (schedulesString != null) {
      setState(() {
        schedules =
            List<Map<String, dynamic>>.from(json.decode(schedulesString));
      });
    }
  }

  void _saveSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('schedules', json.encode(schedules));
  }

  void _addSchedule(Map<String, dynamic> newSchedule) {
    setState(() {
      schedules.add(newSchedule);
      _saveSchedules();
    });
  }

  void _updateSchedule(int index, Map<String, dynamic> updatedSchedule) {
    setState(() {
      schedules[index] = updatedSchedule;
      _saveSchedules();
    });
  }

  void _deleteSchedule(int index) {
    setState(() {
      schedules.removeAt(index);
      _saveSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "📅  나의 일정",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: schedules.isEmpty
                ? Column(
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
                        onPressed: () async {
                          // 일정 추가 버튼 클릭 시 동작
                          final newSchedule = await Get.to(AddScheduleWidget(),
                              transition: Transition.downToUp);
                          if (newSchedule != null) {
                            _addSchedule(newSchedule);
                          }
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
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = schedules[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                title: Text(
                                  schedule['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${DateFormat("yyyy년 MM월 dd일").format(DateTime.parse(schedule['rangeStart']))} - ${DateFormat("yyyy년 MM월 dd일").format(DateTime.parse(schedule['rangeEnd']))}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                onTap: () async {
                                  final updatedSchedule =
                                      await Get.to(() => DetailScheduleWidget(
                                            rangeStart: DateTime.parse(
                                                schedule['rangeStart']),
                                            rangeEnd: DateTime.parse(
                                                schedule['rangeEnd']),
                                            title: schedule['title'],
                                            schedules:
                                                schedule['schedules'] ?? [],
                                          ));
                                  if (updatedSchedule != null) {
                                    _updateSchedule(index, updatedSchedule);
                                  }
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('일정 삭제'),
                                          content: Text('정말로 이 일정을 삭제하시겠습니까?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('취소'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _deleteSchedule(index);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('삭제'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final newSchedule =
                                await Get.to(AddScheduleWidget());
                            if (newSchedule != null) {
                              _addSchedule(newSchedule);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            "새로운 일정 만들기",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
