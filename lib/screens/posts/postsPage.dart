import 'package:bab_babbab_front/screens/posts/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<Map<String, int>> activityData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserModel>(context);
    activityData = fetchActivityData(user.id);
  }

  Future<Map<String, int>> fetchActivityData(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/stats/daily/$userId'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return {for (var item in data) item['date']: item['count']};
    } else {
      throw Exception('데이터를 불러오지 못했습니다');
    }
  }

  Color getColorByCount(int? count) {
    switch (count) {
      case 3:
        return const Color(0xFFFFAD0A);
      case 2:
        return const Color(0xFFFFD37B);
      case 1:
        return const Color(0xFFFFEFCE);
      default:
        return const Color(0xFFE8E8E8);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 50;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8F9),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, top: 100, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 16),
              child: Text(
                '나의 현황',
                style: TextStyle(fontFamily: 'Pretendard', fontSize: 24),
              ),
            ),
            Container(
              width: containerWidth,
              height: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: FutureBuilder<Map<String, int>>(
                future: activityData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('에러 발생'));
                  } else {
                    return DailyActivityGrid(
                      activityData: snapshot.data!,
                      getColorByCount: getColorByCount,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '게시물',
                  style: TextStyle(fontFamily: 'Pretendard', fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostsListPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: containerWidth,
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyActivityGrid extends StatelessWidget {
  final Map<String, int> activityData;
  final Color Function(int?) getColorByCount;

  const DailyActivityGrid({
    super.key,
    required this.activityData,
    required this.getColorByCount,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final List<Widget> boxes = [];

    for (int i = 59; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateString = date.toIso8601String().substring(0, 10);
      final count = activityData[dateString];
      final color = getColorByCount(count);

      boxes.add(
        Container(
          width: 19,
          height: 19,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );
    }

    return Wrap(spacing: 4, runSpacing: 4, children: boxes);
  }
}
