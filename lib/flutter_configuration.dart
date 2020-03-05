import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml_config/yaml_config.dart';

class FlutterConfiguration extends YamlConfig {
  String apiBaseUrl;

  @override
  void init() {
    apiBaseUrl = get('API_BASE_URL');
  }

  FlutterConfiguration(String text) : super(text);

  static Future<FlutterConfiguration> fromAsset(String asset) {
    return rootBundle
        .loadString(asset)
        .then((text) => FlutterConfiguration(text));
  }
}
