import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Stub for web — replaced by native impl on mobile/desktop
import 'custom_cache_manager_stub.dart' if (dart.library.io) 'custom_cache_manager_native.dart';

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'customCache';

  static final CustomCacheManager _instance = CustomCacheManager._internal();
  factory CustomCacheManager() => _instance;

  CustomCacheManager._internal()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7),
            fileService: buildNativeFileService(), // mobile/desktop: apply the fix ✅
          ),
        );
}
