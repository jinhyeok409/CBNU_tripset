// chat_room.dart (모델)
class ChatRoom {
  final String roomName;

  ChatRoom({
    required this.roomName,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomName: json['roomName'],
    );
  }
}
