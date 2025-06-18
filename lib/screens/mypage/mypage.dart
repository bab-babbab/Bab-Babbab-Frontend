import 'package:bab_babbab_front/screens/information/selectPage.dart';
import 'package:bab_babbab_front/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Map<String, dynamic>? currentUserInfo;
  Map<String, dynamic>? currentUserStats;
  bool isLoading = true;
  String? error;
  bool hasLoaded = false;

  Future<void> _loadUserData(String? userId) async {
    if (userId == null) return;

    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // 사용자 정보 가져오기
      final userProfile = await ApiService.getUserInfo(userId);

      // 랭킹 데이터에서 현재 사용자의 통계 찾기
      final rankingData = await ApiService.getRanking();
      Map<String, dynamic>? userStats;

      for (var ranking in rankingData) {
        if (ranking['userId'] == userId) {
          userStats = ranking;
          break;
        }
      }

      setState(() {
        currentUserInfo = userProfile['userInfo'];
        currentUserStats = userStats;
        isLoading = false;
        hasLoaded = true;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildColorBoxes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 2, bottom: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFCE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD37B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFFFAD0A),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBox({required Widget child}) {
    return Container(
      width: 100,
      height: 87.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    // 데이터가 로드되지 않았고 사용자 ID가 있으면 로드
    if (!hasLoaded && user.id != null) {
      _loadUserData(user.id);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      body: RefreshIndicator(
        onRefresh: () => _loadUserData(user.id),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 57),
                Row(
                  children: [
                    isLoading
                        ? CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xffE8E8E9),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xffFFAD0A),
                          ),
                        )
                        : CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xffE8E8E9),
                          backgroundImage:
                              currentUserInfo?['profile'] != null
                                  ? NetworkImage(currentUserInfo!['profile'])
                                  : null,
                          child:
                              currentUserInfo?['profile'] == null
                                  ? Icon(Icons.person, color: Color(0xff898A8D))
                                  : null,
                        ),
                    const SizedBox(width: 24),
                    Text(
                      '${user.name}님',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBox(
                        child:
                            isLoading
                                ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xffFFAD0A),
                                )
                                : Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Image.asset(
                                      'assets/icon/circle-line.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    Positioned(
                                      top: -10,
                                      child: Image.asset(
                                        'assets/icon/fire.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    Text(
                                      '${currentUserStats?['streak'] ?? 0}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff585858),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                      SizedBox(width: 8), // 간격 추가

                      _buildStatBox(
                        child:
                            isLoading
                                ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xffFFAD0A),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icon/badge.png',
                                      width: 27,
                                      height: 27,
                                      color: Color(0xffFFAD0A),
                                    ),
                                    SizedBox(height: 7),
                                    Text(
                                      '${currentUserStats?['badge'] ?? 0}개의 뱃지',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        color: Color(0xff898A8D),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                      SizedBox(width: 8), // 간격 추가

                      _buildStatBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_buildColorBoxes(), SizedBox(height: 8)],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// 학교/학급 정보
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200, // 텍스트가 너무 길지 않도록 너비 제한
                                child: Text(
                                  user.school,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.gradeClass,
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff898A8D),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          // 기존 SizedBox(width: 150)는 제거
                        ],
                      ),
                      // 이미지를 위치 고정
                      const Positioned(
                        left: 238,
                        top: 8.5,
                        child: Image(
                          image: AssetImage('assets/icon/school.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),

                /// 정보 변경 / 로그아웃
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          '로그아웃',
                          style: TextStyle(
                            color: Color(0xffFF7D7D),
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectPage(),
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
      ),
    );
  }
}
