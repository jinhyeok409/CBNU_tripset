import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../../model/chat_room.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ChatRoomController extends GetxController {
  final ChatRoom chatRoom;
  late StompClient stompClient;
  RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  RxString username = ''.obs;
  RxBool isLoading = true.obs;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController(
      initialScrollOffset: double.maxFinite); // 경고 뜰 수 있음. 무시해도 됨.

  ChatRoomController({required this.chatRoom});

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    stompClient.deactivate();
    super.onClose();
  }

  Future<void> init() async {
    // stomp 연결
    String serverWebsocketUri = dotenv.env['SERVER_WEBSOCKET_URI']!;
    String stompEndpoint = dotenv.env['STOMP_ENDPOINT']!;
    String port = dotenv.env['PORT']!;
    stompClient = StompClient(
      config: StompConfig(
        url: '$serverWebsocketUri:$port$stompEndpoint',
        onConnect: _onConnect,
        beforeConnect: () async {
          await Future.delayed(Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient.activate();

    loadUsername();
  }

  // 채팅 내역 불러오기
  Future<void> fetchChatHistory() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'accessToken');
    String? serverUri = dotenv.env['SERVER_URI'];

    Map<String, String> headers = {
      'Authorization': '$token',
    };

    final response = await http.get(
      Uri.parse('$serverUri/chat/history?roomId=${chatRoom.roomId}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> history = json.decode(utf8.decode(response.bodyBytes));
      messages.assignAll(
          history.map((msg) => Map<String, String>.from(msg)).toList());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        } else {
          print('scrollController has no client!');
        }
      });
      isLoading(false);
    } else {
      isLoading(false);
      print('Failed to load chat history');
    }
  }

  void _onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/sub/chatRoom/${chatRoom.roomId}',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          messages.add(Map<String, String>.from(json.decode(frame.body!)));
          scrollToRecentMessage();
        }
      },
    );
    fetchChatHistory();
  }

  // username 불러오기
  void loadUsername() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'accessToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    username.value = decodedToken['username'];
  }

  // 메시지 보내기
  void sendMessage() {
    String message = messageController.text.trim();

    if (message.isNotEmpty) {
      stompClient.send(
        destination: '/pub/chat/message',
        body: json.encode({
          'type': 'TALK',
          'sender': username.value,
          'roomId': chatRoom.roomId,
          'message': message,
        }),
        headers: {},
      );
      messageController.clear();
      scrollToRecentMessage();
    }
  }

  // 화면 스크롤 애니메이션
  void scrollToRecentMessage() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // 키보드 숨기기
  void dismissKeyboard() {
    Get.focusScope!.unfocus();
  }
}
