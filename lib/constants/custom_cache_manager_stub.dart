import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// No-op stub — never actually called on web (kIsWeb guard above)
FileService buildNativeFileService() => HttpFileService();
