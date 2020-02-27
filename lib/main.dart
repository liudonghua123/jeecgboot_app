import 'package:flutter/material.dart';
import './pages/welcome_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
// import './pages/clue_detail_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static BuildContext globalContext;
  final routes = <String, WidgetBuilder>{
    WelcomePage.tag: (context) => WelcomePage(),
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    // ClueDetailPage.tag: (context) => ClueDetailPage(),
  };
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      title: 'ROTS APP',
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}
