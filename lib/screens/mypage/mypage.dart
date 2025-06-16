import 'package:bab_babbab_front/screens/information/selectPage.dart';
import 'package:bab_babbab_front/screens/mypage/mypageChange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 57),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE8E8E9),
                  child: SvgPicture.asset(
                    'assets/icon/profile.svg',
                    color: Color(0xffFFFFFF),
                    width: 32,
                    height: 32,
                  ),
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
            const SizedBox(height: 30),

            /// 학교/학급 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.school,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.gradeClass,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          color: Color(0xff898A8D),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 150),
                  Image.asset('assets/icon/school.png'),
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
                      '정보 변경',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        color: Color(0xff898A8D),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xffB9BBB9),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MypageChange()),
                      );
                    },
                    textColor: Color(0xff898A8D),
                  ),
                  ListTile(
                    title: const Text(
                      '로그아웃',
                      style: TextStyle(
                        color: Color(0xffFF7D7D),
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SelectPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 90,
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFFF9B233), size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
