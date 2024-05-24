// chat_list_page.dart (채팅방 목록 페이지)
import 'package:flutter/material.dart';
import 'package:front/screen/chat_room_page.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import '../model/chat_room.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방 목록'),
      ),
      body: Obx(() {
        if (chatController.chatRooms.isEmpty) {
          return Center(child: Text('No chat rooms available.'));
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '채팅방 목록',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chatController.chatRooms.length,
                  itemBuilder: (context, index) {
                    final chatRoom = chatController.chatRooms[index];
                    return ListTile(
                      title: Text(chatRoom.name),
                      subtitle: Text(chatRoom.lastMessage),
                      onTap: () {
                        Get.to(() => ChatRoomPage(chatRoom: chatRoom));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
