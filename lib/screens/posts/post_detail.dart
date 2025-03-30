import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("게시물", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 게시물 내용
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "오늘 인증!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 이미지 박스
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "1/3",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "2024.02.01 오후 8:43",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // 댓글 리스트 (Expanded로 스크롤 가능하게)
          Expanded(
            child: Container(
              color: const Color(0xFFF7F8F9), // 회색 배경
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 4, // 댓글 개수
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "김수지 2학년/3반",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "2024.02.01 오후 8:43",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "오늘도 수고 많았습니다!! 선배 존경합니다!",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 댓글 입력창
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "댓글 작성하기",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    // 댓글 전송 기능 추가 필요
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
