import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<String> getDeviceName() async {
  final deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    final webInfo = await deviceInfo.webBrowserInfo;

    return '${webInfo.browserName.name} '
        '${webInfo.platform ?? ''}';
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      final androidInfo = await deviceInfo.androidInfo;

      return androidInfo.brand;

    case TargetPlatform.iOS:
      final iosInfo = await deviceInfo.iosInfo;

      return iosInfo.model;

    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
    case TargetPlatform.fuchsia:
      return 'Unsupported';
  }
}

String getDeviceType() {
  if (kIsWeb) {
    return "Web";
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return "Android";

    case TargetPlatform.iOS:
      return "ios";

    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
    case TargetPlatform.fuchsia:
      return 'Unsupported';
  }
}
