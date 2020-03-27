import 'package:flutter/material.dart' hide Action;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jeecgboot_app/pages/login_page.dart';
import 'package:jeecgboot_app/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../redux.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "账号",
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
                      child: Icon(Icons.person),
                    ),
                    title: Text("Damodar Lohani"),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  SwitchListTile(
                    value: true,
                    title: Text("Private Account"),
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "设置",
              style: headerStyle,
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text("消息"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("设置"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text("反馈意见"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text("关于"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text("选择语言"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () async {
                      // set up the list options
                      var locales = [
                        const Locale('zh', ''),
                        const Locale('en', ''),
                      ];
                      var selections = locales.map((locale) =>
                          SimpleDialogOption(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Container(
                                      child: Text(locale.languageCode))),
                              onPressed: () {
                                Navigator.of(context).pop(locale);
                              }));
                      // set up the SimpleDialog
                      SimpleDialog dialog = SimpleDialog(
                        title: const Text('选择语言'),
                        children: <Widget>[
                          ...selections,
                        ],
                      );
                      // show the dialog
                      Locale locale = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return dialog;
                        },
                      );
                      StoreProvider.of<AppState>(context)
                          .dispatch(RefreshLocaleAction(locale));
                    },
                  ),
                  _buildDivider(),
                  StoreConnector<AppState, ThemeData>(
                    converter: (store) {
                      return store.state.themeData;
                    },
                    builder: (context, themeData) => ListTile(
                      leading: Icon(Icons.info),
                      title: Text("选择主题颜色"),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () async {
                        // set up the list options
                        var colors = <MaterialColor>[
                          Colors.blue,
                          Colors.red,
                          Colors.purple,
                          Colors.green,
                          Colors.brown,
                          Colors.teal,
                          Colors.amber,
                          Colors.orange,
                          Colors.indigo,
                        ];
                        var selections = colors.map((color) =>
                            SimpleDialogOption(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    color: color, height: 50, width: 200),
                                onPressed: () {
                                  Navigator.of(context).pop(color);
                                }));
                        // set up the SimpleDialog
                        SimpleDialog dialog = SimpleDialog(
                          title: const Text('选择主题颜色'),
                          children: <Widget>[
                            ...selections,
                          ],
                        );
                        // show the dialog
                        MaterialColor color = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialog;
                          },
                        );
                        StoreProvider.of<AppState>(context)
                            .dispatch(RefreshThemeDataAction(ThemeData(
                          primarySwatch: color,
                          brightness: themeData.brightness,
                        )));
                      },
                    ),
                  ),
                  _buildDivider(),
                  StoreConnector<AppState, ThemeData>(
                    converter: (store) {
                      return store.state.themeData;
                    },
                    builder: (context, themeData) => SwitchListTile(
                      activeColor: Colors.purple,
                      value: themeData.brightness == Brightness.dark,
                      title: Text("夜间模式"),
                      onChanged: (value) {
                        StoreProvider.of<AppState>(context).dispatch(
                            RefreshThemeDataAction(themeData.copyWith(
                                brightness: value
                                    ? Brightness.dark
                                    : Brightness.light)));
                      },
                    ),
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
                title: Text("退出"),
                onTap: () async {
                  var prefs = await SharedPreferences.getInstance();
                  prefs.remove('token');
                  print("prefs.remove('token')");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      ModalRoute.withName(WelcomePage.tag));
                },
              ),
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );
  }

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
}
