import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  String username = "User";
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSchedules();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  void _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schedulesString = prefs.getString('schedules');
    if (schedulesString != null) {
      setState(() {
        schedules = List<Map<String, dynamic>>.from(json.decode(schedulesString));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("사용자 정보"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "환영합니다, $username님!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (schedules.isEmpty)
              Text(
                "여행을 해보세요!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: schedules.map((schedule) {
                  DateTime rangeStart = DateTime.parse(schedule['rangeStart']);
                  DateTime rangeEnd = DateTime.parse(schedule['rangeEnd']);
                  int daysLeft = rangeStart.difference(DateTime.now()).inDays;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule['title'],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "D-${daysLeft > 0 ? daysLeft : 0}",
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
