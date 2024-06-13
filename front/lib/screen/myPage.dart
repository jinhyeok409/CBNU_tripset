import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/like_post.dart'; // Assuming you have a like_post.dart model

import 'package:http/http.dart' as http; // Import http package for making HTTP requests

class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  RxString username = ''.obs;
  List<Map<String, dynamic>> schedules = [];
  List<LikePost> likedPosts = [];

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadUsername();
    _loadSchedules();
    _loadLikedPosts();
  }

  void loadUsername() async {
    String? token = await storage.read(key: 'accessToken');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken.containsKey('username')) {
        username.value = decodedToken['username'];
      }
    }
  }

  void _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schedulesString = prefs.getString('schedules');
    if (schedulesString != null && schedulesString.isNotEmpty) {
      setState(() {
        schedules = List<Map<String, dynamic>>.from(json.decode(schedulesString));
      });
    }
  }

  void _loadLikedPosts() async {
    String? token = await storage.read(key: 'accessToken');
    String serverUri = dotenv.env['SERVER_URI']!;
    String likedPostsEndpoint = dotenv.env['POST_LIKE_LIST_ENDPOINT']!;
    String likedPostsUrl = "$serverUri$likedPostsEndpoint";

    try {
      final response = await http.get(
        Uri.parse(likedPostsUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(utf8.decode(response.bodyBytes));
        List<LikePost> fetchedPosts = (jsonData as List)
            .map((postJson) => LikePost.fromJson(postJson))
            .toList();
        setState(() {
          likedPosts = fetchedPosts;
        });
      } else {
        throw Exception('Failed to load liked posts');
      }
    } catch (e) {
      print('Error loading liked posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Info",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Obx(() => Row(
              children: [
                Text(
                  "${username.value}님, 좋은 하루 되세요!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
              ],
            )),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trip list",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.flight,
                  color: Colors.blue,
                  size: 30,
                ),
              ],
            ),
            SizedBox(height: 20),
            if (schedules.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "여행을 계획 해보세요!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: schedules.map((schedule) {
                  DateTime rangeStart = DateTime.parse(schedule['rangeStart']);
                  DateTime rangeEnd = DateTime.parse(schedule['rangeEnd']);
                  int daysLeft = rangeStart.difference(DateTime.now()).inDays;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              schedule['title'],
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "D-${daysLeft > 0 ? daysLeft : 0}",
                              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "좋아요한 게시글 목록",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: likedPosts.isEmpty
                  ? Center(
                child: Text(
                  "좋아요한 게시글이 없습니다.",
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: likedPosts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        likedPosts[index].title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        likedPosts[index].content,
                        style: TextStyle(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat.yMd().format(likedPosts[index].createDate),
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                likedPosts[index].likeCount.toString(),
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProfileWidget(),
  ));
}
