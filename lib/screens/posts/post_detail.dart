import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

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
        backgroundColor: Colors.white, // ✅ 완전 흰색 고정
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
          color: Colors.white, // 배경색 흰색 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar 아래 간격 추가
              const SizedBox(height: 16),

              // 게시물 내용
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

                    // 이미지 박스
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Color(0xFFC4C4C4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "1/3",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "2024.02.01 오후 8:43",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // 댓글 개수 표시
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ), // 좌우 패딩 설정
                      child: Text(
                        '댓글 4개',
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
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ), // 댓글 간격 늘리기
                          padding: const EdgeInsets.all(30), // 패딩 늘리기
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
                                  const Text(
                                    "김수지",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6F6F6F),
                                    ),
                                  ), // 간격 줄이기
                                  const Text(
                                    "2학년/3반",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  const Text(
                                    "2024.02.01 오후 8:43",
                                    style: TextStyle(
                                      color: Color(0xFFAAAAAA),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "오늘도 수고 많았습니다!! 선배 존경합니다!",
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
      bottomNavigationBar: Container(
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
    );
  }
}
