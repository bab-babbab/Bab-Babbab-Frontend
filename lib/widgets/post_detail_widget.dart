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
  // 🔥🔥🔥 실제 서버 URL로 변경하세요! 예: 'https://your-actual-server.com'
  static const String baseUrl = 'https://your-api-server.com';

  // 🔥🔥🔥 댓글 작성 API - POST /posts/:id/replys
  // 요청 형식: { "user_id": "cnYXVjOqQ0RVQsA8OKB9TYWveJI3", "reply": "와..맛있겠다" }
  static Future<bool> addComment({
    required String postId,
    required String userId,
    required String reply,
  }) async {
    try {
      final url = '$baseUrl/posts/$postId/replys';
      final requestData = {
        'user_id': userId, // 예: "cnYXVjOqQ0RVQsA8OKB9TYWveJI3"
        'reply': reply, // 예: "와..맛있겠다"
      };

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

      // 성공 상태 코드 확인 (200, 201 모두 성공)
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

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Comment.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('댓글 불러오기 오류: $e');
      return [];
    }
  }
}

// 게시물 상세 위젯
class PostDetailWidget extends StatefulWidget {
  final List<File>? selectedImages; // 게시물 이미지들
  final Map<String, dynamic>? postData; // 게시물 데이터
  final int greyContainerCount; // 회색 박스 개수
  final String? postId; // 🔥 게시물 ID (API 호출용)

  const PostDetailWidget({
    super.key,
    this.selectedImages,
    this.postData,
    this.greyContainerCount = 3,
    this.postId, // API 연동을 위한 postId 추가
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

  @override
  void initState() {
    super.initState();
    _loadComments(); // 댓글 불러오기
  }

  // 댓글 불러오기 함수
  Future<void> _loadComments() async {
    if (widget.postId != null) {
      // 🔥 실제 API 호출
      setState(() => _isLoading = true);

      final comments = await CommentService.getComments(widget.postId!);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } else {
      // 🔥 샘플 댓글 (postId가 없을 때)
      _comments = [
        Comment(
          userId: "sample_user_1",
          userName: "김수지",
          userClass: "2학년/3반", // 🔥 학년/반 형식으로 변경
          timestamp: "2024.02.01 오후 8:43",
          content: "오늘도 수고 많았습니다!! 선배 존경합니다!",
        ),
        Comment(
          userId: "sample_user_2",
          userName: "박지훈",
          userClass: "2학년/1반", // 🔥 학년/반 형식으로 변경
          timestamp: "2024.02.01 오후 8:45",
          content: "정말 열심히 하시네요! 항상 응원합니다!",
        ),
        Comment(
          userId: "sample_user_3",
          userName: "양혜원",
          userClass: "3학년/2반", // 🔥 학년/반 형식으로 변경
          timestamp: "2024.02.15 오후 18:45",
          content: "너 정말 열심히 한다. 힘내.",
        ),
        Comment(
          userId: "sample_user_4",
          userName: "김지혜",
          userClass: "2학년/1반", // 🔥 학년/반 형식으로 변경
          timestamp: "2024.08.21 오후 8:21",
          content: "상미의 생일에 이러한 것을 실천 하다니 정말 좋아",
        ),
      ];
    }
  }

  // 현재 시간 포맷팅
  String _getCurrentTimestamp() {
    final now = DateTime.now();
    final hour =
        now.hour > 12
            ? now.hour - 12
            : now.hour == 0
            ? 12
            : now.hour;
    final period = now.hour >= 12 ? '오후' : '오전';
    final minute = now.minute.toString().padLeft(2, '0');

    return "${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} $period $hour:$minute";
  }

  // 🔥🔥🔥 댓글 작성 함수 (UserModel 사용, 학년/반 표시)
  Future<void> _addComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    // 🔥 UserModel에서 사용자 정보 가져오기
    final userModel = Provider.of<UserModel>(context, listen: false);

    // 🔥 로그인 확인
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
      // 🔥 서버에 댓글 저장 (UserModel의 id 사용)
      success = await CommentService.addComment(
        postId: widget.postId!,
        userId: userModel.id, // 🔥 UserModel에서 가져온 사용자 ID
        reply: commentText,
      );
    } else {
      // 테스트용 (항상 성공)
      await Future.delayed(Duration(milliseconds: 500)); // 로딩 시뮬레이션
      success = true;
    }

    if (success) {
      // 🔥 성공시 로컬 리스트에 추가 (UserModel 정보 사용, 학년/반 표시)
      final newComment = Comment(
        userId: userModel.id, // 🔥 UserModel ID
        userName:
            userModel.name.isNotEmpty
                ? userModel.name
                : "사용자", // 🔥 UserModel 이름
        userClass: userModel.gradeClass, // 🔥 학교 대신 학년/반 사용
        timestamp: _getCurrentTimestamp(),
        content: commentText,
      );

      setState(() {
        _comments.add(newComment);
        _isLoading = false;
      });

      _commentController.clear();

      // 성공 메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('댓글이 작성되었습니다! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // 실패 처리
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('댓글 작성에 실패했습니다. 다시 시도해주세요. 😞'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    // 🔥 UserModel 가져오기
    final userModel = Provider.of<UserModel>(context);

    // 🔥 게시물 데이터 추출
    final userName = widget.postData?['userName'] ?? '정수진';
    final userGrade = widget.postData?['userGrade'] ?? '3학년 / 2반';
    final statusMessage = widget.postData?['statusMessage'] ?? '오늘 인증!';
    final timestamp = widget.postData?['timestamp'] ?? '2024.02.01 오후 8:43';

    // 🔥 이미지 위젯 생성
    List<Widget> imageWidgets = [];
    bool hasRealImages =
        widget.selectedImages != null && widget.selectedImages!.isNotEmpty;

    if (hasRealImages) {
      // 실제 이미지 표시
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
      // 회색 박스 표시
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

      // 🔥 앱바
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

      // 🔥 메인 바디
      body:
          _isLoading && _comments.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFFFAD0A)),
                    SizedBox(height: 16),
                    Text('댓글을 불러오는 중...', style: TextStyle(color: Colors.grey)),
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
                            // 🔥 게시물 제목
                            Text(
                              statusMessage,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),

                            // 🔥 이미지 슬라이더
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
                                  // 이미지 카운터
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

                            // 🔥 타임스탬프
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

                            // 🔥 댓글 리스트 (모든 댓글 동일한 스타일)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _comments.length,
                              itemBuilder: (context, index) {
                                final comment = _comments[index];

                                return Container(
                                  // 🔥 기존과 동일한 마진
                                  margin: EdgeInsets.only(bottom: 20),
                                  // 🔥 기존과 동일한 패딩
                                  padding: EdgeInsets.all(30),
                                  // 🔥 모든 댓글 동일한 흰색 배경
                                  decoration: BoxDecoration(
                                    color: Colors.white, // 🔥 모든 댓글이 흰색 배경
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
                                      // 🔥 댓글 헤더 (내 댓글 태그 제거)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // 왼쪽: 사용자 이름만 (내 댓글 태그 제거)
                                          Text(
                                            comment.userName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6F6F6F),
                                            ),
                                          ),
                                          // 가운데: 사용자 클래스 (학년/반)
                                          Text(
                                            comment.userClass,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFAAAAAA),
                                            ),
                                          ),
                                          // 오른쪽: 시간
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
                                      // 🔥 기존과 동일한 간격
                                      SizedBox(height: 20),
                                      // 🔥 댓글 내용 (기존과 동일한 스타일)
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

      // 🔥 댓글 입력 바
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
