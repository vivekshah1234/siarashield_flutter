import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_constant.dart';
import '../constants/custom_cache_manager.dart';

/// Returns a network image widget with custom caching support.
/// Features:
/// - Uses [CachedNetworkImage] to cache images locally.
/// - Uses a custom cache manager for better cache control.
/// - Displays a loading indicator while the image is downloading.
/// - Shows an error icon if the image fails to load.
///
/// Parameters:
/// - [url] : Image URL to load.
/// - [height] : Optional image height.
/// - [width] : Optional image width.
/// - [boxFit] : Optional fit behavior for the image.
Widget cachedImageForItem(
  String url, {
  double? height,
  double? width,
  BoxFit? boxFit,
}) {
  // print("mobile side ");
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: boxFit,
    cacheManager: CustomCacheManager(),
    placeholder: (_, __) => const Center(
        child: CircularProgressIndicator(
      color: AppColors.blueColor,
      strokeWidth: 3,
    )),
    errorWidget: (_, __, ___) => const Icon(Icons.error),
  );
}
