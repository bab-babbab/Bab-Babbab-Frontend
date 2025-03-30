import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/bottom_nav_bar.dart';
import 'post_item.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "전체 보기",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Color(0xFFF7F8F9), // 배경색 설정
        child: Padding(
          padding: EdgeInsets.only(top: 20), // 원하는 간격 추가 (50px 예시)
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: 4,
            itemBuilder: (context, index) {
              return PostItem();
            },
          ),
        ),
      ),
    );
  }
}
