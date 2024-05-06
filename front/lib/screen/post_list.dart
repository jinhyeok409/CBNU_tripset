import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../bottom_navigation_bar.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(PostList());
}

class PostCategoryController extends GetxController {
  RxInt currentCategory = 0.obs;

  void selectCategory(int index) {
    currentCategory.value = index;
    print('selected Category value is ${currentCategory.value}');
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final PostCategoryController postCategoryController =
        Get.put(PostCategoryController());
    return GetMaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                  child: Row(
                    children: [
                      // 게시판 카테고리
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                postCategoryController.selectCategory(0);
                                // 자유게시판으로 이동 추후 구현
                              },
                              child: Obx(
                                () => Text(
                                  '자유',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: (postCategoryController
                                                  .currentCategory.value ==
                                              0)
                                          ? Color(0xFF1E1E1E)
                                          : Color(0xFFAFAFAF)),
                                ),
                              )),
                          SizedBox(
                            width: 25,
                          ),
                          InkWell(
                              onTap: () {
                                postCategoryController.selectCategory(1);
                                // 계획게시판으로 이동 추후 구현
                              },
                              child: Obx(
                                () => Text(
                                  '계획',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: (postCategoryController
                                                  .currentCategory.value ==
                                              1)
                                          ? Color(0xFF1E1E1E)
                                          : Color(0xFFAFAFAF)),
                                ),
                              ))
                        ],
                      ),

                      Spacer(),

                      // 상단 아이콘
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.search),
                            iconSize: 35,
                            color: Color(0xFF565656),
                            onPressed: () {
                              // 검색기능 추후 구현
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_outline),
                            iconSize: 35,
                            color: Color(0xFF565656),
                            onPressed: () {
                              // 좋아요 목록으로 이동 추후 구현
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: Color(0xFFCDCDCD),
                )
              ],
            ),
          ),
          body: Stack(children: [
            PostListView(),

            // bottomNavigaitionBar
            Align(
              alignment: Alignment.bottomCenter,
              child: GetBuilder<BottomNavController>(
                init: BottomNavController(),
                builder: (controller) => BottomNavBar(),
              ),
            ),
          ]),
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  backgroundColor: Color(0xFF5BB6FF),
                  shape: CircleBorder(),
                  onPressed: () {
                    // 게시글 작성 페이지로 이동 추후 구현
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ))),
    );
  }
}

// Post 모델
class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createDate;
  final String authorName;
  final int commentCount;
  final int likeCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createDate,
    required this.authorName,
    required this.commentCount,
    required this.likeCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createDate: DateTime.parse(json['createDate']),
      authorName: json['author']['username'],
      commentCount: json['commentDTOList'].length,
      likeCount: json['likeCount'],
    );
  }
}

// 서버에서 데이터 받아오기
class PostService extends GetConnect {
  Future<List<Post>> getPosts() async {
    String postUri = dotenv.env['POST_URI']!;
    Response response = await get(postUri);
    if (response.status.hasError) {
      throw Exception('게시글 불러오기 실패');
    }
    List<dynamic> data = response.body;
    return data.map((json) => Post.fromJson(json)).toList();
  }
}

// 게시글 목록
class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 75),
      child: FutureBuilder(
        future: PostService().getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              '오류 발생.\n다시 시도해주세요.',
              style: TextStyle(fontSize: 30),
            ));
          } else {
            List<Post> posts = snapshot.data!;
            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                Post post = posts[index];
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(14, 0, 14, 5),
                  title: Text(
                    post.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Text(
                          post.content,
                          style:
                              TextStyle(color: Color(0xFF565656), fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 날짜와 작성자
                          Text(
                            '${post.createDate.month.toString().padLeft(2, '0')}/${post.createDate.day.toString().padLeft(2, '0')}  ${post.authorName}',
                            style: TextStyle(
                                color: Color(0xFF9F9F9F), fontSize: 16),
                          ),

                          // 댓글 개수
                          Spacer(),
                          if (post.commentCount > 0) ...[
                            Icon(Icons.notes,
                                size: 20, color: Color(0xFF565656)),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              post.commentCount.toString(),
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF565656)),
                            ),
                          ],
                          // 좋아요 개수
                          SizedBox(
                            width: 13,
                          ),
                          Icon(Icons.favorite_border,
                              size: 20, color: Color(0xFF565656)),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            post.likeCount.toString(),
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF565656)),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
