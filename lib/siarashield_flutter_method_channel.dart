import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'siarashield_flutter_platform_interface.dart';

/// An implementation of [SiarashieldFlutterPlatform] that uses method channels.
class MethodChannelSiarashieldFlutter extends SiarashieldFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('siarashield_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
