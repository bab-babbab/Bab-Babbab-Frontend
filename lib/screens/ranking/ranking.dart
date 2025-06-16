import 'package:flutter/material.dart';
import 'package:bab_babbab_front/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Map<String, dynamic>> rankings = [];
  Map<String, Map<String, dynamic>> userInfoCache = {};
  Map<String, dynamic>? currentUserInfo;
  Map<String, dynamic>? currentUserStats;
  int? currentUserRank;
  bool isLoading = true;
  String? error;
  bool hasLoaded = false;

  Future<void> _loadRanking(String? userId) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final rankingData = await ApiService.getRanking();

      Map<String, Map<String, dynamic>> userInfoMap = {};
      for (var ranking in rankingData) {
        try {
          final userProfile = await ApiService.getUserInfo(ranking['userId']);
          userInfoMap[ranking['userId']] = userProfile['userInfo'];
        } catch (e) {
          userInfoMap[ranking['userId']] = {
            'id': ranking['userId'],
            'name': '사용자',
          };
        }
      }

      int? userRank;
      Map<String, dynamic>? userStats;
      for (int i = 0; i < rankingData.length; i++) {
        if (rankingData[i]['userId'] == userId) {
          userRank = i + 1;
          userStats = rankingData[i];
          break;
        }
      }

      Map<String, dynamic>? userInfo;
      if (userId != null) {
        try {
          final userProfile = await ApiService.getUserInfo(userId);
          userInfo = userProfile['userInfo'];
        } catch (e) {
          userInfo = {'id': userId, 'name': '사용자'};
        }
      }

      setState(() {
        rankings = rankingData;
        userInfoCache = userInfoMap;
        currentUserInfo = userInfo;
        currentUserStats = userStats;
        currentUserRank = userRank;
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (!hasLoaded && user.id != null) {
      _loadRanking(user.id);
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F8F9),
      body: RefreshIndicator(
        onRefresh: () => _loadRanking(user.id),
        child: _RankingMainContent(
          rankings: rankings,
          userInfoCache: userInfoCache,
          currentUserInfo: currentUserInfo,
          currentUserStats: currentUserStats,
          currentUserRank: currentUserRank,
          isLoading: isLoading,
          error: error,
          onRetry: () => _loadRanking(user.id),
        ),
      ),
    );
  }
}

class _RankingMainContent extends StatelessWidget {
  final List<Map<String, dynamic>> rankings;
  final Map<String, Map<String, dynamic>> userInfoCache;
  final Map<String, dynamic>? currentUserInfo;
  final Map<String, dynamic>? currentUserStats;
  final int? currentUserRank;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const _RankingMainContent({
    super.key,
    required this.rankings,
    required this.userInfoCache,
    this.currentUserInfo,
    this.currentUserStats,
    this.currentUserRank,
    required this.isLoading,
    this.error,
    required this.onRetry,
  });

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserStatsCard(),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Text(
              '이번 주 랭킹',
              style: TextStyle(fontFamily: 'Pretendard', fontSize: 20),
            ),
          ),
          Expanded(child: _buildRankingContent()),
        ],
      ),
    );
  }

  Widget _buildUserStatsCard() {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 164,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xffFFAD0A)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${currentUserRank ?? '-'}',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff898A8D),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
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
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUserInfo?['name'] ?? '사용자',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff000000),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Wrap(
                        children: [
                          Text(
                            '연속 ${currentUserStats?['streak'] ?? 0}일',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              color: Color(0xff969696),
                            ),
                          ),
                          Text(
                            ' | ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff969696),
                            ),
                          ),
                          Text(
                            '뱃지 ${currentUserStats?['badge'] ?? 0}개',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              color: Color(0xff969696),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
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

                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Container(height: 60, width: 1, color: Color(0xffE8E8E9)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/badge.png',
                          width: 27,
                          height: 27,
                          color: Color(0xffFFAD0A),
                        ),
                        SizedBox(height: 8),
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
                  Container(height: 60, width: 1, color: Color(0xffE8E8E9)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildColorBoxes(), SizedBox(height: 8)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xffFFAD0A)));
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Color(0xff898A8D)),
            SizedBox(height: 16),
            Text(
              '랭킹을 불러올 수 없습니다',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                color: Color(0xff898A8D),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFAD0A),
                foregroundColor: Colors.white,
              ),
              child: Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (rankings.isEmpty) {
      return Center(
        child: Text(
          '랭킹 데이터가 없습니다',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            color: Color(0xff898A8D),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final ranking = rankings[index];
        final userInfo = userInfoCache[ranking['userId']];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 75),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Color(0xff898A8D),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xffE8E8E9),
                    backgroundImage:
                        userInfo?['profile'] != null
                            ? NetworkImage(userInfo!['profile'])
                            : null,
                    child:
                        userInfo?['profile'] == null
                            ? Icon(Icons.person, color: Color(0xff898A8D))
                            : null,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userInfo?['name'] ?? '사용자',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Wrap(
                          children: [
                            Text(
                              '${ranking['streak'] ?? 0}일참여',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Pretendard',
                                color: Color(0xff898A8D),
                              ),
                            ),
                            Text(
                              ' | ',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff898A8D),
                              ),
                            ),
                            Text(
                              '뱃지 ${ranking['badge'] ?? 0}개',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Pretendard',
                                color: Color(0xff898A8D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
