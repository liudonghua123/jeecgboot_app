import 'package:flutter/material.dart';
import './login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils.dart';

import 'welcome_page.dart';

class AboutFragment extends StatelessWidget {
  AboutFragment({Key key}) : super(key: key);

  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "ACCOUNT",
            style: headerStyle,
          ),
          const SizedBox(height: 10.0),
          Card(
            elevation: 0.5,
            margin: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 0,
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/001-boy.png'),
                  ),
                  title: Text("LiuDonghua"),
                  onTap: () {},
                ),
                _buildDivider(),
                SwitchListTile(
                  activeColor: Colors.purple,
                  value: true,
                  title: Text("Private Account"),
                  onChanged: (val) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            "PUSH NOTIFICATIONS",
            style: headerStyle,
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 0,
            ),
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  activeColor: Colors.purple,
                  value: true,
                  title: Text("Received notification"),
                  onChanged: (val) {},
                ),
                _buildDivider(),
                SwitchListTile(
                  activeColor: Colors.purple,
                  value: false,
                  title: Text("Received newsletter"),
                  onChanged: null,
                ),
                _buildDivider(),
                SwitchListTile(
                  activeColor: Colors.purple,
                  value: true,
                  title: Text("Received Offer Notification"),
                  onChanged: (val) {},
                ),
                _buildDivider(),
                SwitchListTile(
                  activeColor: Colors.purple,
                  value: true,
                  title: Text("Received App Updates"),
                  onChanged: null,
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 0,
            ),
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                // show progress dialog
                showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (BuildContext context) {
                    return LoadingDialog();
                  },
                );
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('token');
                  debugPrint("prefs.remove('token')");
                  // hide progress dialog
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      ModalRoute.withName(WelcomePage.tag));
                });
              },
            ),
          ),
          const SizedBox(height: 60.0),
        ],
      ),
    );
  }
}
