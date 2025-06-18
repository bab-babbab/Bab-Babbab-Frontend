import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/postWidget.dart';
import 'package:bab_babbab_front/widgets/post_detail_widget.dart';
import 'dart:io';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
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
                imageCount: 2,
                onDetailTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PostDetailWidget(
                            selectedImages: _postImages[index],
                            postData: _getPostData(index),
                            postId: _getPostId(index),
                            greyContainerCount: 2,
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

  String _getPostId(int index) {
    final postIds = ['post_001', 'post_002', 'post_003', 'post_004'];
    return postIds[index % postIds.length];
  }

  Map<String, dynamic> _getPostData(int index) {
    return {
      'userName': _getUserName(index),
      'userGrade': _getUserGrade(index),
      'statusMessage': _getStatusMessage(index),
      'timestamp': _getTimestamp(index),
      'postId': _getPostId(index),
    };
  }

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
