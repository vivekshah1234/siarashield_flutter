import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_udid/flutter_udid.dart';

import '../constants/shared_prefrence_storage.dart';

final Random _random = Random();

String randomFPString(int length) {
  const chars = 'QWEuytrRTYklpowqGFDSAZXCVB346NM279mnbUIOvcxzPLKJHasdfghj';

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
    ),
  );
}

Future<String> generateBrowserIdentity() async {
  if (!kIsWeb) {
    return await FlutterUdid.udid;
  } else {
    String id = await getBrowserId() ?? "";
    String deviceFP = id.isEmpty ? randomFPString(20) : id;
    if (id.isEmpty) {
      await setBrowserId(deviceFP);
    }
    return deviceFP;
  }
}
