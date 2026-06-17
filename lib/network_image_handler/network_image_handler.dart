export 'cached_image_mobile.dart' if (dart.library.html) 'cached_image_web.dart';

/// Conditionally exports the appropriate cached image implementation:
/// `cached_image_web.dart` for Web, otherwise `cached_image_mobile.dart`.
