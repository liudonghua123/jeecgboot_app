import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './login_page.dart';
import './home_page.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);
  static String tag = 'welcome-page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

const Color primary = Color(0xffE20056);
const TextStyle whiteBoldText = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const TextStyle whiteText = TextStyle(
  color: Colors.white,
);
const TextStyle primaryText = TextStyle(
  color: primary,
);

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 300), () {
      _goToHome();
    });
  }

  _goToHome() {
    SharedPreferences.getInstance().then((prefs) {
      String token = prefs.getString('token');
      debugPrint("prefs.getString('token'): $token");
      // check login status
      if (token != null) {
        debugPrint("navigate to HomePage");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        debugPrint("navigate to LoginPage");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Text("正在加载...",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    ));
  }
}
