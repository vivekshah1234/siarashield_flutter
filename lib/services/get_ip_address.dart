import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:public_ip_address/public_ip_address.dart';

Future<String?> getPublicIp() async {
  try {
    if (kIsWeb) {
      Dio dio = Dio();
      final response = await dio.get('https://api.ipify.org?format=json');
      if (response.statusCode == 200) {
        return response.data['ip'];
      }
    } else {
      final IpAddress ipAddress = IpAddress();
      return await ipAddress.getIp();
    }
  } catch (e) {
    log(e.toString());
  }

  return null;
}
