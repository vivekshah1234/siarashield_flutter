import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

String getBrowserName() {
  if (kIsWeb) {
    final userAgent = web.window.navigator.userAgent.toLowerCase();
    print("userAgent==>${userAgent}");
    if (userAgent.contains('edg')) {
      return 'Edge';
    } else if (userAgent.contains('firefox')) {
      return 'Firefox';
    } else if (userAgent.contains('opr') || userAgent.contains('opera')) {
      return 'Opera';
    } else if (userAgent.contains('chrome')) {
      return 'Chrome';
    } else if (userAgent.contains('safari')) {
      return 'Safari';
    }
    return 'Unknown';
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return "android";
      case TargetPlatform.iOS:
        return "iOS";
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'Unsupported';
    }
  }
}
