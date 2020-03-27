import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This file was generated in two steps, using the Dart intl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory:
//
// flutter pub get
// flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/**.dart
// flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localization.dart lib/app.dart
// flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/**.dart lib/l10n/intl_*.arb
// flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localization.dart lib/app.dart lib/l10n/intl_messages.arb lib/l10n/intl_en.arb lib/l10n/intl_zh.arb
// FileSystemException: Cannot open file, path = 'lib/l10n/intl_*.arb' (OS Error: The filename, directory name, or volume label syntax is incorrect.
// The second command generates intl_messages.arb and the third generates
// messages_all.dart. There's more about this process in
// https://pub.dev/packages/intl.

import 'l10n/messages_all.dart';

// https://flutter.dev/docs/development/accessibility-and-localization/internationalization
// https://flutterchina.club/tutorials/internationalization/
// https://www.jianshu.com/p/34a6224e0cf1
class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get title {
    // print('title, localeName: $localeName');
    return Intl.message(
      'App',
      name: 'title',
      desc: 'Title for the application',
      locale: localeName,
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  static AppLocalizationsDelegate delegate = new AppLocalizationsDelegate();
}
