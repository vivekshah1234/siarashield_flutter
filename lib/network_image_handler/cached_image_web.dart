import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

/// Registers a custom HTML ImageElement for Flutter Web.
/// This is mainly used to render image formats (such as GIFs)
/// that may not behave correctly with Flutter's default image widgets.

/// [url]    -> Image URL to be displayed.
/// [viewId] -> Unique identifier used by HtmlElementView.
void registerGifView(String url, String viewId) {
  ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
    return html.ImageElement()
      ..src = url
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain';
  });
}

/// Web-specific image widget.

/// Creates an [HtmlElementView] that renders an underlying
/// HTML `<img>` element. Useful for displaying GIFs or images
/// directly through the browser rendering engine.
///
/// Parameters:
/// - [url]     : Network image URL.
/// - [height]  : Optional widget height.
/// - [width]   : Optional widget width.
/// - [boxFit]  : Reserved for future use (currently ignored).
///
/// Returns a [SizedBox] containing an [HtmlElementView].
Widget cachedImageForItem(
  String url, {
  double? height,
  double? width,
  BoxFit? boxFit,
}) {
  // print("web side ");
  final viewId = 'img-view-${url.hashCode}';

  registerGifView(url, viewId);

  return SizedBox(
    height: height ?? 100,
    width: width ?? 100,
    child: HtmlElementView(
      viewType: viewId,
    ),
  );
}
