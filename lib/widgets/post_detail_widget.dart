import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// 댓글 데이터 모델
class Comment {
  final String userId;
  final String userName;
  final String userClass;
  final String timestamp;
  final String content;

  Comment({
    required this.userId,
    required this.userName,
    required this.userClass,
    required this.timestamp,
    required this.content,
  });

  // JSON에서 Comment 객체 생성 (서버 응답용)
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userClass: json['user_class'] ?? '',
      timestamp: json['timestamp'] ?? '',
      content: json['reply'] ?? '',
    );
  }
}

// 댓글 API 서비스
class CommentService {
  static const String baseUrl = 'http://3.34.122.170:3000'; // 🔥 실제 서버 URL

  // 🔥 댓글 작성 API - POST /posts/:id/replys
  static Future<bool> addComment({
    required String postId,
    required String userId,
    required String reply,
  }) async {
    try {
      final url = '$baseUrl/posts/$postId/replys';
      final requestData = {'user_id': userId, 'reply': reply};

      print('🔥 댓글 작성 API 호출');
      print('🔥 URL: $url');
      print('🔥 요청 데이터: ${jsonEncode(requestData)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      print('📡 서버 응답 코드: ${response.statusCode}');
      print('📡 응답 내용: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ 댓글 작성 성공!');
        return true;
      } else {
        print('❌ 댓글 작성 실패 - 상태 코드: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ 댓글 작성 네트워크 오류: $e');
      return false;
    }
  }

  // 댓글 목록 가져오기 API
  static Future<List<Comment>> getComments(String postId) async {
    try {
      print('댓글 목록 요청: postId=$postId');

      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId/replys'),
        headers: {'Content-Type': 'application/json'},
      );

      print('댓글 목록 응답: ${response.statusCode}');
      print('댓글 목록 응답 내용: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        List<Comment> comments = [];

        // 🔥 각 댓글에 대해 사용자 정보를 가져와서 Comment 객체 생성
        for (var commentJson in jsonList) {
          String userId = commentJson['user_id'] ?? '';
          String reply = commentJson['reply'] ?? '';
          String timestamp = commentJson['created_at'] ?? '';

          // 🔥 사용자 정보 가져오기
          Map<String, String> userInfo = await PostDetailService.getUserInfo(
            userId,
          );

          Comment comment = Comment(
            userId: userId,
            userName: userInfo['name']!,
            userClass: '${userInfo['grade']}학년/${userInfo['class']}반',
            timestamp: _formatTimestamp(timestamp), // 🔥 시간 포맷팅
            content: reply,
          );

          comments.add(comment);
        }

        return comments;
      }
      return [];
    } catch (e) {
      print('댓글 불러오기 오류: $e');
      return [];
    }
  }

  // 🔥 댓글 시간 포맷팅 함수 수정 (날짜만 표시)
  static String _formatTimestamp(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString);

      // 🔥 UTC 시간을 로컬 시간으로 변환
      dateTime = dateTime.toLocal();

      String year = dateTime.year.toString();
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');

      return '$year-$month-$day'; // 🔥 날짜만 반환 (YYYY-MM-DD 형식)
    } catch (e) {
      print('시간 포맷팅 오류: $e');
      return '날짜 정보 없음';
    }
  }
}

// 🔥 게시물 상세 API 서비스
class PostDetailService {
  static const String baseUrl = 'http://3.34.122.170:3000';

  // GET "/posts/:id" - 게시물 상세 조회
  static Future<Map<String, dynamic>?> getPostDetail(String postId) async {
    try {
      print('🔍 게시물 상세 조회: postId=$postId');

      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 게시물 상세 응답: ${response.statusCode}');

      if (response.statusCode == 200) {
        final postData = jsonDecode(response.body);
        print('✅ 게시물 상세 조회 성공!');
        return postData;
      } else {
        print('❌ 게시물 상세 조회 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ 게시물 상세 조회 오류: $e');
      return null;
    }
  }

  // 🔥 user_id로 사용자 정보 가져오기
  static Future<Map<String, String>> getUserInfo(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userInfo = responseData['userInfo'];
        final schoolInfo = responseData['schoolInfo'];

        String name = userInfo['name'] ?? '사용자';
        String grade = schoolInfo['grade']?.toString() ?? '0';
        String classNum = schoolInfo['class']?.toString() ?? '0';

        return {'name': name, 'grade': grade, 'class': classNum};
      }
    } catch (e) {
      print('❌ 사용자 정보 가져오기 오류: $e');
    }

    return {'name': '사용자', 'grade': '0', 'class': '0'};
  }
}

// 게시물 상세 위젯
class PostDetailWidget extends StatefulWidget {
  final List<File>? selectedImages; // 게시물 이미지들 (로컬)
  final Map<String, dynamic>? postData; // 게시물 데이터
  final int greyContainerCount; // 회색 박스 개수
  final String? postId; // 🔥 게시물 ID (API 호출용)

  const PostDetailWidget({
    super.key,
    this.selectedImages,
    this.postData,
    this.greyContainerCount = 3,
    this.postId,
  });

  @override
  PostDetailWidgetState createState() => PostDetailWidgetState();
}

class PostDetailWidgetState extends State<PostDetailWidget> {
  // 컨트롤러들
  final TextEditingController _commentController = TextEditingController();
  final PageController _pageController = PageController();

  // 상태 변수들
  int _currentImageIndex = 0;
  List<Comment> _comments = [];
  bool _isLoading = false;
  bool _isLoadingPost = true;

  // 🔥 게시물 상세 정보
  Map<String, dynamic>? _postDetail;
  List<String> _imageUrls = [];
  String _postUserName = '';
  String _postUserGrade = '';

  @override
  void initState() {
    super.initState();
    _loadPostDetail(); // 🔥 게시물 상세 정보 로드
    _loadComments(); // 댓글 불러오기
  }

  // 🔥 게시물 상세 정보 로드
  Future<void> _loadPostDetail() async {
    if (widget.postId != null) {
      setState(() => _isLoadingPost = true);

      // 게시물 상세 정보 가져오기
      final postDetail = await PostDetailService.getPostDetail(widget.postId!);

      if (postDetail != null) {
        setState(() {
          _postDetail = postDetail;
        });

        // 이미지 URL 추출
        _extractImageUrls(postDetail);

        // 사용자 정보 가져오기
        await _loadUserInfo(postDetail['user_id']);
      }

      setState(() => _isLoadingPost = false);
    } else {
      setState(() => _isLoadingPost = false);
    }
  }

  // 🔥 이미지 URL 추출
  void _extractImageUrls(Map<String, dynamic> postDetail) {
    List<String> urls = [];

    if (postDetail['photo_b'] != null &&
        postDetail['photo_b'].toString().isNotEmpty) {
      urls.add(postDetail['photo_b'].toString());
    }
    if (postDetail['photo_l'] != null &&
        postDetail['photo_l'].toString().isNotEmpty) {
      urls.add(postDetail['photo_l'].toString());
    }
    if (postDetail['photo_d'] != null &&
        postDetail['photo_d'].toString().isNotEmpty) {
      urls.add(postDetail['photo_d'].toString());
    }

    setState(() {
      _imageUrls = urls;
    });
  }

  // 🔥 게시물 타임스탬프 포맷팅 함수 수정 (날짜만 YYYY-MM-DD 형식)
  String _formatPostTimestamp(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString);

      // 🔥 UTC 시간을 로컬 시간으로 변환
      dateTime = dateTime.toLocal();

      String year = dateTime.year.toString();
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');

      return '$year-$month-$day'; // 🔥 YYYY-MM-DD 형태로만 반환
    } catch (e) {
      print('게시물 시간 포맷팅 오류: $e');
      return '날짜 정보 없음';
    }
  }

  Future<void> _loadUserInfo(String userId) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    if (userId == userModel.id) {
      // 현재 로그인한 사용자
      setState(() {
        _postUserName = userModel.name;
        _postUserGrade = userModel.gradeClass;
      });
    } else {
      // 다른 사용자 정보 가져오기
      final userInfo = await PostDetailService.getUserInfo(userId);
      setState(() {
        _postUserName = userInfo['name']!;
        _postUserGrade = '${userInfo['grade']}학년/${userInfo['class']}반';
      });
    }
  }

  // 댓글 불러오기 함수
  Future<void> _loadComments() async {
    if (widget.postId != null) {
      setState(() => _isLoading = true);

      final comments = await CommentService.getComments(widget.postId!);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } else {
      // 샘플 댓글 (postId가 없을 때만)
      _comments = [
        Comment(
          userId: "sample_user_1",
          userName: "김수지",
          userClass: "2학년/3반",
          timestamp: "2024-02-01",
          content: "오늘도 수고 많았습니다!! 선배 존경합니다!",
        ),
        Comment(
          userId: "sample_user_2",
          userName: "박지훈",
          userClass: "2학년/1반",
          timestamp: "2024-02-01",
          content: "정말 열심히 하시네요! 항상 응원합니다!",
        ),
      ];
      setState(() => _isLoading = false);
    }
  }

  // 🔥 댓글 작성 시 현재 날짜 포맷팅 (날짜만)
  String _getCurrentTimestamp() {
    final now = DateTime.now(); // 🔥 이미 로컬 시간

    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');

    return '$year-$month-$day'; // 🔥 날짜만 반환 (YYYY-MM-DD 형식)
  }

  // 🔥 댓글 작성 함수
  Future<void> _addComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final userModel = Provider.of<UserModel>(context, listen: false);

    if (userModel.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인이 필요합니다! 😅'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = false;

    if (widget.postId != null) {
      success = await CommentService.addComment(
        postId: widget.postId!,
        userId: userModel.id,
        reply: commentText,
      );

      // 🔥 댓글 작성 성공 시 댓글 목록 다시 불러오기 (서버 시간으로 통일)
      if (success) {
        await _loadComments(); // 서버에서 최신 댓글 목록을 다시 가져옴
        _commentController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('댓글이 작성되었습니다! 🎉'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } else {
      // 🔥 오프라인 모드 (샘플 데이터)
      await Future.delayed(Duration(milliseconds: 500));
      success = true;

      if (success) {
        final newComment = Comment(
          userId: userModel.id,
          userName: userModel.name.isNotEmpty ? userModel.name : "사용자",
          userClass: userModel.gradeClass,
          timestamp: _getCurrentTimestamp(),
          content: commentText,
        );

        setState(() {
          _comments.add(newComment);
        });

        _commentController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('댓글이 작성되었습니다! 🎉'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }

    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('댓글 작성에 실패했습니다. 다시 시도해주세요. 😞'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    // 🔥 게시물 데이터 (API에서 가져온 데이터 우선 사용)
    final userName =
        _postUserName.isNotEmpty
            ? _postUserName
            : (widget.postData?['userName'] ?? '정수진');
    final userGrade =
        _postUserGrade.isNotEmpty
            ? _postUserGrade
            : (widget.postData?['userGrade'] ?? '3학년 / 2반');
    final statusMessage =
        _postDetail?['comment'] ??
        widget.postData?['statusMessage'] ??
        '오늘 인증!';

    // 🔥 게시물 날짜만 표시 (YYYY-MM-DD 형식)
    final timestamp =
        _postDetail?['created_at'] != null
            ? _formatPostTimestamp(_postDetail!['created_at'])
            : (widget.postData?['timestamp'] ?? '2024-02-01');

    // 🔥 이미지 위젯 생성 (서버 이미지 우선, 그 다음 로컬 이미지)
    List<Widget> imageWidgets = [];

    if (_imageUrls.isNotEmpty) {
      // 🔥 서버 이미지 (스와이프 가능)
      for (int i = 0; i < _imageUrls.length; i++) {
        imageWidgets.add(
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                _imageUrls[i],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        strokeWidth: 2,
                        color: Color(0xFFFFB800),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFC4C4C4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 60,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '이미지 로딩 실패',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    } else if (widget.selectedImages != null &&
        widget.selectedImages!.isNotEmpty) {
      // 🔥 로컬 이미지 (스와이프 가능)
      int imagesToAdd =
          widget.selectedImages!.length > 3 ? 3 : widget.selectedImages!.length;
      for (int i = 0; i < imagesToAdd; i++) {
        imageWidgets.add(
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                widget.selectedImages![i],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFC4C4C4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    } else {
      // 🔥 회색 박스 (스와이프 가능)
      for (int i = 0; i < widget.greyContainerCount; i++) {
        imageWidgets.add(
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFC4C4C4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 60, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "게시물",
          style: TextStyle(
            color: Color(0xFF575757),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        shape: Border(bottom: BorderSide(color: Color(0xFFD7D7D7), width: 1)),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Color(0xFFD1D2D1), size: 35),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoadingPost
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFFFAD0A)),
                    SizedBox(height: 16),
                    Text(
                      '게시물을 불러오는 중...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔥 사용자 정보
                            Row(
                              children: [
                                Text(
                                  '$userName ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Text(
                                  userGrade,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                            // 🔥 게시물 제목
                            Text(
                              statusMessage,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),

                            // 🔥 이미지 슬라이더 (스와이프 가능)
                            Container(
                              width: double.infinity,
                              height: 350,
                              decoration: BoxDecoration(
                                color: Color(0xFFC4C4C4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (index) {
                                      setState(
                                        () => _currentImageIndex = index,
                                      );
                                    },
                                    itemCount: imageWidgets.length,
                                    itemBuilder:
                                        (context, index) => imageWidgets[index],
                                  ),
                                  // 🔥 이미지 카운터 (여러 이미지가 있을 때만 표시)
                                  if (imageWidgets.length > 1)
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "${_currentImageIndex + 1}/${imageWidgets.length}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // 🔥 타임스탬프 (날짜만 표시)
                            Text(
                              timestamp,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 20),

                            // 🔥 댓글 개수
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                '댓글 ${_comments.length}개',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  height: 1.40,
                                ),
                              ),
                            ),
                            SizedBox(height: 14),

                            // 🔥 댓글 리스트
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _comments.length,
                              itemBuilder: (context, index) {
                                final comment = _comments[index];

                                return Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 10,
                                        offset: Offset(1, 1),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            comment.userName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6F6F6F),
                                            ),
                                          ),
                                          Text(
                                            comment.userClass,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFAAAAAA),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          Text(
                                            comment.timestamp,
                                            style: TextStyle(
                                              color: Color(0xFFAAAAAA),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        comment.content,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        padding: EdgeInsets.symmetric(vertical: 17),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xFFF2F2F2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 28, color: Colors.grey),
            SizedBox(width: 14),
            Container(
              width: 200,
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: userModel.id.isEmpty ? "로그인 후 댓글 작성" : "댓글 작성하기",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
                onSubmitted: (value) => _addComment(),
                enabled: !_isLoading && userModel.id.isNotEmpty,
              ),
            ),
            SizedBox(width: 55),
            Transform.translate(
              offset: Offset(0, -5),
              child: IconButton(
                icon:
                    _isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFFAD0A),
                          ),
                        )
                        : Transform.rotate(
                          angle: -40 * (3.141592 / 180),
                          child: Icon(
                            Icons.send,
                            color:
                                userModel.id.isEmpty
                                    ? Colors.grey
                                    : Color(0xFFFFAD0A),
                            size: 26,
                          ),
                        ),
                onPressed:
                    _isLoading || userModel.id.isEmpty ? null : _addComment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
