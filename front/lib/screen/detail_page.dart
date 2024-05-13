import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:front/model/post.dart'; // 게시물 모델 임포트

// 할 일 : postlist 에서 id값 넘겨주면 여기서 그거 바탕으로 서버에서 받아온 후
// 화면에 뿌리기 + 토큰 디코드해서 서버에서 받아온 저자 값과 일치하면 수정 삭제

// 게시글 상세 페이지
class PostDetailPage extends StatelessWidget {
  final Post post; // 클릭한 게시물 객체

  // 생성자
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 상세보기'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // 게시물 수정 페이지로 이동
              Get.to(() => EditPostPage(post: post));
            },
          ),
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
            // 게시물 제목
            Text(
              post.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // 게시물 내용
            Text(
              post.content,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// 게시물 수정 페이지
class EditPostPage extends StatelessWidget {
  final Post post; // 수정할 게시물 객체

  // 생성자
  const EditPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 게시물 제목 입력 필드
            TextFormField(
              initialValue: post.title,
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 16),
            // 게시물 내용 입력 필드
            TextFormField(
              initialValue: post.content,
              maxLines: null, // 여러 줄 입력 가능
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: '내용'),
            ),
            SizedBox(height: 16),
            // 수정 완료 버튼
            ElevatedButton(
              onPressed: () {
                // 게시물 수정 처리
                // 수정이 성공하면 이전 화면으로 이동 또는 다른 작업 수행
                // 예시: Get.back()을 호출하여 이전 화면으로 이동
              },
              child: Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

/* 게시물 목록 화면에서 게시물 클릭 시 이동하는 코드
GestureDetector(
  onTap: () {
    Get.to(() => PostDetailPage(post: post)); // 클릭한 게시물 객체를 전달
  },
  child: ListTile(
    // 게시물 내용을 표시하는 ListTile 위젯
  ),
)*/
