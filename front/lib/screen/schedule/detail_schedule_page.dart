import 'package:flutter/material.dart';
import 'package:front/screen/schedule/placePathPage.dart';
import 'package:front/screen/schedule/place_search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:google_place/google_place.dart';
import 'package:get/get.dart';
import 'dart:convert';

class DetailScheduleWidget extends StatefulWidget {
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final String title;
  final List<dynamic> schedules;

  DetailScheduleWidget({
    required this.rangeStart,
    required this.rangeEnd,
    required this.title,
    required this.schedules,
  });

  @override
  _DetailScheduleWidgetState createState() => _DetailScheduleWidgetState();
}

class _DetailScheduleWidgetState extends State<DetailScheduleWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _days;
  late List<List<Schedule>> _schedules;
  final String _storageKey = 'saved_schedules';

  @override
  void initState() {
    super.initState();
    _initializeDays();
    _tabController = TabController(length: _days.length, vsync: this);
    _loadSchedules();
  }

  void _initializeDays() {
    _days = [];
    DateTime currentDay = widget.rangeStart;
    while (currentDay.isBefore(widget.rangeEnd.add(Duration(days: 1)))) {
      _days.add(currentDay);
      currentDay = currentDay.add(Duration(days: 1));
    }
  }

  Future<void> _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSchedules = prefs.getString(_storageKey);
    if (savedSchedules != null) {
      List<dynamic> decodedSchedules = jsonDecode(savedSchedules);
      setState(() {
        _schedules = List.generate(
          _days.length,
          (index) =>
              decodedSchedules.isNotEmpty && decodedSchedules.length > index
                  ? (decodedSchedules[index] as List)
                      .map((s) => Schedule.fromMap(s as Map<String, dynamic>))
                      .toList()
                  : [Schedule()],
        );
      });
    } else {
      setState(() {
        _schedules = List.generate(
          _days.length,
          (index) =>
              widget.schedules.isNotEmpty && widget.schedules.length > index
                  ? (widget.schedules[index] as List)
                      .map((s) => Schedule.fromMap(s as Map<String, dynamic>))
                      .toList()
                  : [Schedule()],
        );
      });
    }
  }

  Future<void> _saveSchedulesLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<List<Map<String, dynamic>>> schedulesToSave = _schedules
        .map((daySchedules) =>
            daySchedules.map((schedule) => schedule.toMap()).toList())
        .toList();
    await prefs.setString(_storageKey, jsonEncode(schedulesToSave));
    print("Schedules saved locally.");
  }

  void _pickTime(int dayIndex, int scheduleIndex) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _schedules[dayIndex][scheduleIndex].time = picked;
        _saveSchedulesLocally();
      });
    }
  }

  void _addSchedule(int dayIndex) {
    setState(() {
      _schedules[dayIndex].add(Schedule());
      _saveSchedulesLocally();
    });
  }

  void _removeSchedule(int dayIndex, int scheduleIndex) {
    setState(() {
      _schedules[dayIndex].removeAt(scheduleIndex);
      _saveSchedulesLocally();
    });
  }

  Future<void> _pickLocation(int dayIndex, int scheduleIndex) async {
    TextEditingController textEditingController = TextEditingController();

    String? scheduleName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('일정 이름 입력'),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: "일정 이름을 입력하세요."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('다음'),
              onPressed: () {
                Navigator.of(context).pop(textEditingController.text);
              },
            ),
          ],
        );
      },
    );

    if (scheduleName != null && scheduleName.isNotEmpty) {
      final place = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaceSearchScreen(),
        ),
      );

      if (place != null) {
        setState(() {
          _schedules[dayIndex][scheduleIndex].location =
              "${scheduleName}: ${place.formattedAddress}";
          _schedules[dayIndex][scheduleIndex].latitude =
              place.geometry?.location?.lat.toString();
          _schedules[dayIndex][scheduleIndex].longitude =
              place.geometry?.location?.lng.toString();
          _saveSchedulesLocally();
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> _saveSchedules() async {
    List<List<Map<String, dynamic>>> schedulesToSave = _schedules
        .map((daySchedules) =>
            daySchedules.map((schedule) => schedule.toMap()).toList())
        .toList();

    List<Map<String, dynamic>> paths = [];

    for (int i = 0; i < schedulesToSave.length; i++) {
      List<Map<String, dynamic>> pathSchedules = [];
      for (int j = 0; j < schedulesToSave[i].length; j++) {
        Map<String, dynamic> scheduleMap = schedulesToSave[i][j];
        if (scheduleMap['latitude'] != null &&
            scheduleMap['longitude'] != null) {
          pathSchedules.add(scheduleMap);
        }
      }
      if (pathSchedules.isNotEmpty) {
        paths.add({
          'title': widget.title,
          'rangeStart': widget.rangeStart.toIso8601String(),
          'rangeEnd': widget.rangeEnd.toIso8601String(),
          'schedules': pathSchedules,
        });
      }
    }

    print("Saved Schedules: $paths");
    return paths;
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
                      final schedule = _schedules[dayIndex][scheduleIndex];
                      return ListTile(
                        onTap: () => _pickTime(dayIndex, scheduleIndex),
                        title: Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 5),
                            Text(
                              schedule.time != null
                                  ? schedule.time!.format(context)
                                  : "시간 선택",
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _pickLocation(dayIndex, scheduleIndex),
                                child: AbsorbPointer(
                                  child: TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: schedule.location != null
                                          ? schedule.location!
                                          : "일정 입력",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _removeSchedule(dayIndex, scheduleIndex),
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _addSchedule(dayIndex);
                  },
                  child: Text("일정 추가"),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment(-0.8, 1.0),
            child: FloatingActionButton(
              onPressed: () async {
                List<Map<String, dynamic>> paths = await _saveSchedules();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => placePathPage(paths: paths),
                  ),
                );
              },
              child: Icon(Icons.map),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () async {
                List<Map<String, dynamic>> paths = await _saveSchedules();
                print("Saved paths: $paths"); // Debug print
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Schedules saved successfully!")),
                );
              },
              child: Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }
}

class Schedule {
  TimeOfDay? time;
  String? location; // 일정 이름 및 주소
  String? latitude; // 위도
  String? longitude; // 경도

  Schedule({this.time, this.location, this.latitude, this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'time': time != null
          ? DateFormat.jm().format(DateTime(0, 0, 0, time!.hour, time!.minute))
          : null,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Schedule fromMap(Map<String, dynamic> map) {
    return Schedule(
      time: map['time'] != null ? _parseTimeOfDay(map['time']) : null,
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final format = DateFormat.jm(); // "hh:mm a" 형식
    final dateTime = format.parse(timeString.trim()); // 공백 제거
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
