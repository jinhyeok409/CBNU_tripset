import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/like_post.dart';

class LikePostListController extends GetxController {
  var posts = <dynamic>[].obs;
  var isLoading = false.obs;
  final storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    String? token = await storage.read(key: 'accessToken');
    String serverUri = dotenv.env['SERVER_URI']!;
    String likeListEndpoint = dotenv.env['POST_LIKE_LIST_ENDPOINT']!;
    String likeListUrl = "$serverUri$likeListEndpoint";
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(likeListUrl),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(utf8.decode(response.bodyBytes));
        List<LikePost> fetchedPosts = (jsonData as List)
            .map((postJson) => LikePost.fromJson(postJson))
            .toList();
        posts.value = fetchedPosts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
