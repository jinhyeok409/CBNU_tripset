import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/controller/post_list_scroll_controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // 게시물 모델 임포트

// 업데이트랑 삭제 부분 구현 하고 + 아이디값 적용해서 url관리
// 댓글 부분

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  PostDetailPageState createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final storage = FlutterSecureStorage();
  String title = "";
  String content = "";
  String username = "";
  //String createDate = "";
  DateTime createDate = DateTime.now();
  int likeCount = 0;
  bool isLiked = false;
  bool isCommentLiked = false;
  String tokenUsername = "";
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;

  bool isAuthorVerified(String username, String tokenUsername) {
    // username과 tokenUsername을 비교하여 일치 여부를 확인하고 true 또는 false 반환
    return username == tokenUsername;
  }

  bool isCommentAuthorVerified(String commentUsername, String tokenUsername) {
    // username과 tokenUsername을 비교하여 일치 여부를 확인하고 true 또는 false 반환
    return commentUsername == tokenUsername;
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
    tokenUsername = decodedToken['username'];
  }

  Future<void> fetchPostData() async {
    String postId = Get.arguments;
    String serverUri = dotenv.env['SERVER_URI']!;
    String postEndpoint = dotenv.env['POST_ENDPOINT']!;
    final response =
        await http.get(Uri.parse('$serverUri$postEndpoint/$postId'));

    _commentController.text = ''; // 댓글 작성용

    if (response.statusCode == 200) {
      // 서버에서 데이터를 성공적으로 받았을 때
      print("success");
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        title = data['title'];
        content = data['content'];
        username = data['author']['username'];
        comments = List<Map<String, dynamic>>.from(data['commentDTOList']);
        createDate = DateTime.parse(data['createDate']);
        likeCount = data['likeCount'];
        isLoading = false;
      });
    } else {
      print("fail");
      // 서버로부터 데이터를 받지 못했을 때
      throw Exception('Failed to load post data');
    }
  }

  Future<void> postLike() async {
    // 수정해야함
    String? token = await storage.read(key: 'accessToken');
    if (token == null) {
      print('Token is null');
      return;
    }

    String postId = Get.arguments;
    String serverUri = dotenv.env['SERVER_URI']!;
    String likeEndpoint = dotenv.env['POST_LIKE_ENDPOINT']!;
    String likeUrl = "$serverUri$likeEndpoint/$postId";

    Map<String, String> headers = {
      'Authorization': '$token',
    };

    try {
      final response = await http.post(Uri.parse(likeUrl), headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          isLiked = !isLiked;
          fetchPostData();
        });
      } else {
        print("Failed to toggle like, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error toggling like: $e");
    }
  }

  Future<void> deletePost(BuildContext context, String postId) async {
    // 추가: 사용자의 확인 여부를 받기 위한 다이얼로그 표시
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게시물 삭제'),
          content: Text('게시물을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 취소 버튼 클릭 시 false 반환
              },
              child: Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 확인 버튼 클릭 시 true 반환
              },
              child: Text('아니오'),
            ),
          ],
        );
      },
    );

    // 사용자가 확인을 선택한 경우에만 게시물 삭제 진행
    if (confirmDelete == true) {
      String? token = await storage.read(key: 'accessToken');
      String serverUri = dotenv.env['SERVER_URI']!;
      String deleteEndpoint = dotenv.env['POST_DELETE_ENDPOINT']!;

      Map<String, String> headers = {
        'Authorization': '$token', // 토큰 값 추가
      };

      try {
        String deleteUrl = "$serverUri$deleteEndpoint/$postId";

        // HTTP DELETE 요청 보내기
        var response = await http.delete(
          Uri.parse(deleteUrl),
          headers: headers,
        );

        if (response.statusCode == 200) {
          // 삭제 성공 시
          print("게시물 삭제 성공");
          // 이전 화면으로 이동 또는 다른 작업 수행
          //Get.offNamed('/postList');
          Get.find<PostListScrollController>().reload();
          Get.offAllNamed('/root');
        } else {
          // 삭제 실패 시
          print("게시물 삭제 실패: ${response.statusCode}");
          // 실패 메시지를 표시하거나 사용자에게 알림
        }
      } catch (e) {
        // 오류 발생 시 처리
        print("오류 발생: $e");
      }
    }
  }

  Future<void> likeComment(BuildContext context, String commentId) async {
    // 수정해야함
    String? token = await storage.read(key: 'accessToken');
    if (token == null) {
      print('Token is null');
      return;
    }

    String serverUri = dotenv.env['SERVER_URI']!;
    String likeEndpoint = dotenv.env['COMMENT_LIKE_ENDPOINT']!;
    String likeCommentUrl = "$serverUri$likeEndpoint/$commentId";

    Map<String, String> headers = {
      'Authorization': '$token',
    };

    try {
      final response =
          await http.post(Uri.parse(likeCommentUrl), headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          isCommentLiked = !isCommentLiked;
          fetchPostData();
        });
      } else {
        print("Failed to toggle like, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error toggling like: $e");
    }
  }

  Future<void> createComment(BuildContext context) async {
    String? token = await storage.read(key: 'accessToken');
    String serverUri = dotenv.env['SERVER_URI']!;
    String createEndpoint = dotenv.env['COMMENT_CREATE_ENDPOINT']!;
    String postId = Get.arguments;
    String comment = _commentController.text;

    Map<String, String> headers = {
      'Authorization': '$token', // 토큰 값 추가
    };

    try {
      String createCommentUrl = "$serverUri$createEndpoint/$postId";
      if (comment.isEmpty) {
        Get.dialog(
          AlertDialog(
            title: Text('경고'),
            content: Text('내용을 입력해주세요.'),
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
        // HTTP POST 요청 보내기
        var response = await http.post(
          Uri.parse(createCommentUrl),
          headers: headers,
          body: {
            'comment': comment,
          },
        );

        if (response.statusCode == 200) {
          // 댓글 작성 성공 시
          print("댓글 작성 성공");
          // 이전 화면으로 이동 또는 다른 작업 수행
          Get.offNamed('/postDetail', arguments: postId.toString());
          fetchPostData();
        } else {
          print(postId);
          print(response.statusCode);
          // 댓글 작성 실패 시
          print("댓글 작성 실패");
          // 실패 메시지를 표시하거나 사용자에게 알림
        }
      }
    } catch (e) {
      print("오류 발생: $e");
      // 오류 처리
    }
  }

  /*Future<void> modifyComment(BuildContext context) async {
    String? token = await storage.read(key: 'accessToken');
    String serverUri = dotenv.env['SERVER_URI']!;
    String modifyEndpoint = dotenv.env['COMMENT_MODIFY_ENDPOINT']!;
    String postId = Get.arguments;
    String comment = _commentController.text;

    Map<String, String> headers = {
      'Authorization': '$token', // 토큰 값 추가
    };

    try {
      String createCommentUrl = "$serverUri$modifyEndpoint/$postId";
      if (comment.isEmpty) {
        Get.dialog(
          AlertDialog(
            title: Text('경고'),
            content: Text('내용을 입력해주세요.'),
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
        // HTTP POST 요청 보내기
        var response = await http.post(
          Uri.parse(createCommentUrl),
          headers: headers,
          body: {
            'comment': comment,
          },
        );

        if (response.statusCode == 200) {
          // 댓글 작성 성공 시
          print("댓글 작성 성공");
          // 이전 화면으로 이동 또는 다른 작업 수행
          Get.offNamed('/postDetail', arguments: postId.toString());
          fetchPostData();
        } else {
          print(postId);
          print(response.statusCode);
          // 댓글 작성 실패 시
          print("댓글 작성 실패");
          // 실패 메시지를 표시하거나 사용자에게 알림
        }
      }
    } catch (e) {
      print("오류 발생: $e");
      // 오류 처리
    }
  }*/

  Future<void> deleteComment(BuildContext context, String commentId) async {
    // 추가: 사용자의 확인 여부를 받기 위한 다이얼로그 표시
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('댓글 삭제'),
          content: Text('댓글을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 취소 버튼 클릭 시 false 반환
              },
              child: Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 확인 버튼 클릭 시 true 반환
              },
              child: Text('아니오'),
            ),
          ],
        );
      },
    );

    // 사용자가 확인을 선택한 경우에만 댓글 삭제 진행
    if (confirmDelete == true) {
      String? token = await storage.read(key: 'accessToken');
      String serverUri = dotenv.env['SERVER_URI']!;
      String deleteEndpoint = dotenv.env['COMMENT_DELETE_ENDPOINT']!;
      String deleteUrl = "$serverUri$deleteEndpoint/$commentId";

      Map<String, String> headers = {
        'Authorization': '$token', // 토큰 값 추가
      };

      try {
        var response = await http.delete(
          Uri.parse(deleteUrl),
          headers: headers,
        );

        if (response.statusCode == 200) {
          print("댓글 삭제 성공");
          fetchPostData();
        } else {
          print("댓글 삭제 실패: ${response.statusCode}");
        }
      } catch (e) {
        print("오류 발생: $e");
      }
    }
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
        title: 'DetailPage',
        home: Scaffold(
          appBar: AppBar(
              title: null,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.find<PostListScrollController>().reload();
                  Get.offAllNamed('/root');
                },
              ),
              actions: [
                if (!isLoading &&
                    isAuthorVerified(username, tokenUsername)) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.toNamed('/updatePost', arguments: Get.arguments);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deletePost(context, Get.arguments);
                    },
                  ),
                ],
              ]),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    username,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${createDate.month.toString().padLeft(2, '0')}/${createDate.day.toString().padLeft(2, '0')} ${createDate.hour.toString().padLeft(2, '0')}:${createDate.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                content,
                                style: TextStyle(fontSize: 18),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    '댓글 ${comments.length}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Text(likeCount.toString()),
                                  IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked ? Colors.red : null,
                                    ),
                                    onPressed: () {
                                      postLike();
                                    },
                                  ),
                                ],
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (_, index) {
                                  final comment = comments[index];
                                  final commentId = comment['id'];
                                  // final isCommentLiked = /* isCommentLiked 로직 추가 */;
                                  // final tokenUsername = /* tokenUsername 로직 추가 */;

                                  return ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 3.0),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            comment['author']['username'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          comment['likeCount'].toString(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isCommentLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isCommentLiked
                                                ? Colors.red
                                                : null,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            likeComment(
                                                context, commentId.toString());
                                          },
                                        ),
                                        if (isCommentAuthorVerified(
                                            comment['author']['username'],
                                            tokenUsername))
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              deleteComment(context,
                                                  commentId.toString());
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          )
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            comment['comment'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                // separatorBuilder: (_, index) => SizedBox(
                                //   height: 1.0,
                                //   child: DecoratedBox(
                                //     decoration: BoxDecoration(
                                //       color: Colors.black12,
                                //     ),
                                //   ),
                                // ),
                                separatorBuilder: (_, index) =>
                                    Divider(thickness: 1.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                labelText: '내용을 입력하세요.',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            color: Colors.blue.shade200,
                            onPressed: () {
                              createComment(context);
                              print('댓글 작성 버튼 눌림');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class EditPostPage extends StatefulWidget {
  const EditPostPage({super.key});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _posttitleController;
  late TextEditingController _postcontentController;
  String _selectedCategory =
      Get.find<PostListScrollController>().currentCategory.value;
  late String _postId;

  @override
  void initState() {
    super.initState();
    // Get.arguments에서 인수를 받아오는 부분
    final Map<String, dynamic> args = Get.arguments;
    final String title = args['title'];
    final String content = args['content'];
    _postId = args['postId'];

    _posttitleController = TextEditingController(text: title);
    _postcontentController = TextEditingController(text: content);
  }

  @override
  void dispose() {
    _posttitleController.dispose();
    _postcontentController.dispose();
    super.dispose();
  }

  void updatePost(BuildContext context) async {
    print("포스트 아이디");
    print(_postId);
    final storage = FlutterSecureStorage();
    String serverUri = dotenv.env['SERVER_URI']!;
    String postUpdateEndpoint =
        dotenv.env['POST_UPDATE_ENDPOINT']!; // 업데이트할 게시물의 URL
    String updateUrl = "$serverUri$postUpdateEndpoint/$_postId";
    String category = _selectedCategory;

    String? token = await storage.read(key: 'accessToken');
    Map<String, String> headers = {
      'Authorization': '$token', // 토큰 값 추가
    };

    String newTitle = _posttitleController.text;
    String newContent = _postcontentController.text;

    try {
      final response = await http.put(
        Uri.parse(updateUrl),
        headers: headers,
        body: {
          'title': newTitle,
          'content': newContent,
          'category': category,
        },
      );

      if (response.statusCode == 200) {
        // 게시물 업데이트가 성공한 경우
        print('게시물이 성공적으로 업데이트되었습니다.');
        Get.offNamed('/postDetail', arguments: _postId.toString());
      } else {
        // 게시물 업데이트가 실패한 경우
        print('게시물 업데이트 실패: ${response.statusCode}');
        // 실패 메시지를 사용자에게 보여줄 수 있습니다.
        // 예를 들어 Get 패키지를 사용하여 에러 다이얼로그를 표시할 수 있습니다.
      }
    } catch (e) {
      // 예외 발생 시 처리
      print('게시물 업데이트 중 에러 발생: $e');
      // 예외 처리 로직을 추가할 수 있습니다.
    }
  }

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
          centerTitle: true,
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
                updatePost(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _posttitleController,
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
              TextFormField(
                controller: _postcontentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: '내용',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.blue.shade200,
                  ),
                  border: InputBorder.none,
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
