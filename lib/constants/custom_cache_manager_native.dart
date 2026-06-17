import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';

import 'app_constant.dart';

FileService buildNativeFileService() {
  final httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return host == Uri.parse(ApiConstant.baseUrl).host;
    };

  return HttpFileService(httpClient: IOClient(httpClient));
}
