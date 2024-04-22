import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'siarashield_flutter_method_channel.dart';

abstract class SiarashieldFlutterPlatform extends PlatformInterface {
  /// Constructs a SiarashieldFlutterPlatform.
  SiarashieldFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SiarashieldFlutterPlatform _instance = MethodChannelSiarashieldFlutter();

  /// The default instance of [SiarashieldFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSiarashieldFlutter].
  static SiarashieldFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SiarashieldFlutterPlatform] when
  /// they register themselves.
  static set instance(SiarashieldFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
