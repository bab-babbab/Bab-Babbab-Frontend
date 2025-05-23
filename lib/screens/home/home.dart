// home.dart
import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/bottom_nav_bar.dart';
import 'package:bab_babbab_front/screens/ranking/ranking.dart';
import 'package:bab_babbab_front/screens/posts/posts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _HomeMainContent(),
    Center(child: Text('게시물')),
    RankingPage(),
    Center(child: Text('내 정보 페이지')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 0,
        backgroundColor: Color(0xffFFAD0A),
        shape: CircleBorder(),
      ),
      backgroundColor: Color(0xffF7F8F9),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeMainContent extends StatelessWidget {
  const _HomeMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 50;

    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '정수진님\n오늘도 수고 했어요!',
            style: TextStyle(fontFamily: 'Pretendard', fontSize: 24),
          ),
          SizedBox(height: 28),
          Row(
            children: [
              Container(
                width: containerWidth / 2 - 7,
                height: 213,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              SizedBox(width: 14),
              Column(
                children: [
                  Container(
                    width: containerWidth / 2 - 7,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: containerWidth / 2 - 7,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 22),
          Container(
            width: containerWidth,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                '음식을 먹을만큼만 담자~',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  color: Color(0xff898A8D),
                ),
              ),
            ),
          ),
          SizedBox(height: 43),
          Text(
            '환경 이슈',
            style: TextStyle(fontFamily: 'Pretendard', fontSize: 20),
          ),
          SizedBox(height: 17),
          Container(
            width: containerWidth,
            height: 126,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
