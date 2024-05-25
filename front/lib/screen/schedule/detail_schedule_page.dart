import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScheduleWidget extends StatefulWidget {
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final String title;

  DetailScheduleWidget({required this.rangeStart, required this.rangeEnd, required this.title});

  @override
  _DetailScheduleWidgetState createState() => _DetailScheduleWidgetState();
}

class _DetailScheduleWidgetState extends State<DetailScheduleWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _days;
  late List<List<TimeOfDay?>> _schedules; // 변경된 부분

  @override
  void initState() {
    super.initState();
    _initializeDays();
    _tabController = TabController(length: _days.length, vsync: this);
    _schedules = List.generate(_days.length, (_) => [null]); // 변경된 부분
  }

  void _initializeDays() {
    _days = [];
    DateTime currentDay = widget.rangeStart;
    while (currentDay.isBefore(widget.rangeEnd.add(Duration(days: 1)))) {
      _days.add(currentDay);
      currentDay = currentDay.add(Duration(days: 1));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _pickTime(int dayIndex, int scheduleIndex) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _schedules[dayIndex][scheduleIndex] = picked;
      });
    }
  }

  void _addSchedule(int dayIndex) {
    setState(() {
      _schedules[dayIndex].add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📅 세부 일정 입력"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: List<Widget>.generate(_days.length, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tab(
                  child: Column(
                    children: [
                      Text("Day ${index + 1}", style: TextStyle(fontSize: 16)),
                      Text(
                        DateFormat("M/d").format(_days[index]),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List<Widget>.generate(_days.length, (dayIndex) {
          DateTime currentDay = _days[dayIndex];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _schedules[dayIndex].length,
                    itemBuilder: (context, scheduleIndex) {
                      TimeOfDay? selectedTime = _schedules[dayIndex][scheduleIndex];
                      return ListTile(
                        onTap: () => _pickTime(dayIndex, scheduleIndex), // 수정된 부분
                        title: Row(
                          children: [
                            Icon(Icons.access_time),
                            Text(selectedTime != null ? selectedTime.format(context) : "시간 선택"),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "위치 입력",
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _addSchedule(dayIndex); // 변경된 부분
                  },
                  child: Text("일정 추가"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
