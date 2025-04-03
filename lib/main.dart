import 'package:flutter/material.dart';
import 'package:bab_babbab_front/screens/main/selectPage.dart';
import 'package:bab_babbab_front/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bab_babbab_front/screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'bab-babbab',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   splashFactory: NoSplash.splashFactory, 
      //   highlightColor: Colors.transparent,
      //   splashColor: Colors.transparent,
      // ),
      debugShowCheckedModeBanner: false,
      title: 'bab-babbab',
      // home: SelectPage(),
      home: HomePage(),
    );
  }
}