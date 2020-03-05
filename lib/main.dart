import 'package:flutter/material.dart';
import './pages/welcome_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await FlutterConfig.loadEnvVariables();

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    WelcomePage.tag: (context) => WelcomePage(),
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    // ClueDetailPage.tag: (context) => ClueDetailPage(),
  };
  @override
  Widget build(BuildContext context) {
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
