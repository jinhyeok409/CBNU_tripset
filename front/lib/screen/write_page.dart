import 'package:flutter/material.dart';
import 'package:front/screen/post_list.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostPage(),
    );
  }
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  List<String> _selectedCategories = []; // 선택된 카테고리 목록
  String _selectedCategory = '0'; // Default category
  double _contentHeight = 150.0; // 기본 높이

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 다른 곳을 터치했을 때 포커스를 제거하여 키보드가 사라지도록 함
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('글쓰기'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _handleSubmit(); // Submit 버튼을 눌렀을 때 호출되는 메서드
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // GetX의 네비게이션을 사용하여 페이지 이동
            },
          ),
        ),
        body: Padding(
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
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text('자유게시판'),
                      value: '0',
                      groupValue: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value.toString();
                        });
                      },
                      activeColor: Colors.blue.shade200,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text('여행게시판'),
                      value: '1',
                      groupValue: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value.toString();
                        });
                      },
                      activeColor: Colors.blue.shade200,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    // 제목과 내용 가져오기
    String title = _titleController.text;
    String content = _contentController.text;
    String category = _selectedCategory;

    // 제목과 내용이 비어 있는지 확인
    if (title.isEmpty || content.isEmpty) {
      // 제목 또는 내용이 비어 있으면 사용자에게 알림
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('경고'),
            content: Text('제목과 내용을 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return; // 유효성 검사 실패로 함수 종료
    }

    // 데이터 처리
  }
}
