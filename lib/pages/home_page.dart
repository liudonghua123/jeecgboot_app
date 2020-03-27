import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import '../localization.dart';
import 'clue_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title),
      ),
      // bottomNavigationBar: FancyBottomNavigation(
      //   tabs: [
      //     TabData(iconData: Icons.home, title: "主页"),
      //     // TabData(iconData: Icons.search, title: "搜索"),
      //     TabData(iconData: Icons.people, title: "我的")
      //   ],
      //   onTabChangedListener: (int index) {
      //     setState(() {
      //       _currentIndex = index;
      //       _pageController.jumpToPage(index);
      //     });
      //   },
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("主页")),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("我的"))
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[CluePage(), ProfilePage()],
        ),
      ),
    );
  }
}
