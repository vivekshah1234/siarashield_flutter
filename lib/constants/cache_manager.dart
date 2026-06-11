import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';

import 'app_constant.dart'; // ← wraps dart:io HttpClient into http.Client

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'customCache';

  static final CustomCacheManager _instance = CustomCacheManager._internal();
  factory CustomCacheManager() => _instance;

  CustomCacheManager._internal()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7),
            fileService: HttpFileService(
              httpClient: _buildHttpClient(), // ← now returns http.Client ✅
            ),
          ),
        );

  static IOClient _buildHttpClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host == Uri.parse(ApiConstant.baseUrl).host;
      };

    return IOClient(httpClient); // ← wraps dart:io HttpClient → http.Client
  }
}
