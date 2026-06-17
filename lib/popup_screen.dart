import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:siarashield_flutter/constants/app_constant.dart';
import 'package:siarashield_flutter/network_image_handler/network_image_handler.dart';

import 'common/custom_widgets.dart';
import 'controllers/popoup_controller.dart';
import 'siarashield_flutter.dart';

class PopupScreen extends StatefulWidget {
  final String visiterId;
  final String requestId;
  final CyberSiaraModel cieraModel;
  final Function(bool isSuccess) loginTap;

  const PopupScreen({super.key, required this.visiterId, required this.requestId, required this.cieraModel, required this.loginTap});

  @override
  State<PopupScreen> createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen> {
  final TextStyle _t1 = const TextStyle(color: AppColors.blackColor, fontSize: 13, fontWeight: FontWeight.w500);

  final TextEditingController _codeTxtEditingController = TextEditingController();

  final border = OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.greyColor));

  @override
  Widget build(BuildContext context) {
    return GetX<PopupController>(
      init: PopupController(),
      initState: (val) {
        val.controller?.getCaptcha(
            height: screenHeight(context),
            width: screenWidth(context),
            visiterId: widget.visiterId,
            requestId: widget.requestId,
            cieraModel: widget.cieraModel);
      },
      builder: (controller) {
        return LoadingStateWidget(
          isLoading: controller.isLoading.value,
          child: Container(
            width: kIsWeb ? 380 : null,
            padding: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ImageAssets.download,
                      scale: 6,
                      package: 'siarashield_flutter',
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.blackColor,
                          size: 25,
                        ))
                  ],
                ),
                const SizedBox(height: 12),
                Text("Type all the displayed letters", style: _t1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: controller.isOtherLoading.value
                          ? const LoadingWidget()
                          : SizedBox(
                              height: kIsWeb ? 75 : 60,
                              width: double.infinity,
                              child: cachedImageForItem(controller.captchaUrl.value, height: 60, boxFit: BoxFit.fitWidth),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          _changeCaptcha(controller);
                        },
                        child: Image.asset(ImageAssets.refreshIcon, scale: 2.5, package: 'siarashield_flutter'),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: 45,
                        child: TextFormField(
                            controller: _codeTxtEditingController,
                            cursorColor: AppColors.blackColor,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(fontSize: 18),
                            maxLength: 4,
                            maxLengthEnforcement: MaxLengthEnforcement.none,
                            buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
                            onChanged: (val) async {
                              _onCaptchaComplete(val, controller);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              disabledBorder: border,
                              errorBorder: border,
                              focusedBorder: border,
                              enabledBorder: border,
                            )),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(flex: 4, child: Text("Type all the displayed letters", style: _t1)),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Protected by CyberSiARA",
                        style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        ImageAssets.download,
                        scale: 8,
                        color: AppColors.greyColor,
                        package: 'siarashield_flutter',
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: Text(
                    "Privacy Terms",
                    style: TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handles the completion of the captcha input process and verifies the entered code.
  _onCaptchaComplete(String val, PopupController controller) async {
    /// Check if the entered captcha code has exactly 4 characters.
    if (val.length == 4) {
      bool isSuccess = await controller.submitCaptcha(
          requestId: widget.requestId, visiterId: widget.visiterId, txt: _codeTxtEditingController.text, cieraModel: widget.cieraModel);

      /// If the captcha is successfully verified:
      if (isSuccess) {
        /// Trigger the login callback with `true` indicating successful verification.
        widget.loginTap(true);
        if (context.mounted) Navigator.pop(context, true);
      } else {
        toast(controller.error.value);
        if (!context.mounted) return;

        /// Reload the captcha with updated parameters to allow the user to retry.
        controller.getCaptcha(
            height: screenHeight(context),
            width: screenWidth(context),
            visiterId: widget.visiterId,
            requestId: widget.requestId,
            cieraModel: widget.cieraModel);
      }
    }
  }

  /// Requests a new captcha from the server to replace the current one.
  /// This is triggered when the user enters an incorrect captcha code,
  /// allowing them to retry with a fresh challenge.
  _changeCaptcha(PopupController controller) {
    controller.getCaptcha(
        height: screenHeight(context),
        width: screenWidth(context),
        visiterId: widget.visiterId,
        requestId: widget.requestId,
        cieraModel: widget.cieraModel);
  }

  @override
  void dispose() {
    Get.delete<PopupController>();
    super.dispose();
  }
}
