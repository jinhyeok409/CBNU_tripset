import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/screen/post/detail_page.dart';
import 'package:front/screen/post/post_list.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../controller/post_list_scroll_controller.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(PostPage());
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory =
      Get.find<PostListScrollController>().currentCategory.value != 'PLAN'
          ? 'FREE'
          : Get.find<PostListScrollController>().currentCategory.value;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    readToken(); // 토큰 읽어오기
  }

  Future<void> readToken() async {
    String? token = await storage.read(key: 'accessToken');
    // 여기서 토큰을 사용할 수 있음
    print('토큰: $token');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 포커스 해제
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('글쓰기'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _handleSubmit(context); // Submit 버튼을 눌렀을 때 호출되는 메서드
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Navigate to the PostList screen
                print('back to Postlist');
                //Get.to(PostList());
                Get.back();
                //Get.offNamed('postList');
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
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
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text('자유게시판'),
                          value: 'FREE',
                          groupValue: _selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                              print(_selectedCategory);
                            });
                          },
                          activeColor: Colors.blue.shade200,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text('계획게시판'),
                          value: 'PLAN',
                          groupValue: _selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                              print(_selectedCategory);
                            });
                          },
                          activeColor: Colors.blue.shade200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _contentController,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: '내용을 입력하세요.',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.blue.shade200,
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null, // 텍스트 필드의 높이를 사용자가 입력한 텍스트에 따라 자동으로 조정
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) async {
    String title = _titleController.text;
    String content = _contentController.text;
    String category = _selectedCategory;

    // 토큰 값 읽어오기
    String? token = await storage.read(key: 'accessToken');
    await dotenv.load(fileName: ".env");

    String serverUri = dotenv.env['SERVER_URI']!;
    String postCreateEndpoint = dotenv.env['POST_CREATE_ENDPOINT']!;
    String postCreateUri = '$serverUri$postCreateEndpoint';

    try {
      // 제목과 내용이 비어 있는지 확인
      if (title.isEmpty || content.isEmpty) {
        // 제목 또는 내용이 비어 있으면 사용자에게 알림
        Get.dialog(
          AlertDialog(
            title: Text('경고'),
            content: Text('제목과 내용을 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Get 패키지의 dialog 메서드를 사용하여 다이얼로그를 닫습니다.
                  Get.back();
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      } else {
        // HTTP 요청 헤더 설정
        Map<String, String> headers = {
          'Authorization': '$token', // 토큰 값 추가
        };

        var response = await http.post(
          Uri.parse(postCreateUri),
          headers: headers,
          body: {
            'title': title,
            'content': content,
            'category': category,
          },
        );

        if (response.statusCode == 200) {
          print('create post');
          print(response.body);
          Map<String, dynamic> responseData = json.decode(response.body);
          int id = responseData['id'];
          Get.offNamed('/postDetail', arguments: id.toString());
        } else {
          print(response.body);
          print(response.headers);
          print(response.statusCode);
          print("fail");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
