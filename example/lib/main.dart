import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siarashield_flutter/common/custom_widgets.dart';
import 'package:siarashield_flutter/common/extension_widget.dart';
import 'package:siarashield_flutter/constants/app_constant.dart';
import 'package:siarashield_flutter/siarashield_flutter.dart';
import 'package:siarashield_flutter_example/second_screen.dart';

import 'app_colors.dart';

void main() {
  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _txtUsername = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final border = OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: AppColors1.greyColor));
  final TextStyle _hintStyle = const TextStyle(color: AppColors1.greyColor, fontSize: 16, fontWeight: FontWeight.w500);
  final TextStyle _labelStyle = const TextStyle(color: AppColors1.blueColor, fontSize: 16, fontWeight: FontWeight.w500);
  final TextStyle _subtitle = const TextStyle(color: AppColors1.greyColor, fontSize: 15, fontWeight: FontWeight.w400);
  bool isCheck = false;
  bool isSlide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors1.whiteColor,
      body: Container(
        margin: EdgeInsets.only(top: screenHeight(context) * 0.15, right: 15, left: 15),
        decoration: const BoxDecoration(
            color: AppColors1.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            )),
        child: Column(
          children: [
            Center(
                child: Image.asset(
              ImageAssets.logo,
              scale: 1,
              package: 'siarashield_flutter',
            )),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                controller: _txtUsername,
                cursorColor: AppColors1.blackColor,
                style: _labelStyle,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    disabledBorder: border,
                    errorBorder: border,
                    focusedBorder: border,
                    enabledBorder: border,
                    hintText: "Example@email.com",
                    hintStyle: _hintStyle,
                    labelText: "Email",
                    labelStyle: _labelStyle,
                    suffixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors1.yellowColor,
                    ))).putPadding(15, 15),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                controller: _password,
                obscureText: true,
                cursorColor: AppColors1.blackColor,
                style: _labelStyle,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    disabledBorder: border,
                    errorBorder: border,
                    focusedBorder: border,
                    enabledBorder: border,
                    hintText: "*******",
                    hintStyle: _hintStyle,
                    labelText: "Password",
                    labelStyle: _labelStyle,
                    suffixIcon: Icon(
                      Icons.lock,
                      color: AppColors1.yellowColor,
                    ))).putPadding(15, 15),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                    value: isCheck,
                    onChanged: (val) {
                      isCheck = !isCheck;
                      setState(() {});
                    }),
                Text(
                  "Remember password",
                  style: _subtitle,
                )
              ],
            ).putPadding(15, 15),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CyberSiaraWidget(
                loginTap: (bool isSuccess) {
                  if (isSuccess) {
                    // Handle successful authentication
                    log("Authentication Successful: \$isSuccess");

                    if (_txtUsername.text.isEmpty) {
                      toast("Email can't be empty");
                      return;
                    }
                    if (_password.text.isEmpty) {
                      toast("Password can't be empty");
                      return;
                    }
                    Get.to(() => const SecondScreen());
                  } else {
                    // Handle authentication failure
                    log("Authentication Failed");
                  }
                },
                cyberSiaraModel: CyberSiaraModel(
                  masterUrlId: 'kMcFLdqYxN2j1HduZu6uO54hHjzKKBQz', //Master URl ID
                  requestUrl: 'com.app.cyber_ceiara', //Package name,
                  privateKey: "8KWfnvAJH9kfI9LlUwfBfg1gKP7ddGns", //Private Key
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
