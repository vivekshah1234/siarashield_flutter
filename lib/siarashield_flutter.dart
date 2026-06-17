import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siarashield_flutter/common/extension_widget.dart';
import 'package:siarashield_flutter/constants/app_constant.dart';
import 'package:siarashield_flutter/popup_screen.dart';

import 'common/custom_widgets.dart';
import 'constants/shared_prefrence_storage.dart';
import 'controllers/sara_shield_controller.dart';

/// A model class representing the CyberCiera authentication details.
class CyberSiaraModel {
  /// A unique identifier for the master URL.
  late final String masterUrlId;

  /// The request URL used for API interactions.
  late final String requestUrl;

  /// A private key used for authentication and security purposes.
  late final String privateKey;

  /// Constructor to initialize the `CyberCieraModel`.
  ///
  /// - [masterUrlId]: A unique identifier for the master URL.
  /// - [requestUrl]: The API request URL.
  /// - [privateKey]: A private key used for authentication.
  CyberSiaraModel({
    required this.masterUrlId,
    required this.requestUrl,
    required this.privateKey,
  });
}

class CyberSiaraWidget extends StatefulWidget {
  final CyberSiaraModel cyberSiaraModel;
  final Function(bool isTrue) loginTap;

  const CyberSiaraWidget({super.key, required this.cyberSiaraModel, required this.loginTap});

  @override
  State<CyberSiaraWidget> createState() => _CyberSiaraWidgetState();
}

class _CyberSiaraWidgetState extends State<CyberSiaraWidget> {
  /// Checks the stored authentication token and its verification status.
  ///
  /// This function retrieves a stored token from local storage and determines
  /// whether it matches the expected private key and if the verification status
  /// is `true`. If the token does not exist or does not match, it updates the storage
  /// accordingly.
  ///
  /// Returns a `Future<bool>` indicating whether the stored token is verified.
  Future<bool> checkStorage() async {
    bool isVerified = false;
    try {
      // Retrieve the stored token from local storage.
      Map<String, dynamic>? token = await getToken();

      // If no token exists, store a new one with the private key and set verification to false.
      if (token == null || token.isEmpty) {
        setToken({"Token": widget.cyberSiaraModel.privateKey, "isVerified": false});
      }
      // If the stored token matches the expected private key and is verified, return true.
      else if (token["Token"] == widget.cyberSiaraModel.privateKey && token["isVerified"] == true) {
        isVerified = true;
      }
      // If the stored token matches the private key but is not verified, return false.
      else if (token["Token"] == widget.cyberSiaraModel.privateKey && token["isVerified"] == false) {
        isVerified = false;
      }
      // If the stored token does not match the private key, update storage and return false.
      else if (token["Token"] != widget.cyberSiaraModel.privateKey) {
        setToken({"Token": widget.cyberSiaraModel.privateKey, "isVerified": false});
        isVerified = false;
      }
    } catch (e) {
      // Log any errors that occur during token retrieval or storage update.
      log("Error in checkStorage: $e");
    }

    // Return the verification status.
    return isVerified;
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SaraShieldController>(
      init: SaraShieldController(),
      initState: (val) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          val.controller?.getMyDeviceInfo(screenHeight(context), screenWidth(context), widget.cyberSiaraModel);
        });
      },
      builder: (controller) {
        return controller.isLoading.value
            ? const Center(child: LoadingWidget())
            : Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: controller.isOtherLoading.value
                        ? const LoadingWidget()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  _submitButtonTap(controller);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blueColor,
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.whiteColor),
                                  maxLines: 1,
                                )),
                          ))
                .putPadding(2, 5);
      },
    );
  }

  /// Handles the submission of the login process, including storage validation,
  /// slide button verification, and captcha authentication if needed.
  _submitButtonTap(SaraShieldController controller) async {
    bool isVerified = await checkStorage();

    /// If the user is already verified, call the `loginTap` callback with `true`
    /// and return early to avoid unnecessary API calls.
    if (isVerified) {
      widget.loginTap(true);
      return;
    }
    if (!context.mounted) return;

    /// Attempt to verify the user using the slide button.
    await controller.slideButton(widget.cyberSiaraModel);

    if (controller.isVerified.value) {
      /// If the slide verification is successful, store the authentication token.
      setToken({"Token": widget.cyberSiaraModel.privateKey, "isVerified": true});
    }

    /// If slide verification fails and there is no API error, trigger the captcha popup.
    else if (!controller.isVerified.value && controller.apiError.value.isEmpty) {
      if (!context.mounted) return;

      /// The `PopupScreen` widget is responsible for rendering the captcha input.
      /// When the user submits the captcha, the `loginTap` callback verifies if the
      /// captcha is correct. If verified, it updates the verification status and
      /// stores the token with the verified state.
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupScreen(
            cieraModel: widget.cyberSiaraModel,
            visiterId: controller.visiterId.value,
            requestId: controller.requestId.value,
            loginTap: (val) {
              /// If the Captcha is correct, set the verification status to true
              /// and store the authentication token.
              if (val == true) {
                controller.isVerified.value = true;
                setToken({"Token": widget.cyberSiaraModel.privateKey, "isVerified": true});
              }
            },
          ).alertCard(context);
        },
      );
    }
  }

  @override
  void dispose() {
    Get.delete<SaraShieldController>();
    super.dispose();
  }
}

class MyPlugin {
  final AssetBundle assetBundle;

  MyPlugin(this.assetBundle);

  Future<Uint8List> loadImage(String imagePath) async {
    ByteData data = await assetBundle.load(imagePath);
    return data.buffer.asUint8List();
  }
}
