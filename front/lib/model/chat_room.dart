// chat_room.dart (모델)
class ChatRoom {
  final String roomId;
  final String roomName;

  ChatRoom({
    required this.roomId,
    required this.roomName,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['roomId'],
      roomName: json['roomName'],
    );
  }
}
