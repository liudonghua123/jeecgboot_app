import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'clue_fragment.dart';
import 'about_fragment.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {

    mainContainer(currentPage) {
      Widget widget;
      switch (currentPage) {
        case 0:
          widget = ClueFragment();
          break;
        default:
          widget = AboutFragment();
      }
      return widget;
    }

    final body = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: mainContainer(currentPage),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "主页"),
          // TabData(iconData: Icons.search, title: "搜索"),
          TabData(iconData: Icons.people, title: "我的")
        ],
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      body: body,
    );
  }
}
