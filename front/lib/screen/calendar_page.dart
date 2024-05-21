import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/bottom_navigation_bar.dart';
import 'package:front/screen/calendar/meeting.dart';
import 'package:front/screen/calendar/meeting_data_source.dart';
import 'package:front/screen/calendar/meeting_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarView calendarView = CalendarView.month;
  CalendarController calendarController = CalendarController();

  final storage = FlutterSecureStorage();

  final String apiUrl = 'http://192.168.56.1:8080/meeting';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MeetingProvider>(context);

    getMeeting() async {
      String? token = await storage.read(key: 'accessToken');
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization' : '$token'}
        );
      if(response.statusCode == 200){
        print(json.decode(utf8.decode(response.bodyBytes)));
      }
    }

    getMeeting();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("📅 My Plan"),
        actions: [
          IconButton(onPressed: () {
            provider.addMeeting();
          }, 
          icon: const Icon(Icons.add),
          ),
          IconButton(onPressed: () {
            // provider.editMeeting(1);
          },
           icon: const Icon(Icons.edit),
           ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: () { setState(() {calendarView = CalendarView.month; calendarController.view = calendarView;}); }, child: Text("월간")),
                  OutlinedButton(onPressed: () { setState(() {calendarView = CalendarView.week; calendarController.view = calendarView;}); }, child: Text("주간")),
                  OutlinedButton(onPressed: () { setState(() {calendarView = CalendarView.day; calendarController.view = calendarView;}); }, child: Text("일간")),
                ],
              ),
              // SizedBox(height: 16), // 위젯 간 간격 추가
              Expanded(
                child: SfCalendar(
                  view: calendarView,
                  showNavigationArrow: true,
                  initialSelectedDate: DateTime.now(), // 초기 선택 날짜
                  todayHighlightColor: Colors.blue[300],
                  controller: calendarController,
                  cellBorderColor: Colors.transparent,
                  dataSource: MeetingDataSource(provider.meetings),
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.cyan, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                    showAgenda: true,
                  ),
                  blackoutDates: [
                    // 달력 날짜에 '-' 표시 (언제 쓸 지는 미정)
                    // DateTime.now().subtract(Duration(hours: 48)),
                    // DateTime.now().subtract(Duration(hours: 24)),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GetBuilder<BottomNavController>(
              init: BottomNavController(),
              builder: (controller) => BottomNavBar(),
            ),
          ),
        ],
      ),
    );
  }
}
