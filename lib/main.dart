import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jeecgboot_app/redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './flutter_configuration.dart';
import './pages/home_page.dart';
import './pages/login_page.dart';
import './pages/welcome_page.dart';

FlutterConfiguration config;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // https://www.woolha.com/tutorials/flutter-setting-orientation-to-landscape-or-portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await FlutterDownloader.initialize();
  config = await FlutterConfiguration.fromAsset('config.yaml');
  runApp(new MyApp());
}

Store<AppState> store = Store<AppState>(
  reducer,
  initialState: AppState.initState(),
  middleware: [thunkMiddleware, LoggingMiddleware.printer()],
);

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    WelcomePage.tag: (context) => WelcomePage(),
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    // ClueDetailPage.tag: (context) => ClueDetailPage(),
  };
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context, store) => MaterialApp(
          title:'App',
          locale: store.state.locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('zh', ''),
            const Locale('en', ''),
          ],
          theme: ThemeData(
            primarySwatch: store.state.themeData.primaryColor,
            brightness: store.state.themeData.brightness,
          ),
          routes: routes,
          home: WelcomePage(),
        ),
      ),
    );
  }
}
