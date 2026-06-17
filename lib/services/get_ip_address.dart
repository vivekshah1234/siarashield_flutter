import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:public_ip_address/public_ip_address.dart';

Future<String?> getPublicIp() async {
  try {
    if (kIsWeb) {
      final response = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['ip'];
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
