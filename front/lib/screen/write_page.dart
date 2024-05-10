import 'package:flutter/material.dart';
import 'package:front/screen/post_list.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  List<String> _selectedCategories = []; // 선택된 카테고리 목록
  String _selectedCategory = '0'; // Default category
  double _contentHeight = 80.0; // 기본 높이

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('글쓰기'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Submit 버튼을 눌렀을 때 호출되는 메서드
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.to(PostList());
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
                ),
              ),
              SizedBox(height: 16.0),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _contentHeight,
                child: TextField(
                  controller: _contentController,
                  onChanged: (value) {
                    setState(() {
                      // 입력된 텍스트에 따라 높이 업데이트
                      _contentHeight = 100.0 +
                          (_contentController.text.split('\n').length - 1) *
                              15.0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '내용을 입력하세요.',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.blue.shade200,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
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
    // 폼 제출 처리
    String title = _titleController.text;
    String content = _contentController.text;
    String category = _selectedCategory;

    // 데이터 처리
  }
}

void main() {
  runApp(MaterialApp(
    home: PostPage(),
  ));
}
