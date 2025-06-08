import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/postWidget.dart';
import 'dart:io';

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

class PostDetailWidget extends StatefulWidget {
  final List<File>? selectedImages;
  final Map<String, dynamic>? postData;

  const PostDetailWidget({super.key, this.selectedImages, this.postData});

  @override
  PostDetailWidgetState createState() => PostDetailWidgetState();
}

class PostDetailWidgetState extends State<PostDetailWidget> {
  final TextEditingController _commentController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  // 샘플 댓글 데이터
  List<Comment> _comments = [
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
            userName: "정상미",
            userClass: "3학년/4반",
            timestamp: _getCurrentTimestamp(),
            content: commentText,
          ),
        );
      });
      _commentController.clear();
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
    // 기본 게시물 데이터
    final userName = widget.postData?['userName'] ?? '정수진';
    final userGrade = widget.postData?['userGrade'] ?? '3학년 / 2반';
    final statusMessage = widget.postData?['statusMessage'] ?? '오늘 인증!';
    final timestamp = widget.postData?['timestamp'] ?? '2024.02.01 오후 8:43';

    // 이미지 위젯들 생성
    List<Widget> imageWidgets = [];

    // 실제 이미지가 있는지 확인
    bool hasRealImages =
        widget.selectedImages != null && widget.selectedImages!.isNotEmpty;

    if (hasRealImages) {
      // 이미지가 있을 때: 회색 박스 + 실제 이미지들 (스와이프 가능)

      // 첫 번째: 무조건 기본 회색 박스
      imageWidgets.add(
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFC4C4C4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.image, size: 60, color: Colors.white),
          ),
        ),
      );

      // 실제 이미지들 추가 (최대 2개까지)
      int imagesToAdd =
          widget.selectedImages!.length > 2 ? 2 : widget.selectedImages!.length;

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
      // 이미지가 아무것도 없을 때: 회색 박스 1개만 (스와이프 불가)
      imageWidgets.add(
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFC4C4C4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.image, size: 60, color: Colors.white),
          ),
        ),
      );
    }

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
                    // 게시물 제목
                    Text(
                      statusMessage,
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
                            itemCount: imageWidgets.length,
                            itemBuilder: (context, index) {
                              return imageWidgets[index];
                            },
                          ),
                          // 이미지 카운터 (이미지가 2개 이상일 때만 표시)
                          if (imageWidgets.length > 1)
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
                                  "${_currentImageIndex + 1}/${imageWidgets.length}",
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

                    // 타임스탬프
                    Text(timestamp, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),

                    // 댓글 개수
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

                    // 댓글 리스트
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
                onPressed: _addComment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PostsPage 위젯
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // 각 게시물별 이미지 데이터를 저장할 Map
  Map<int, List<File>> _postImages = {};

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
      ),
      body: Container(
        color: Color(0xFFF7F8F9), // 배경색 설정
        child: Padding(
          padding: EdgeInsets.only(top: 20), // 원하는 간격 추가
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: 4,
            itemBuilder: (context, index) {
              return PostWidget(
                userName: _getUserName(index),
                userGrade: _getUserGrade(index),
                statusMessage: _getStatusMessage(index),
                isTopPost: index == 0, // 첫 번째 게시물만 상단 게시물로 설정
                maxImages: 2,
                initialImages: _postImages[index], // 해당 게시물의 이미지 전달
                onDetailTap: () {
                  // PostDetailWidget으로 이동하면서 이미지 데이터 전달
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PostDetailWidget(
                            selectedImages:
                                _postImages[index], // 해당 게시물의 이미지 전달
                            postData: _getPostData(index), // 게시물 데이터도 전달
                          ),
                    ),
                  );
                },
                onImagesChanged: (images) {
                  // PostWidget에서 이미지가 변경될 때 콜백
                  setState(() {
                    _postImages[index] = images;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // 게시물 데이터를 Map으로 전달 (PostDetailWidget에서 사용할 추가 정보)
  Map<String, dynamic> _getPostData(int index) {
    return {
      'userName': _getUserName(index),
      'userGrade': _getUserGrade(index),
      'statusMessage': _getStatusMessage(index),
      'timestamp': _getTimestamp(index),
    };
  }

  // 더미 데이터 함수들 (실제로는 서버에서 받아올 데이터)
  String _getUserName(int index) {
    final names = ['정수진', '김철수', '박영희', '이민수'];
    return names[index % names.length];
  }

  String _getUserGrade(int index) {
    final grades = ['3학년 / 2반', '2학년 / 1반', '1학년 / 3반', '3학년 / 1반'];
    return grades[index % grades.length];
  }

  String _getStatusMessage(int index) {
    final messages = [
      '봉사활동 완료! 오늘도 뜻깊은 하루였습니다 🌟',
      '점심 맛있게 먹었어요! 친구들과 함께해서 더 맛있었음 🍽️',
      '운동 완료! 10km 달리기 성공했습니다 🏃‍♂️',
      '숙제 끝! 수학 문제가 어려웠지만 해냈어요 📚',
    ];
    return messages[index % messages.length];
  }

  String _getTimestamp(int index) {
    final timestamps = [
      '2024.06.09 오후 3:25',
      '2024.06.09 오전 12:15',
      '2024.06.08 오후 6:30',
      '2024.06.08 오후 9:45',
    ];
    return timestamps[index % timestamps.length];
  }
}
