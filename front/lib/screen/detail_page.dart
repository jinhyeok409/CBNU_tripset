import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/screen/login.dart';
import 'package:http/http.dart' as http;
import 'package:front/screen/detail_page.dart';
import 'package:get/get.dart';
import 'package:front/model/post.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // 게시물 모델 임포트

// 업데이트랑 삭제 부분 구현 하고 + 아이디값 적용해서 url관리
// 댓글 부분
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(PostDetailPage());
}

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  PostDetailPageState createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  final storage = FlutterSecureStorage();
  String title = "";
  String content = "";
  String username = "";
  String tokenUsername = "";

  bool isAuthorVerified(String username, String tokenUsername) {
    // username과 tokenUsername을 비교하여 일치 여부를 확인하고 true 또는 false 반환
    return username == tokenUsername;
  }

  @override
  void initState() {
    super.initState();
    decodeToken();
    fetchPostData(); // initState에서 데이터 가져오기
  }

  Future<void> decodeToken() async {
    String? token = await storage.read(key: 'accessToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    print('토큰: $token');
    print(decodedToken);
    tokenUsername = decodedToken['username'];
    print("토큰 유저네임");
    print(tokenUsername);
  }

  Future<void> fetchPostData() async {
    String postId = Get.arguments;
    String serverUri = dotenv.env['SERVER_URI']!;
    String postEndpoint = dotenv.env['POST_ENDPOINT']!;
    print('$serverUri$postEndpoint/$postId');
    final response =
        await http.get(Uri.parse('$serverUri$postEndpoint/$postId'));
    if (response.statusCode == 200) {
      // 서버에서 데이터를 성공적으로 받았을 때
      print("success");
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        title = data['title'];
        content = data['content'];
        username = data['author']['username'];
      });
      print("유저네임");
      print(username);
    } else {
      print("fail");
      // 서버로부터 데이터를 받지 못했을 때
      throw Exception('Failed to load post data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DetailPage',
      home: Scaffold(
        appBar: AppBar(
          title: null,
          leading: IconButton(
            // 왼쪽에 뒤로가기 아이콘 추가
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // 뒤로가기 버튼이 눌렸을 때의 동작 설정
              // 예시: Get.back()을 호출하여 이전 화면으로 이동
              Get.back();
            },
          ),
          actions: [
            if (isAuthorVerified(username, tokenUsername)) // 저자 확인 함수 호출
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // 게시물 수정 페이지로 이동
                  Get.to(() => EditPostPage(title: title, content: content));
                  //Get.to(() => EditPostPage(post: post));
                },
              ),
            if (isAuthorVerified(username, tokenUsername)) // 저자 확인 함수 호출
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // 게시물 삭제 처리
                  // 삭제가 성공하면 이전 화면으로 이동 또는 다른 작업 수행
                  // 예시: Get.back()을 호출하여 이전 화면으로 이동
                },
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditPostPage extends StatelessWidget {
  final String title;
  final String content;

  EditPostPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 다른 곳을 탭하면 포커스 해제
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('게시물 수정'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                //Get.to(() => EditPostPage());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  labelText: '제목',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.blue.shade200,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: content,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: '내용',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.blue.shade200,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
