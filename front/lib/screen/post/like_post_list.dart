import 'package:flutter/material.dart';
import 'package:front/controller/like_post_list_controller.dart';
import 'package:get/get.dart';

class LikePostList extends GetView<LikePostListController> {
  const LikePostList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LikePostListController());
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            '좋아요한 글 목록',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          )),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.separated(
            itemCount: controller.posts.length,
            itemBuilder: (_, index) {
              final post = controller.posts[index];
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
                        maxLines: 2,
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
                          style:
                              TextStyle(color: Color(0xFF9F9F9F), fontSize: 16),
                        ),
                        // 댓글 개수
                        Spacer(),
                        if (post.commentCount! > 0) ...[
                          Icon(Icons.notes, size: 20, color: Color(0xFF565656)),
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
                        if (post.likeCount > 0) ...[
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
                onTap: () =>
                    Get.toNamed('/postDetail', arguments: post.id.toString()),
              );
            },
            separatorBuilder: (_, index) => Divider(
              color: Color(0xFFE0E0E0),
              height: 1,
            ),
          );
        }
      }),
    );
  }
}
