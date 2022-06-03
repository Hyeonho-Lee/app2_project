import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';
import 'notice_screen.dart';
import 'profile_screen.dart';
import 'alert_screen.dart';
import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/': (context) => HomeScreen(),
        '/notice': (context) => NoticeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/alert': (context) => AlertScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
