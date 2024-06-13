import 'package:flutter/material.dart';
import 'package:front/screen/chat/chat_room_page.dart';
import 'package:get/get.dart';
import '../../controller/chat_list_controller.dart';
import 'dart:math';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatListController chatController = Get.put(ChatListController());

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
                'CHAT ROOM.',
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
            return Center(child: Text('채팅방이 없습니다. \n채팅방을 만들어 보세요!'));
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
                        // subtitle: Text(
                        //   chatRoom.roomName,
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.normal,
                        //     color: Colors.grey,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Get.to(() => ChatRoomPage(chatRoom: chatRoom),
                              transition: Transition.rightToLeft);
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
        // 채팅방 생성 버튼
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            heroTag: 'create_chat_room',
            backgroundColor: Color(0xFF5BB6FF),
            shape: CircleBorder(),
            onPressed: () {
              Get.dialog(CreateChatRoomDialog());
            },
            child: Icon(
              Icons.maps_ugc_outlined,
              color: Colors.white,
            ),
          ),
        ));
  }
}

// 채팅방 이름 입력 폼
class CreateChatRoomDialog extends StatelessWidget {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  CreateChatRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '채팅방 만들기',
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '채팅방 이름',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '채팅방 이름을 설정해주세요.';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text('만들기'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String chatRoomName = _controller.text.trim();
              Get.find<ChatListController>().createChatRoom(chatRoomName);
              Get.back();
            }
          },
        ),
      ],
    );
  }
}
