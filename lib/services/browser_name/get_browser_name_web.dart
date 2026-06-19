import 'dart:js_interop';

@JS('navigator.userAgent')
external JSString get ua;
String getBrowserName() {
  final userAgent = ua.toDart.toLowerCase();
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
}