import 'package:flutter/services.dart';

Future<String> loadLocalizationAsset() async {
  return await rootBundle.loadString('lib/Lang/en.json');
}
