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
          name: 'Chat Room 1',
          lastMessage: 'Hello!',
          lastMessageTime: DateTime.now()),
      ChatRoom(
          id: '2',
          name: 'Chat Room 2',
          lastMessage: 'Hi there!',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 1))),
      ChatRoom(
          id: '3',
          name: 'Chat Room 3',
          lastMessage: 'Good morning!',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2))),
    ];

    chatRooms.assignAll(dummyChatRooms);
  }
}
