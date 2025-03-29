import 'package:flutter/material.dart';
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
        color: Color(0xFFF7F8F9), // 원하는 배경색 설정
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: 3,
          itemBuilder: (context, index) {
            return PostItem();
          },
        ),
      ),
    );
  }
}
