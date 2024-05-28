import 'package:flutter/material.dart';
import 'package:front/screen/chat/chat_room_page.dart';
import 'package:get/get.dart';
import '../../controller/chat_controller.dart';
import 'dart:math';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    Color getRandomColor() {
      Random random = Random();
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        title: Row(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
            Text(
              'TRIPSET.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFB0D1F8),
                fontSize: 40,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      body: Obx(() {
        if (chatController.chatRooms.isEmpty) {
          return Center(child: Text('No chat rooms available.'));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '채팅방 목록',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: chatController.chatRooms.length,
                  itemBuilder: (context, index) {
                    final chatRoom = chatController.chatRooms[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getRandomColor(),
                        radius: 25,
                        child: Text(
                          chatRoom.roomName[0], // 채팅방 이름의 첫 글자
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      title: Text(
                        chatRoom.roomName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        chatRoom.roomName,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Get.to(() => ChatRoomPage(chatRoom: chatRoom));
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 20,
                    thickness: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
