import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/screen/chat/chat_room_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/chat_room.dart';

class ChatListController extends GetxController {
  var chatRooms = <ChatRoom>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
  }

  // 채팅방 불러오기
  Future<void> fetchChatRooms() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'accessToken');
    String serverUri = dotenv.env['SERVER_URI']!;
    String chatRoomsEndpoint = dotenv.env['CHAT_ROOMS_ENDPOINT']!;
    String chatRoomsUrl = "$serverUri$chatRoomsEndpoint";

    Map<String, String> headers = {
      'Authorization': '$token',
    };

    final response = await http.get(
      Uri.parse(chatRoomsUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      chatRooms.value =
          data.map((chatRoom) => ChatRoom.fromJson(chatRoom)).toList();
    } else {
      Get.snackbar('Error', '채팅방을 불러오지 못 했습니다. 연결을 확인해주세요.');
      print('chat room loading faild: ${response.statusCode}');
    }
  }

  // 채팅방 생성하기
  Future<void> createChatRoom(String name) async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'accessToken');
    String serverUri = dotenv.env['SERVER_URI']!;
    String createRoomEndpoint = dotenv.env['CREATE_ROOM_ENDPOINT']!;
    String createRoomUrl = "$serverUri$createRoomEndpoint?name=$name";

    Map<String, String> headers = {
      'Authorization': '$token',
    };

    final response = await http.post(
      Uri.parse(createRoomUrl),
      headers: headers,
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 200) {
      fetchChatRooms();
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      var newChatRoom = ChatRoom.fromJson(responseData);
      Get.to(() => ChatRoomPage(chatRoom: newChatRoom),
          transition: Transition.rightToLeft);
    } else {
      Get.snackbar('Error', '채팅방을 생성하지 못 했습니다. 연결을 확인해주세요.');
      print('chat room creating faild: ${response.statusCode}');
    }
  }
}
