import 'package:bab_babbab_front/screens/posts/create_post.dart';
import 'package:flutter/material.dart';
import 'package:bab_babbab_front/screens/home/environment_news.dart';
import 'package:bab_babbab_front/widgets/bottom_nav_bar.dart';
import 'package:bab_babbab_front/screens/ranking/ranking.dart';
import 'package:bab_babbab_front/screens/home/foodBoardPage.dart';
import 'package:bab_babbab_front/screens/posts/postsPage.dart';
import 'package:bab_babbab_front/screens/mypage/mypage.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';
import 'package:bab_babbab_front/service/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _HomeMainContent(
        onGoToRanking: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      PostsPage(),
      RankingPage(),
      MyPage(),
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
      backgroundColor: const Color(0xffF7F8F9),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageUploadScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 0,
        backgroundColor: Color(0xffFFAD0A),
        shape: CircleBorder(),
      ),
    );
  }
}

class _HomeMainContent extends StatefulWidget {
  final VoidCallback onGoToRanking;

  const _HomeMainContent({super.key, required this.onGoToRanking});
  @override
  State<_HomeMainContent> createState() => _HomeMainContentState();
}

class _HomeMainContentState extends State<_HomeMainContent> {
  late Future<int> streakCount;
  late String userId;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final user = Provider.of<UserModel>(context);
      userId = user.id;
      streakCount = ApiService.fetchStreakCount(userId);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 50;

    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.name}님\n오늘도 수고 했어요!',
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 3),
                    FutureBuilder<int>(
                      future: streakCount,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                    const Text('연속 성공!', style: TextStyle(fontSize: 15)),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodBoardPage(),
                          ),
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
                      onTap: () {
                        if (widget.onGoToRanking != null) {
                          widget.onGoToRanking();
                        }
                      },
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
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                user.message,
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
            child: EnvironmentNews(),
          ),
        ],
      ),
    );
  }
}
