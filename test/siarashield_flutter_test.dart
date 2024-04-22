import 'package:flutter_test/flutter_test.dart';
import 'package:siarashield_flutter/siarashield_flutter_platform_interface.dart';
import 'package:siarashield_flutter/siarashield_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSiarashieldFlutterPlatform
    with MockPlatformInterfaceMixin
    implements SiarashieldFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SiarashieldFlutterPlatform initialPlatform = SiarashieldFlutterPlatform.instance;

  test('$MethodChannelSiarashieldFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSiarashieldFlutter>());
  });

  test('getPlatformVersion', () async {
    // SaraShieldWidget siarashieldFlutterPlugin = SaraShieldWidget();
    // MockSiarashieldFlutterPlatform fakePlatform = MockSiarashieldFlutterPlatform();
    // SiarashieldFlutterPlatform.instance = fakePlatform;
    //
    // expect(await siarashieldFlutterPlugin.getPlatformVersion(), '42');
  });
}
