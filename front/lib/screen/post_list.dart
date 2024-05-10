import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/model/post.dart';
import 'package:get/get.dart';
import '../bottom_navigation_bar.dart';
import '../controller/infinite_scroll_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(PostList());
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final PostListScrollController postListScrollController =
        Get.put(PostListScrollController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
                          Obx(
                            () => InkWell(
                              onTap: () {
                                postListScrollController.currentCategory.value =
                                    'ALL';
                                postListScrollController.nextLink.value = '';
                                postListScrollController.reload();
                                // 전체게시판으로 이동 추후 구현
                              },
                              child: Text(
                                '전체',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: (postListScrollController
                                                .currentCategory.value ==
                                            'ALL')
                                        ? Color(0xFF1E1E1E)
                                        : Color(0xFFAFAFAF)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Obx(
                            () => InkWell(
                              onTap: () {
                                postListScrollController.currentCategory.value =
                                    'FREE';
                                postListScrollController.nextLink.value = '';
                                postListScrollController.reload();
                                // 자유게시판으로 이동 추후 구현
                              },
                              child: Text(
                                '자유',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: (postListScrollController
                                                .currentCategory.value ==
                                            'FREE')
                                        ? Color(0xFF1E1E1E)
                                        : Color(0xFFAFAFAF)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Obx(() => InkWell(
                                onTap: () {
                                  postListScrollController
                                      .currentCategory('PLAN');
                                  postListScrollController.nextLink.value = '';
                                  postListScrollController.reload();
                                  // 계획게시판으로 이동 추후 구현
                                },
                                child: Text(
                                  '계획',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: (postListScrollController
                                                  .currentCategory.value ==
                                              'PLAN')
                                          ? Color(0xFF1E1E1E)
                                          : Color(0xFFAFAFAF)),
                                ),
                              )),
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

          // 게시글 작성 버튼
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

// 게시글 목록
class PostListView extends StatelessWidget {
  final postListScrollController = Get.find<PostListScrollController>();
  PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 75),
      child: Obx(() {
        if (postListScrollController.isLoading.value &&
            postListScrollController.posts.isEmpty) {
          // 데이터를 로딩 중이며 불러온 게시물이 없을 때
          print('loaing posts...');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!postListScrollController.isLoading.value &&
            postListScrollController.posts.isEmpty) {
          // 로딩하지 않는 중이며 불러온 게시글이 없을 때
          print('loading: ${postListScrollController.isLoading.value}');
          print('postEmpty: ${postListScrollController.posts.isEmpty}');
          return Center(
            child: Text('게시물이 없습니다.'),
          );
        } else {
          // 데이터가 있는 경우 게시물 목록 표시
          return ListView.separated(
            controller: postListScrollController.scrollController.value,
            itemCount: postListScrollController.posts.length +
                (postListScrollController.hasMore.value ? 1 : 0),
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              // 인덱스가 불러온 게시글 수보다 작은 경우 (불러온 게시글 출력)
              if (index < postListScrollController.posts.length) {
                Post post = postListScrollController.posts[index];
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
                          if (post.commentCount > 0) ...[
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
                          ]
                        ],
                      ),
                    ],
                  ),
                );
              } else if (postListScrollController.hasMore.value) {
                // 더 불러올 데이터가 있는 경우
                return Center(
                    child: //CircularProgressIndicator(),
                        LoadingAnimationWidget.hexagonDots(
                            color: Colors.black, size: 40));
              } else {
                // 불러올 데이터가 없는 경우
                return SizedBox(
                  child: Column(
                    children: [
                      Text('게시글이 없습니다.'),
                      IconButton(
                          onPressed: postListScrollController.reload(),
                          icon: Icon(Icons.refresh)),
                    ],
                  ),
                );
              }
            },
          );
        }
      }),
    );
  }
}
