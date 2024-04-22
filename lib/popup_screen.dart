
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siarashield_flutter/application_constants/app_constant.dart';

import 'common/common_widgets.dart';
import 'controllers/popoup_controller.dart';
import 'siarashield_flutter.dart';

class PopupScreen extends StatefulWidget {
  final String visiterId;
  final String requestId;
  final CyberCieraModel cieraModel;
  const PopupScreen({super.key, required this.visiterId, required this.requestId, required this.cieraModel});

  @override
  State<PopupScreen> createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen> {
  final TextStyle _t1 = TextStyle(color: AppColors.blackColor.withOpacity(0.2), fontSize: 15, fontWeight: FontWeight.w500);
  String dropdownvalue = "English";
  var items = ["English", "Hindi"];
  final TextEditingController _txtUsername = TextEditingController();
  final border = OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors.greyColor));

  @override
  Widget build(BuildContext context) {
    return GetX<PopupController>(
      init: PopupController(),
      initState: (val) {
        val.controller?.getCaptcha(height: screenHeight(context), width: screenWidth(context), visiterId: widget.visiterId,cieraModel: widget.cieraModel);
      },
      builder: (controller) {
        return LoadingStateWidget(
          isLoading: controller.isLoading.value,
          child: Container(
            decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ImageAssets.download,
                      scale: 5,package: 'siarashield_flutter',
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.blackColor,
                          size: 35,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                // Text("Please select language", style: _t1),
                // const SizedBox(
                //   height: 12,
                // ),
                // Container(
                //   height: 50,
                //   width: double.infinity,
                //   // margin: const EdgeInsets.all(20),
                //   padding: const EdgeInsets.only(left: 20, right: 20),
                //   decoration: BoxDecoration(
                //       color: AppColors.whiteColor, border: Border.all(color: AppColors.blackColor), borderRadius: BorderRadius.circular(5)),
                //   child: DropdownButton(
                //     value: dropdownvalue,
                //     underline: Container(color: Colors.white),
                //     icon: const Icon(Icons.keyboard_arrow_down),
                //     items: items.map((String items) {
                //       return DropdownMenuItem(value: items, child: Text(items));
                //     }).toList(),
                //     onChanged: (String? newValue) async {
                //       dropdownvalue = newValue!;
                //
                //       setState(() {});
                //     },
                //   ),
                // ),
                // const SizedBox(
                //   height: 12,
                // ),
                Text("Type all the displayed letters", style: _t1),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: controller.isOtherLoading.value
                          ? const LoadingWidget2()
                          : SizedBox(
                              height: 50,
                              child: cachedImageForItem(
                                controller.captchaUrl.value,
                                height: 50,
                              ),
                              // decoration: BoxDecoration(color: AppColors.blackColor.withOpacity(0.4)),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        controller.getCaptcha(height: screenHeight(context), width: screenWidth(context), visiterId: widget.visiterId,cieraModel: widget.cieraModel);
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: AppColors.blueColor,
                        size: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                            controller: _txtUsername,
                            cursorColor: AppColors.blackColor,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              disabledBorder: border,
                              errorBorder: border,
                              focusedBorder: border,
                              enabledBorder: border,
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(flex: 2, child: Text("Not Case Sensitive", style: _t1)),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: AppButton(
                        onTap: () async {
                          if (_txtUsername.text.isEmpty) {
                            return;
                          }

                          await controller.submitCaptcha(requestId: widget.requestId, visiterId: widget.visiterId, txt: _txtUsername.text,cieraModel: widget.cieraModel);
                          if (controller.isSuccess.value) {

                            if (context.mounted)  Navigator.pop(context,true);

                          } else {
                            toast("You have enter wrong code"); if (!context.mounted) return;
                            controller.getCaptcha(height: screenHeight(context), width: screenWidth(context), visiterId: widget.visiterId,cieraModel: widget.cieraModel);
                          }
                        },
                        title: "Submit"),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    "Protected by CyberSIARA",
                    style: TextStyle(color: AppColors.blackColor.withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
                Center(
                  child: Text(
                    "Privacy Terms",
                    style: TextStyle(color: AppColors.blackColor.withOpacity(0.5), fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
