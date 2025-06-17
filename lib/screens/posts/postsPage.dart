import 'package:bab_babbab_front/screens/posts/posts_page.dart';
import 'package:bab_babbab_front/widgets/postWidget.dart';
import 'package:bab_babbab_front/widgets/post_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';
import 'package:bab_babbab_front/service/api_service.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  static const String baseUrl = 'http://3.34.122.170:3000';

  late Future<Map<String, int>> activityData;
  List<Map<String, dynamic>> _recentPosts = [];
  bool _isLoadingPosts = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserModel>(context);
    activityData = ApiService.fetchActivityData(user.id);
    _fetchRecentPosts();
  }

  Future<Map<String, int>> fetchActivityData(String userId) async {
    final response = await http.get(
      Uri.parse('http://3.34.122.170:3000/stats/daily/$userId'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return {for (var item in data) item['date']: item['count']};
    } else {
      throw Exception('데이터를 불러오지 못했습니다');
    }
  }

  Future<void> _fetchRecentPosts() async {
    try {
      setState(() {
        _isLoadingPosts = true;
      });

      final postsData = await ApiService.getPosts();
      final userModel = Provider.of<UserModel>(context, listen: false);
      postsData.sort((a, b) {
        return DateTime.parse(
          b['created_at'],
        ).compareTo(DateTime.parse(a['created_at']));
      });
      
      List<Map<String, dynamic>> postsWithUserInfo = [];
      final recentPostsData = postsData.take(3).toList();

      for (var post in recentPostsData) {
        Map<String, dynamic> postWithUserInfo = Map<String, dynamic>.from(post);

        if (post['user_id'] != userModel.id) {
          Map<String, String> userInfo = await ApiService.getUserDetails(
            post['user_id'],
          );
          postWithUserInfo['_cached_user_name'] = userInfo['name'];
          postWithUserInfo['_cached_user_grade'] = userInfo['grade'];
          postWithUserInfo['_cached_user_class'] = userInfo['class'];
        }

        postsWithUserInfo.add(postWithUserInfo);
      }

      setState(() {
        _recentPosts = postsWithUserInfo;
        _isLoadingPosts = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPosts = false;
      });
      debugPrint('❌ 최근 게시물 로딩 실패: $e');
    }
  }

  String _getPostUserName(Map<String, dynamic> post) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    if (post['user_id'] == userModel.id) {
      return userModel.name.isNotEmpty ? userModel.name : '나';
    }

    String cachedName = post['_cached_user_name'] ?? '사용자';
    return cachedName;
  }

  String _getPostUserGrade(Map<String, dynamic> post) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    if (post['user_id'] == userModel.id) {
      return userModel.gradeClass;
    }

    String? cachedGrade = post['_cached_user_grade'];
    String? cachedClass = post['_cached_user_class'];

    if (cachedGrade != null &&
        cachedClass != null &&
        cachedGrade != '0' &&
        cachedClass != '0') {
      return '${cachedGrade}학년/${cachedClass}반';
    }

    return '학년/반 정보 없음';
  }

  int _getImageCount(Map<String, dynamic> post) {
    int count = 0;
    if (post['photo_b'] != null && post['photo_b'].toString().isNotEmpty)
      count++;
    if (post['photo_l'] != null && post['photo_l'].toString().isNotEmpty)
      count++;
    if (post['photo_d'] != null && post['photo_d'].toString().isNotEmpty)
      count++;
    return count;
  }

  List<String> _getImageUrls(Map<String, dynamic> post) {
    List<String> imageUrls = [];

    if (post['photo_b'] != null && post['photo_b'].toString().isNotEmpty) {
      String photoB = post['photo_b'].toString();
      if (photoB.startsWith('http')) {
        imageUrls.add(photoB);
      } else {
        imageUrls.add('$baseUrl/uploads/$photoB');
      }
    }

    if (post['photo_l'] != null && post['photo_l'].toString().isNotEmpty) {
      String photoL = post['photo_l'].toString();
      if (photoL.startsWith('http')) {
        imageUrls.add(photoL);
      } else {
        imageUrls.add('$baseUrl/uploads/$photoL');
      }
    }

    if (post['photo_d'] != null && post['photo_d'].toString().isNotEmpty) {
      String photoD = post['photo_d'].toString();
      if (photoD.startsWith('http')) {
        imageUrls.add(photoD);
      } else {
        imageUrls.add('$baseUrl/uploads/$photoD');
      }
    }

    return imageUrls;
  }

  Color getColorByCount(int? count) {
    switch (count) {
      case 3:
        return const Color(0xFFFFAD0A);
      case 2:
        return const Color(0xFFFFD37B);
      case 1:
        return const Color(0xFFFFEFCE);
      default:
        return const Color(0xFFE8E8E8);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 50;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8F9),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, top: 100, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 16),
              child: Text(
                '나의 현황',
                style: TextStyle(fontFamily: 'Pretendard', fontSize: 24),
              ),
            ),
            Container(
              width: containerWidth,
              height: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: FutureBuilder<Map<String, int>>(
                future: activityData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('에러 발생'));
                  } else {
                    return DailyActivityGrid(
                      activityData: snapshot.data!,
                      getColorByCount: getColorByCount,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '게시물',
                  style: TextStyle(fontFamily: 'Pretendard', fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostsListPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        '전체보기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14,
                          color: Color(0xffAAAAAA),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xffAAAAAA),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _isLoadingPosts
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFB800),
                        ),
                      )
                      : _recentPosts.isEmpty
                      ? Center(
                        child: Container(
                          width: containerWidth,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.post_add,
                                size: 48,
                                color: Color(0xFFCCCCCC),
                              ),
                              SizedBox(height: 12),
                              Text(
                                '최근 게시물이 없습니다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _recentPosts.length,
                        itemBuilder: (context, index) {
                          final post = _recentPosts[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: PostWidget(
                              userName: _getPostUserName(post),
                              userGrade: _getPostUserGrade(post),
                              statusMessage: post['comment'] ?? '내용이 없습니다.',
                              isTopPost: false,
                              imageCount: _getImageCount(post),
                              imageUrls: _getImageUrls(post),
                              onDetailTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PostDetailWidget(
                                          selectedImages: null,
                                          postData: {
                                            'userName': _getPostUserName(post),
                                            'userGrade': _getPostUserGrade(
                                              post,
                                            ),
                                            'statusMessage':
                                                post['comment'] ?? '내용이 없습니다.',
                                            'timestamp':
                                                post['created_at'] ??
                                                '시간 정보 없음',
                                            'imageUrls': _getImageUrls(post),
                                          },
                                          postId: post['id'],
                                          greyContainerCount: _getImageCount(
                                            post,
                                          ),
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyActivityGrid extends StatelessWidget {
  final Map<String, int> activityData;
  final Color Function(int?) getColorByCount;

  const DailyActivityGrid({
    super.key,
    required this.activityData,
    required this.getColorByCount,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final List<Widget> boxes = [];

    for (int i = 59; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateString = date.toIso8601String().substring(0, 10);
      final count = activityData[dateString];
      final color = getColorByCount(count);

      boxes.add(
        Container(
          width: 19,
          height: 19,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );
    }

    return Wrap(spacing: 4, runSpacing: 4, children: boxes);
  }
}
