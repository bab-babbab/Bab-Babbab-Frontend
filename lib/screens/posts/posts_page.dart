import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/postWidget.dart';
import 'package:bab_babbab_front/widgets/post_detail_widget.dart';
import 'package:bab_babbab_front/models/user_model.dart';
import 'package:bab_babbab_front/service/api_service.dart';
import 'package:provider/provider.dart';

class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  static const String baseUrl = 'http://localhost:3000';

  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final List<Map<String, dynamic>> postsData = await ApiService.getPosts();
      List<Map<String, dynamic>> postsWithUserInfo = [];

      final userModel = Provider.of<UserModel>(context, listen: false);

      for (int i = 0; i < postsData.length; i++) {
        var post = postsData[i];
        Map<String, dynamic> postWithUserInfo = Map<String, dynamic>.from(post);

        if (post['user_id'] != userModel.id) {
          Map<String, String> userInfo = await ApiService.getUserInfoSimple(post['user_id']);
          postWithUserInfo['_cached_user_name'] = userInfo['name'];
          postWithUserInfo['_cached_user_grade'] = userInfo['grade'];
          postWithUserInfo['_cached_user_class'] = userInfo['class'];
        }
        postsWithUserInfo.add(postWithUserInfo);
      }

      setState(() {
        _posts = postsWithUserInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('Failed to load posts')
            ? '게시물을 불러오는데 실패했습니다.'
            : '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.';
        _isLoading = false;
      });
      print('게시물 로딩 오류: $e');
    }
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

  Future<void> _refreshPosts() async {
    await _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "전체 보기",
          style: TextStyle(
            color: Color(0xFF575757),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Color(0xFFD7D7D7), width: 1)),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Color(0xFFD1D2D1), size: 35),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF575757)),
            onPressed: _refreshPosts,
          ),
        ],
      ),
      body: Container(color: Color(0xFFF7F8F9), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xFFFFB800)));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshPosts,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFB800),
              ),
              child: Text('다시 시도', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '등록된 게시물이 없습니다.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPosts,
      color: Color(0xFFFFB800),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];

            return PostWidget(
              userName: _getPostUserName(post),
              userGrade: _getPostUserGrade(post),
              statusMessage: post['comment'] ?? '내용이 없습니다.',
              isTopPost: index == 0,
              imageCount: _getImageCount(post),
              imageUrls: _getImageUrls(post),
              onDetailTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailWidget(
                      selectedImages: null,
                      postData: {
                        'userName': _getPostUserName(post),
                        'userGrade': _getPostUserGrade(post),
                        'statusMessage': post['comment'] ?? '내용이 없습니다.',
                        'timestamp': post['created_at'] ?? '시간 정보 없음',
                        'imageUrls': _getImageUrls(post),
                      },
                      postId: post['id'],
                      greyContainerCount: _getImageCount(post),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}