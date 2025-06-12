import 'package:bab_babbab_front/screens/posts/post_detail.dart';
import 'package:bab_babbab_front/screens/posts/posts_page.dart';
import 'package:bab_babbab_front/widgets/post_detail_widget.dart';
import 'package:flutter/material.dart';

class PostsMainPage extends StatelessWidget {
  const PostsMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8F9),
      body: const _PostsMainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 0,
        backgroundColor: Color(0xffFFAD0A),
        shape: CircleBorder(),
      ),
    );
  }
}

class _PostsMainContent extends StatelessWidget {
  const _PostsMainContent({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; 
    double containerWidth = screenWidth - 50;
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 100, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: containerWidth,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Text(
                    '내 친구 찾아보기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      color: Color(0xffD1D2D1),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: Color(0xffAAAAAA),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Text(
              '나의 현황',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 24,
                
              ),
            ),
          )
          ,
          Column(
            children: [
              Container(
                width: containerWidth,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15)
                  ) 
                ),
              )
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '게시물',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("전체보기 클릭됨!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostsPage(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        '전체보기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14,
                          color: Color(0xffAAAAAA),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xffAAAAAA),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: containerWidth,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                    Radius.circular(15)
              ), 
            ),
          )
        ],
      ),
    );
  }
}