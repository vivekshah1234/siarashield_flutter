import 'package:flutter/material.dart';

/// A class that contains constant API endpoint paths for the application.
///
/// This class defines the base URL and various API endpoints used for
/// interacting with the CyberSiara service.
abstract class ApiConstant {
  /// The base URL for API requests.
  static String baseUrl = "https://embed.mycybersiara.com/api/";

  /// Endpoint to retrieve CyberSiara configuration for Android devices.
  static String getCyberSiaraForAndroid = "CyberSiara/GetCyberSiaraForAndroid";

  /// Endpoint to submit a verified captcha response for Android devices.
  static String verifiedSubmitForAndroid = "SubmitCaptcha/VerifiedSubmitForAndroid";

  /// Endpoint to generate a captcha for Android devices.
  static String captchaForAndroid = "GenerateCaptcha/CaptchaForAndroid";

  /// Endpoint to submit captcha information for Android devices.
  static String submitCaptchInfoForAndroid = "SubmitCaptcha/SubmitCaptchInfoForAndroid";

  /// Endpoint to validate authentication tokens.
  static String validateToken = "validate-token";
}

abstract class ImageAssets {
  ImageAssets._();
  static const String asset = "assets/";
  static const String checkCircle = "${asset}check-circle.gif";
  static const String close = "${asset}close.png";
  static const String dot = "${asset}dots.png";
  static const String download = "${asset}download.png";
  static const String hide = "${asset}hide.png";
  static const String logo = "${asset}logo.png";
  static const String refreshPage = "${asset}refresh-page-option.png";
  static const String rightCaptcha = "${asset}RightCaptcha.gif";
  static const String slideArrow = "${asset}slideArrow.png";
  static const String view = "${asset}view.png";
  static const String refreshIcon = "${asset}refresh_icon.png";
}

abstract class AppColors {
  AppColors._();
  static const Color blueColor = Color(0xff3d6db8);
  static const Color blueColor2 = Color(0xff3a6bb7);
  static const Color blackColor = Color(0xff000000);
  static const Color whiteColor = Colors.white;
  static Color yellowColor = const Color(0xffefb546);
  static const Color greyColor = Colors.grey;
  static const Color orangeColor = Color(0xffed7700);
  static const Color pinkColor = Color(0xffeb536a);
}
