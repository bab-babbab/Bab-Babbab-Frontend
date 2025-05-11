import 'package:flutter/material.dart';
import '../../widgets/image_box.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 제거하고 이름만 남김
          Row(
            children: [
              Text("정수진", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 12),
              Text("3학년 / 2반", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 22),

          Text(
            "오늘 인증!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 22),

          Row(
            children: [
              ImageBox(),
              SizedBox(width: 8),
              ImageBox(),
              SizedBox(width: 8),
              ImageBox(showPlusButton: true),
            ],
          ),
        ],
      ),
    );
  }
}
