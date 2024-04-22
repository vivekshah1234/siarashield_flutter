import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siarashield_flutter/common/extension_widget.dart';
import 'package:slider_button/slider_button.dart';
import 'application_constants/app_constant.dart';
import 'common/common_widgets.dart';
import 'controllers/sara_shield_controller.dart';

class CyberCieraModel{
  late final String masterUrlId;
  late final String requestUrl;
  CyberCieraModel({required this.masterUrlId,required this.requestUrl});
}
class SaraShieldWidget extends StatefulWidget {
  final CyberCieraModel cieraModel;
  final Function(bool isTrue) loginTap;

  const SaraShieldWidget({super.key, required this.cieraModel, required this.loginTap});

  @override
  State<SaraShieldWidget> createState() => _SaraShieldWidgetState();
}

class _SaraShieldWidgetState extends State<SaraShieldWidget> {
  @override
  Widget build(BuildContext context) {
    return GetX<SaraShieldController>(
      init: SaraShieldController(),
      initState: (val) {
        val.controller?.getMyDeviceInfo(screenHeight(context), screenWidth(context), widget.cieraModel);
      },
      builder: (controller) {
        return controller.isLoading.value
            ? const Center(child: LoadingWidget())
            : Container(
                decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    )),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: AppColors.whiteColor,
                      shadowColor: AppColors.greyColor,
                      semanticContainer: true,
                      surfaceTintColor: AppColors.whiteColor,
                      elevation: 2,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: controller.isVerified.value
                                        ? Container(
                                            height: 50,
                                            decoration: BoxDecoration(color: AppColors.blueColor, borderRadius: BorderRadius.circular(50)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Expanded(
                                                  child: Text(
                                                    "Verified!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: AppColors.whiteColor, fontSize: 18, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                CircleAvatar(
                                                    radius: 23,
                                                    backgroundColor: Colors.green,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: Image.asset(
                                                        ImageAssets.checkCircle,
                                                        scale: 4,package: 'siarashield_flutter',fit: BoxFit.fitHeight,
                                                      ),
                                                    )),
                                              ],
                                            ))
                                        : controller.isOtherLoading.value
                                            ? const LoadingWidget2()
                                            : SliderButton(
                                                backgroundColor: AppColors.greyColor2,
                                                shimmer: false,
                                                disable: false,
                                                buttonSize: 50,
                                                // dismissThresholds: 0.2,
                                                // radius: 100,
                                                vibrationFlag: true,
                                                width: 200,
                                                action: () async {
                                                  await controller.slideButton(context, widget.cieraModel);
                                                  return false;
                                                },
                                                alignLabel: Alignment.center,
                                                label: const Padding(
                                                  padding: EdgeInsets.only(top: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("          Human User?",
                                                          style: TextStyle(color: AppColors.blueColor2, fontSize: 16, fontWeight: FontWeight.w500)),
                                                      Text("            Slide to verify",
                                                          style: TextStyle(color: AppColors.greyColor3, fontSize: 14, fontWeight: FontWeight.w400)),
                                                    ],
                                                  ),
                                                ),
                                                icon: CircleAvatar(child: Image.asset(ImageAssets.slideArrow,  package: 'siarashield_flutter',)),
                                                // child: isSlide ? Image.asset(ImageAssets.checkCircle) : null
                                              )),
                              ),
                              const SizedBox(width: 5,),
                              Expanded(
                                  flex: 2,
                                  child: Image.asset(
                                    ImageAssets.download,
                                    scale: 4,
                                    package: 'siarashield_flutter',
                                  ))
                            ],
                          ).putPadding(2, 5),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Text("Protected by CyberSiARA",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: AppColors.blueColor2,   letterSpacing: 1, fontSize: 12, fontWeight: FontWeight.w600))),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Privacy Terms",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.blueColor2,
                                        letterSpacing: 1,
                                        fontSize: 12, fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ).putPadding(2, 14),
                          const SizedBox(
                            height: 7,
                          )
                        ],
                      ),
                    ),
                    controller.isVerified.value
                        ? const SizedBox(
                            height: 15,
                          )
                        : const SizedBox(),
                    controller.isVerified.value
                        ? Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  onTap: () {
                                    widget.loginTap(true);
                                  },
                                  title: "LOGIN",
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              );
      },
    );
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