import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/screen/calendar/meeting.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MeetingProvider extends ChangeNotifier {
  List<Meeting> meetings = [];

  final String apiUrl = 'http://192.168.56.1:8080/meeting/create';
  final String apiUrl2 = 'http://192.168.56.1:8080/meeting';

  final storage = FlutterSecureStorage();

  void addMeeting() {
    TextEditingController textEditingController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    Color selectedColor = Colors.blue;

    List<Color> colors = 
    [
    Colors.blue, 
    Colors.green, 
    Colors.red, 
    Colors.orange, 
    Colors.purple, 
    Colors.pink.shade200, 
    Colors.brown, 
    Colors.grey
    ];

    Get.defaultDialog(
      buttonColor: Colors.blue,
      title: '일정 추가하기',
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              SizedBox(height: 10),
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '제목',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  startDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (startDate != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        startDate = DateTime(
                          startDate!.year,
                          startDate!.month,
                          startDate!.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: Text(startDate == null ? '시작 날짜 선택' : '시작 날짜: ${startDate.toString()}'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  endDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (endDate != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        endDate = DateTime(
                          endDate!.year,
                          endDate!.month,
                          endDate!.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: Text(endDate == null ? '종료 날짜 선택' : '종료 날짜: ${endDate.toString()}'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("식별 색상"),
                  SizedBox(width: 10),
                  DropdownButton<Color>(
                    value: selectedColor,
                    items: colors.map((Color color) {
                      return DropdownMenuItem<Color>(
                        value: color,
                        child: Container(
                          width: 100,
                          height: 20,
                          color: color,
                        ),
                      );
                    }).toList(),
                    onChanged: (Color? newColor) {
                      setState(() {
                        selectedColor = newColor!;
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
      textConfirm: '추가',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (textEditingController.text.isNotEmpty && startDate != null && endDate != null) {
          meetings.add(
            Meeting(
              textEditingController.text,
              startDate!,
              endDate!,
              selectedColor,
              false,
            ),
          );
          notifyListeners();
          Get.back();
        }
        print("http 통신 전");
        String? token = await storage.read(key: 'accessToken');
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json', 
          'Authorization' : '$token'},
          body: jsonEncode(Meeting(
            textEditingController.text,
            startDate!,
            endDate!,
            selectedColor,
            false,
          ).toJson())
        );

        if(response.statusCode == 200) {
          print("일정 DB에 추가 완료");
        } else {
          print("일정 DB 추가 중 무언가 문제 발생");
        }

        print("http 통신 후");
      },
      textCancel: '취소',
      cancelTextColor: Colors.blue[400],
    );
  }

  void editMeeting(int index) {
    // meetings[index].eventName = '수정 기능 $index $index';
    notifyListeners();
  }
}
