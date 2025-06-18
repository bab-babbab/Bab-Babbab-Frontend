import 'package:flutter/material.dart';
import 'package:bab_babbab_front/service/firebase_auth.dart';
import 'package:bab_babbab_front/screens/information/InfoPage.dart';

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
            Image.asset('assets/icon/babbabbab.png', height: 190),
            const SizedBox(height: 172),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await _authService.signInWithGoogle();
                if (result != null) {
                  final id = result.user?.uid ?? '';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformationPage(id: id),
                    ),
                  );
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
                style: TextStyle(fontSize: 17, color: Color(0xffAAAAAA)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                alignment: Alignment.center,
                minimumSize: const Size(305, 50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
