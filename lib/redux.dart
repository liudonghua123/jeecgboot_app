import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'redux/locale.dart';
import 'redux/theme.dart';

export 'redux/locale.dart';
export 'redux/theme.dart';

@immutable
class AppState {
  final ThemeData themeData;
  final Locale locale;
  AppState({
    @required this.themeData,
    @required this.locale,
  });
  factory AppState.initState() => AppState(
        themeData: ThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.light,
        ),
        locale: Locale('zh', 'CN'),
      );
}

AppState reducer(AppState state, action) {
  return AppState(
    themeData: themeDataReducer(state.themeData, action),
    locale: localeReducer(state.locale, action),
  );
}
