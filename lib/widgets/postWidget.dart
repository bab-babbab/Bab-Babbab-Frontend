import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/postWidget.dart';
import 'package:bab_babbab_front/widgets/post_detail_widget.dart';

// 게시물 위젯 컴포넌트 (이미지 추가 기능 제거)
class PostWidget extends StatelessWidget {
  final String userName;
  final String userGrade;
  final String statusMessage;
  final bool isTopPost;
  final int imageCount; // 더미 이미지 개수
  final VoidCallback? onDetailTap;

  const PostWidget({
    super.key,
    required this.userName,
    required this.userGrade,
    required this.statusMessage,
    this.isTopPost = false,
    this.imageCount = 0, // 기본값 0개
    this.onDetailTap,
  });

  Widget _buildDummyImage(int index) {
    return Container(
      width: 90,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFBDBDBD), // 회색 컨테이너
      ),
      child: Icon(Icons.image, size: 40, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isTopPost ? Border.all(color: Color(0xFFFFAD0A), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보
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
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
                Spacer(),
                // 더보기 버튼
                GestureDetector(
                  onTap: onDetailTap,
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF999999),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // 제목 (한 줄만 표시, 넘치면 ... 처리)
            Text(
              statusMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15),

            // 더미 이미지들
            if (imageCount > 0)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  imageCount,
                  (index) => _buildDummyImage(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// PostsListPage 위젯
class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
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
        color: Color(0xFFF7F8F9),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: 4,
            itemBuilder: (context, index) {
              return PostWidget(
                userName: _getUserName(index),
                userGrade: _getUserGrade(index),
                statusMessage: _getStatusMessage(index),
                isTopPost: index == 0,
                imageCount: _getImageCount(index), // 임의의 이미지 개수
                onDetailTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PostDetailWidget(
                            selectedImages: null, // 더 이상 이미지 전달 안 함
                            postData: _getPostData(index),
                            greyContainerCount: _getImageCount(
                              index,
                            ), // 이미지 개수만큼 회색 컨테이너 전달
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // 임의의 이미지 개수 반환 (1~3개)
  int _getImageCount(int index) {
    final imageCounts = [3, 1, 2, 1]; // 각 게시물마다 다른 이미지 개수
    return imageCounts[index % imageCounts.length];
  }

  // 게시물 데이터를 Map으로 전달
  Map<String, dynamic> _getPostData(int index) {
    return {
      'userName': _getUserName(index),
      'userGrade': _getUserGrade(index),
      'statusMessage': _getStatusMessage(index),
      'timestamp': _getTimestamp(index),
    };
  }

  // 더미 데이터 함수들
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
