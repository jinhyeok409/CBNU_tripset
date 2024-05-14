import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/screen/detail_page.dart';
import 'package:get/get.dart';
import 'package:front/model/post.dart'; // 게시물 모델 임포트

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(PostDetailPage());
}

class PostDetailPage extends StatelessWidget {
  //final Post post; // 클릭한 게시물 객체

  // 생성자
  //const PostDetailPage({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
            },
          ),
          actions: [
            //if (저자확인함수 가 참일시 보여지게)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // 게시물 수정 페이지로 이동
                Get.to(() => EditPostPage());
                //Get.to(() => EditPostPage(post: post));
              },
            ),
            IconButton(
              //if (저자확인함수 가 참일시 보여지게)
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
                "제목입니다",
                //post.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "내용입니다",
                //post.content,
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
                Get.to(() => EditPostPage());
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
                initialValue: "수정할 타이틀",
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
                initialValue: "수정할 본문",
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
