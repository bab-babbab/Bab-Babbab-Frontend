import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
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
                          padding: const EdgeInsets.all(30), // 패딩 늘리기!
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
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 17), // 위아래 여백
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xFFF2F2F2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 수평 중앙 정렬
          children: [
            Icon(
              Icons.account_circle, // 프로필 아이콘 적용
              size: 28,
              color: Colors.grey,
            ),
            SizedBox(width: 14), // 아이콘과 텍스트 사이 간격
            Container(
              width: 200, // 텍스트 필드 크기 제한
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5, // 힌트가 잘 보이도록 내부 패딩 조정
                  ),
                ),
              ),
            ),

            SizedBox(width: 55), // 텍스트 필드와 전송 아이콘 사이 간격

            Transform.translate(
              offset: const Offset(0, -5), // X축(-10), Y축(-5) 방향으로 이동 (음수 적용)
              child: IconButton(
                icon: Transform.rotate(
                  angle: -40 * (3.141592 / 180), // 반시계 방향 40도 회전
                  child: Icon(
                    Icons.send,
                    color: Color(0xFFFFAD0A),
                    size: 26,
                  ), // 크기 조정 가능
                ),
                onPressed: () {
                  String comment = _commentController.text.trim();
                  if (comment.isNotEmpty) {
                    print("$comment");
                    _commentController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
