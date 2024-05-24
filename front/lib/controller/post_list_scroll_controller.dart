import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../model/post.dart';

class PostListScrollController extends GetxController {
  static PostListScrollController get instance => Get.find();

  var scrollController = ScrollController().obs;
  var posts = <Post>[].obs;
  var isLoading = false.obs;
  var hasMore = false.obs;
  var nextLink = ''.obs;
  var currentCategory = 'ALL'.obs;

  @override
  void onInit() {
    super.onInit();
    _getData(category: currentCategory.value);
    scrollController.value.addListener(() {
      try {
        if (scrollController.value.position.pixels ==
                scrollController.value.position.maxScrollExtent &&
            hasMore.value) {
          _getData(category: currentCategory.value);
        }
      } catch (e) {
        print('Error in scrollController listener: $e');
      }
    });
  }

  @override
  void onClose() {
    print('onClose');
    scrollController.value.dispose();
    super.onClose();
  }

  _getData({String? category}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      String postUri;
      // json 요청 보낸 적이 있음(게시글 더 불러오기)
      if (nextLink.value.isNotEmpty) {
        postUri = nextLink.value;
      } else {
        // json 요청이 처음임(게시글 목록 로드)
        String serverUri = dotenv.env['SERVER_URI']!;
        String postEndpoint = dotenv.env['POST_ENDPOINT']!;
        postUri = '$serverUri$postEndpoint';
        if (category != null && category != 'ALL') {
          postUri = '$postUri?category=$category';
        }
      }

      var response = await http.get(
        Uri.parse(postUri),
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(utf8.decode(response.bodyBytes));
        List<Post> fetchedPosts = (jsonData['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();
        posts.addAll(fetchedPosts);
        nextLink.value = jsonData['nextLink'];
        hasMore.value = fetchedPosts.length == 10;
      } else if (response.statusCode == 404) {
        hasMore.value = false;
      } else {
        print('Failed to load data. Status code : ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    isLoading.value = false;
  }

  reload() async {
    if (isLoading.value) return;

    isLoading.value = true;
    posts.clear();
    nextLink.value = '';
    //urrentCategory.value = category ?? 'ALL';

    print(currentCategory);
    isLoading.value = false;
    await _getData(category: currentCategory.value);
  }
}
