import 'package:flutter/material.dart';
import 'package:front/screen/schedule/detail_schedule_page.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AddScheduleWidget extends StatefulWidget {
  @override
  State<AddScheduleWidget> createState() => _AddScheduleWidgetState();
}

class _AddScheduleWidgetState extends State<AddScheduleWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      print("start $_rangeStart");
      print("end $_rangeEnd");
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("📅 일정 만들기"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '일정 제목',
                ),
              ),
            ),
            TableCalendar(
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              locale: 'ko_KR', // 한글 달력 사용
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              rangeStartDay: _rangeStart,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              onRangeSelected: _onRangeSelected,
              rangeEndDay: _rangeEnd,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Text(
                "출발 날짜 : ${_rangeStart != null ? DateFormat("yyyy년 MM월 dd일").format(_rangeStart!) : '날짜를 선택해주세요.'}"),
            Text(
                "도착 날짜 : ${_rangeEnd != null ? DateFormat("yyyy년 MM월 dd일").format(_rangeEnd!) : '날짜를 선택해주세요.'}"),
            Container(
              margin: EdgeInsets.all(50),
              child: ElevatedButton(
                onPressed: () {
                  if (textEditingController.text.isEmpty ||
                      _rangeStart == null ||
                      _rangeEnd == null) {
                    Get.dialog(
                      AlertDialog(
                        title: Text('🤔'),
                        content: Text('일정 제목 혹은 날짜 입력을 잊지는 않으셨나요?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Get 패키지의 dialog 메서드를 사용하여 다이얼로그를 닫습니다.
                              Get.back();
                            },
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // 세부 일정 페이지로 이동
                    print("새로운 일정 : ${textEditingController.text} (${DateFormat("yy/MM/dd").format(_rangeStart!)} ~ ${DateFormat("yy/MM/dd").format(_rangeEnd!)})");
                    Get.to(() => DetailScheduleWidget(
                          rangeStart: _rangeStart!,
                          rangeEnd: _rangeEnd!,
                          title: textEditingController.text,
                        ));
                  }
                },
                child: Icon(
                  Icons.navigate_next_rounded,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
