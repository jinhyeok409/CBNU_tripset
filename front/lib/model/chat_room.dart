// chat_room.dart (모델)
class ChatRoom {
  final String name;
  final String lastMessage;

  ChatRoom({required this.name, required this.lastMessage});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      name: json['name'],
      lastMessage: json['last_message'],
    );
  }
}
