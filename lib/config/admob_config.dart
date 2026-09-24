import 'package:flutter/services.dart';

class AdmobConfig {
  AdmobConfig._();

  static String _bannerAdUnitId = '';

  static String get bannerAdUnitId => _bannerAdUnitId;

  static Future<void> load() async {
    final contents = await rootBundle.loadString('.env');
    final values = <String, String>{};

    for (final line in contents.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final separator = trimmed.indexOf('=');
      if (separator == -1) continue;

      values[trimmed.substring(0, separator).trim()] = trimmed
          .substring(separator + 1)
          .trim();
    }

    _bannerAdUnitId = values['ADMOB_BANNER_AD_UNIT_ID'] ?? '';
  }
}
