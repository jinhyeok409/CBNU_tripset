import 'package:flutter/material.dart';
import 'package:front/bottom_navigation_bar.dart';
import 'package:front/screen/calendar/meeting.dart';
import 'package:front/screen/calendar/meeting_data_source.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting('여권 발급', startTime, endTime, const Color(0xFFFF00FF), false));
    meetings.add(Meeting('숙소 예매', startTime.add(Duration(hours: 3)), endTime.add(Duration(hours: 3)), const Color(0xFF0F8644), false));
    meetings.add(Meeting('비행기 예매', startTime, endTime, const Color(0xFF0F8644), false));

    return meetings;
  }

  CalendarView calendarView = CalendarView.month;
  CalendarController calendarController = CalendarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("달력"),
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
              SizedBox(height: 16), // 위젯 간 간격 추가
              Expanded(
                child: SfCalendar(
                  view: calendarView,
                  initialSelectedDate: DateTime.now(), // 초기 선택 날짜
                  controller: calendarController,
                  cellBorderColor: Colors.transparent,
                  dataSource: MeetingDataSource(_getDataSource()),
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.cyan, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
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
