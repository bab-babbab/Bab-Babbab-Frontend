import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/postWidget.dart';
import 'package:bab_babbab_front/widgets/post_detail_widget.dart'; // PostDetailWidget import로 변경
import 'dart:io';

// PostsListPage 위젯
class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
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
                imageCount: _getImageCount(index), // ✅ 각 게시물마다 다른 개수
                onDetailTap: () {
                  // PostDetailWidget으로 이동하면서 이미지 개수 전달
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PostDetailWidget(
                            selectedImages:
                                _postImages[index], // 해당 게시물의 이미지 전달
                            postData: _getPostData(index), // 게시물 데이터도 전달
                            greyContainerCount: _getImageCount(
                              index,
                            ), // ✅ 회색 컨테이너 개수 전달
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
