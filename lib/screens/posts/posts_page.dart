import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/postWidget.dart';
import 'package:bab_babbab_front/widgets/post_detail_widget.dart';
import 'package:bab_babbab_front/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// PostsListPage 위젯
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

  // API에서 게시물 목록을 가져오는 함수
  Future<void> _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsData = json.decode(response.body);
        List<Map<String, dynamic>> postsWithUserInfo = [];

        final userModel = Provider.of<UserModel>(context, listen: false);

        print('📝 총 ${postsData.length}개의 게시물을 불러왔습니다.');

        // 🔥 각 게시물에 대해 사용자 정보를 가져와서 추가
        for (int i = 0; i < postsData.length; i++) {
          var post = postsData[i];
          Map<String, dynamic> postWithUserInfo = Map<String, dynamic>.from(
            post,
          );

          print(
            '🔄 게시물 ${i + 1}/${postsData.length} 처리 중... user_id: ${post['user_id']}',
          );

          // 현재 로그인한 사용자가 아닌 경우에만 사용자 정보 API 호출
          if (post['user_id'] != userModel.id) {
            print('👤 다른 사용자 정보 가져오는 중...');
            Map<String, String> userInfo = await _getUserInfo(post['user_id']);
            postWithUserInfo['_cached_user_name'] = userInfo['name'];
            postWithUserInfo['_cached_user_grade'] = userInfo['grade'];
            postWithUserInfo['_cached_user_class'] = userInfo['class'];
            print(
              '✅ 사용자 정보 완료: ${userInfo['name']} (${userInfo['grade']}학년/${userInfo['class']}반)',
            );
          } else {
            print('✅ 내 게시물: ${userModel.name} (${userModel.gradeClass})');
          }

          postsWithUserInfo.add(postWithUserInfo);
        }

        print('🎉 모든 게시물 처리 완료!');

        setState(() {
          _posts = postsWithUserInfo;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = '게시물을 불러오는데 실패했습니다. (${response.statusCode})';
          _isLoading = false;
        });
        print('❌ 게시물 로딩 실패: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.';
        _isLoading = false;
      });
      print('❌ 네트워크 오류: $e');
    }
  }

  // 이미지 개수를 계산하는 함수
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

  // 이미지 URL 리스트를 반환하는 함수
  List<String> _getImageUrls(Map<String, dynamic> post) {
    List<String> imageUrls = [];

    // 🔥 이미 완전한 URL로 오는 경우와 파일명만 오는 경우 모두 처리
    if (post['photo_b'] != null && post['photo_b'].toString().isNotEmpty) {
      String photoB = post['photo_b'].toString();
      if (photoB.startsWith('http')) {
        imageUrls.add(photoB); // 이미 완전한 URL
      } else {
        imageUrls.add('$baseUrl/uploads/$photoB'); // 파일명만 있는 경우
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

  // 🔥 user_id로 사용자 정보를 가져오는 함수 (올바른 API 엔드포인트)
  Future<Map<String, String>> _getUserInfo(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home/user/$userId'), // 🔥 올바른 API 엔드포인트
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // 🔥 응답 구조에 맞게 데이터 추출
        final userInfo = responseData['userInfo'];
        final schoolInfo = responseData['schoolInfo'];

        String name = userInfo['name'] ?? '사용자';
        String grade = schoolInfo['grade']?.toString() ?? '0';
        String classNum = schoolInfo['class']?.toString() ?? '0';

        print('✅ 사용자 정보 가져오기 성공: $name (${grade}학년/${classNum}반)');

        return {'name': name, 'grade': grade, 'class': classNum};
      } else {
        print('❌ 사용자 정보 API 호출 실패 for $userId: ${response.statusCode}');
        print('응답: ${response.body}');
      }
    } catch (e) {
      print('❌ 사용자 정보 가져오기 오류 for $userId: $e');
    }

    // 🔥 실패시 기본값 반환
    return {'name': '사용자', 'grade': '0', 'class': '0'};
  }

  // 게시물 작성자 정보를 반환하는 함수
  String _getPostUserName(Map<String, dynamic> post) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    // 게시물의 user_id가 현재 로그인한 사용자와 같으면 현재 사용자 이름 사용
    if (post['user_id'] == userModel.id) {
      return userModel.name.isNotEmpty ? userModel.name : '나';
    }

    // 🔥 다른 사용자의 경우 캐시된 정보가 있으면 사용, 없으면 기본값
    String cachedName = post['_cached_user_name'] ?? '사용자';
    return cachedName;
  }

  // 게시물 작성자 학년/반 정보를 반환하는 함수
  String _getPostUserGrade(Map<String, dynamic> post) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    // 게시물의 user_id가 현재 로그인한 사용자와 같으면 현재 사용자 학년/반 사용
    if (post['user_id'] == userModel.id) {
      return userModel.gradeClass;
    }

    // 🔥 다른 사용자의 경우 캐시된 정보가 있으면 사용, 없으면 기본값
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

  // 새로고침 함수
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
              isTopPost: index == 0, // 첫 번째 게시물만 상단 게시물로 설정
              imageCount: _getImageCount(post),
              imageUrls: _getImageUrls(post), // 🔥 실제 이미지 URL 전달
              onDetailTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PostDetailWidget(
                          selectedImages:
                              null, // 실제 이미지는 PostDetailWidget에서 URL로 처리
                          postData: {
                            'userName': _getPostUserName(post),
                            'userGrade': _getPostUserGrade(post),
                            'statusMessage': post['comment'] ?? '내용이 없습니다.',
                            'timestamp': post['created_at'] ?? '시간 정보 없음',
                            'photo_b': post['photo_b'],
                            'photo_l': post['photo_l'],
                            'photo_d': post['photo_d'],
                            'imageUrls': _getImageUrls(
                              post,
                            ), // 🔥 이미지 URL 리스트 추가
                          },
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
