// chat_room_page.dart (채팅방 상세 페이지)
import 'package:flutter/material.dart';
import '../model/chat_room.dart';

class ChatRoomPage extends StatelessWidget {
  final ChatRoom chatRoom;

  ChatRoomPage({required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoom.name),
      ),
      body: Center(
        child: Text('Welcome to ${chatRoom.name}'),
      ),
    );
  }
}
