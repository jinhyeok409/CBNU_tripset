import 'package:flutter/material.dart';

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  // JSON 직렬화 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': eventName,
      'startDate': from.toIso8601String(),
      'endDate': to.toIso8601String(),
      'color': background.value.toRadixString(16),
    };
  }

  // JSON 역직렬화 메서드
  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      json['title'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      Color(int.parse(json['color'], radix: 16)),
      json['isAllDay'],
    );
  }
}
