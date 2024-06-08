import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chat_room_controller.dart';
import '../../model/chat_room.dart';

class ChatRoomPage extends StatelessWidget {
  final ChatRoom chatRoom;

  ChatRoomPage({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    final ChatRoomController controller =
        Get.put(ChatRoomController(chatRoom: chatRoom));

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.chatRoom.roomName),
      ),
      body: GestureDetector(
        onTap: controller.dismissKeyboard,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          bool isMe = controller.messages[index]['sender'] ==
                              controller.username.value;
                          bool isEnter =
                              controller.messages[index]['type'] == 'ENTER';
                          return isEnter
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent),
                                      child: Text(
                                        controller.messages[index]['message']!,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          controller.messages[index]['sender']!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: isMe
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Text(
                                          controller.messages[index]
                                              ['message']!,
                                          style: TextStyle(
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: controller.sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
