import 'package:flutter/material.dart';

// 댓글 데이터 모델
class Comment {
  final String userName;
  final String userClass;
  final String timestamp;
  final String content;

  Comment({
    required this.userName,
    required this.userClass,
    required this.timestamp,
    required this.content,
  });
}

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  // 댓글 리스트를 상태로 관리
  final List<Comment> _comments = [
    Comment(
      userName: "김수지",
      userClass: "2학년/3반",
      timestamp: "2024.02.01 오후 8:43",
      content: "오늘도 수고 많았습니다!! 선배 존경합니다!",
    ),
    Comment(
      userName: "박지훈",
      userClass: "2학년/1반",
      timestamp: "2024.02.01 오후 8:45",
      content: "정말 열심히 하시네요! 항상 응원합니다!",
    ),
    Comment(
      userName: "양혜원",
      userClass: "3학년/2반",
      timestamp: "2024.02.15 오후 18:45",
      content: "너 정말 열심히 한다. 힘내.",
    ),
    Comment(
      userName: "김지혜",
      userClass: "2학년/1반",
      timestamp: "2024.08.21 오후 8:21",
      content: "상미의 생일에 이러한 것을 실천 하다니 정말 좋아",
    ),
  ];

  final List<String> _images = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
  ];

  // 현재 시간을 포맷팅하는 함수
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

  // 댓글 추가 함수
  void _addComment() {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      setState(() {
        _comments.add(
          Comment(
            userName: "정수진", // 현재 사용자 이름 (실제로는 로그인된 사용자 정보 사용)
            userClass: "3학년/2반", // 현재 사용자 클래스
            timestamp: _getCurrentTimestamp(),
            content: commentText,
          ),
        );
      });
      _commentController.clear();

      // 댓글 추가 후 스크롤을 맨 아래로 이동 (선택사항)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // 약간의 지연 후 스크롤
          Future.delayed(Duration(milliseconds: 100), () {
            Scrollable.ensureVisible(
              context,
              alignment: 1.0,
              duration: Duration(milliseconds: 300),
            );
          });
        }
      });
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
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
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFD7D7D7), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFFD1D2D1),
            size: 35,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "오늘 인증!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 이미지 슬라이더
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
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFC4C4C4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Image ${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${_currentImageIndex + 1}/${_images.length}",
                                style: const TextStyle(
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
                    const SizedBox(height: 20),
                    const Text(
                      "2024.02.01 오후 8:43",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // 댓글 개수 표시 (동적으로 업데이트)
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
                    const SizedBox(height: 14),

                    // 댓글 리스트 (동적으로 업데이트)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 10,
                                offset: Offset(1, 1),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6F6F6F),
                                    ),
                                  ),
                                  Text(
                                    comment.userClass,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    comment.timestamp,
                                    style: const TextStyle(
                                      color: Color(0xFFAAAAAA),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                comment.content,
                                style: const TextStyle(
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
        padding: const EdgeInsets.symmetric(vertical: 17),
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
                  hintText: "댓글 작성하기",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                ),
                // 엔터키로도 댓글 전송 가능
                onSubmitted: (value) => _addComment(),
              ),
            ),
            SizedBox(width: 55),
            Transform.translate(
              offset: const Offset(0, -5),
              child: IconButton(
                icon: Transform.rotate(
                  angle: -40 * (3.141592 / 180),
                  child: Icon(Icons.send, color: Color(0xFFFFAD0A), size: 26),
                ),
                onPressed: _addComment, // 실제 댓글 추가 함수 호출
              ),
            ),
          ],
        ),
      ),
    );
  }
}
