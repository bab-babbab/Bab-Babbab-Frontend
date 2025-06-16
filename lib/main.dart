import 'package:bab_babbab_front/screens/home/home.dart';
import 'package:bab_babbab_front/screens/information/InfoPage.dart';
import 'package:bab_babbab_front/screens/information/selectPage.dart';
import 'package:bab_babbab_front/screens/posts/create_post.dart';
import 'package:flutter/material.dart';
import 'package:bab_babbab_front/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'bab-babbab',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserModel())],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      title: 'bab-babbab',

      home: SelectPage(),
    );
  }
}
