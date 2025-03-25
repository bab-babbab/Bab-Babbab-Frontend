import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bab_babbab_front/service/firebase_auth.dart';

class SelectPage extends StatelessWidget {

final AuthService _authService = AuthService();

  SelectPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFAD0A),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo/logo.svg'
            ),
            const SizedBox(height: 172), // 여백
            ElevatedButton.icon(
              onPressed: () async {
                final result = await _authService.signInWithGoogle();
                if (result != null) {
                  print('로그인 완료: ${result.user?.email}');
                } else {
                  print('로그인 실패 또는 취소됨');
                }
              },
              icon: Image.asset(
                'assets/logo/google.png',
                width: 24,
                height: 24,
                alignment: Alignment.centerLeft,
              ),
              label: const Text(
                'Google 계정으로 로그인',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xffAAAAAA)
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                alignment: Alignment.center,
                minimumSize: const Size(305, 50),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
            ),
          ],
        )
        ),
    );
  }
}