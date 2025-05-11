import 'package:flutter/material.dart';
import 'package:bab_babbab_front/widgets/bottom_nav_bar.dart'; 
import 'package:bab_babbab_front/screens/ranking/ranking.dart'; 
import 'package:bab_babbab_front/screens/home/foodBoardPage.dart';
import 'package:bab_babbab_front/screens/posts/postsPage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    String userId = 'user-123'; 
    _pages = [
      _HomeMainContent(userId: userId),
      PostsPage(),
      RankingPage(),
      Center(child: Text('내 정보 페이지')),
    ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
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

class _HomeMainContent extends StatefulWidget {
  final String userId;
  const _HomeMainContent({super.key, required this.userId});

  @override
  State<_HomeMainContent> createState() => _HomeMainContentState();
}

class _HomeMainContentState extends State<_HomeMainContent> {
  late Future<int> streakCount;

  @override
  void initState() {
    super.initState();
    streakCount = fetchStreakCount();
  }

  Future<int> fetchStreakCount() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/stats/sequence/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('연속 일수 가져오기 실패함');
    }
  }

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
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 24,
            ),
          ),
          SizedBox(height: 28),
          Row(
            children: [
              Container(
                width: containerWidth / 2 - 7, 
                height: 213,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 3),
                    FutureBuilder<int>(
                      future: streakCount,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text("에러 발생");
                        } else {
                          final count = snapshot.data!;
                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 110,
                                child: Center(
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Image.asset(
                                'assets/icon/circle-line.png',
                                width: 110,
                                height: 110,
                              ),
                              Positioned(
                                top: -20,
                                child: Image.asset(
                                  'assets/icon/fire.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const Text(
                      '연속 성공!',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14),
              Column(
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => FoodBoardPage()),
                        );
                      },
                      child: Container(
                        width: containerWidth / 2 - 7,
                        height: 96,
                        padding: EdgeInsets.only(top: 17, left: 30, bottom: 17),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              "우리 학교\n급식",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 14,
                                color: Color(0xff898A8D),
                              ),
                            ),
                            SizedBox(width: 18),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Image.asset(
                                'assets/icon/foodBoard.png',
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: Container(
                        width: containerWidth / 2 - 7,
                        height: 96,
                        padding: EdgeInsets.only(top: 17, left: 30, bottom: 17),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              "우리 학교\n랭킹",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 14,
                                color: Color(0xff898A8D),
                              ),
                            ),
                            SizedBox(width: 18),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Image.asset(
                                'assets/icon/ranking.png',
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
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
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
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
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
            ),
          ),
          SizedBox(height: 17),
          Container(
            width: containerWidth,
            height: 126,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
