// chat_controller.dart (컨트롤러)
import 'package:get/get.dart';
import '../model/chat_room.dart';

class ChatController extends GetxController {
  var chatRooms = <ChatRoom>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
  }

  void fetchChatRooms() {
    var dummyChatRooms = [
      ChatRoom(
          id: '1',
          name: '6/7 부산 당일치기 여행',
          lastMessage: '어디로 가야함??',
          lastMessageTime: DateTime.now()),
      ChatRoom(
          id: '2',
          name: '바이크 타는 사람들 모임',
          lastMessage: '아.. 기름 충전해야 되는데',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 1))),
      ChatRoom(
          id: '3',
          name: '충북대 방학 여행모임',
          lastMessage: '경주 놀러가실 분~',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2))),
      ChatRoom(
          id: '4',
          name: '충남대 방학 여행모임',
          lastMessage: '서울 놀러가실 분~',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2))),
      ChatRoom(
          id: '5',
          name: '청주대 방학 여행모임',
          lastMessage: '어디든지 놀러가실 분~',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2))),
    ];

    chatRooms.assignAll(dummyChatRooms);
  }
}
