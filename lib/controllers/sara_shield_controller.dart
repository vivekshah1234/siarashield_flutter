import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:public_ip_address/public_ip_address.dart';
import 'package:siarashield_flutter/application_constants/network_call.dart';
import 'package:siarashield_flutter/common/extension_widget.dart';

import '../application_constants/app_constant.dart';
import '../common/common_widgets.dart';
import '../models/get_info_model.dart';
import '../popup_screen.dart';
import '../siarashield_flutter.dart';

class SaraShieldController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isOtherLoading = false.obs;
  RxString error = "".obs;
  RxString apiError = "".obs;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final IpAddress _ipAddress = IpAddress();
  RxString requestId = "".obs;
  RxString visiterId = "".obs;
  String deviceName = "";
  String deviceIp = "";
  String udid = "";
  RxBool isVerified = false.obs;

  getMyDeviceInfo(double height, double width,CyberCieraModel cieraModel) async {
    isLoading(true);
    error("");
    apiError("");
    requestId("");
    visiterId("");
    try {
      deviceName = "";
      deviceIp = await _ipAddress.getIp();
      udid = await FlutterUdid.udid;

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.brand;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.model;
      }

      Map<String, dynamic> map = {
        "MasterUrlId":cieraModel.masterUrlId,// "VYz433DfqQ5LhBcgaamnbw4Wy4K9CyQT",
        "RequestUrl":cieraModel.requestUrl,// "com.app.cyber_ceiara",
        "BrowserIdentity": udid,
        "DeviceIp": deviceIp,
        "DeviceType": Platform.isAndroid ? "Android" : "ios",
        "DeviceBrowser": 'Chrome',
        "DeviceName": deviceName,
        "DeviceHeight": height.round(),
        "DeviceWidth": width.round(),
      };

      await postAPI(
          methodName: ApiConstant.getCyberSiaraForAndroid,
          param: map,
          callback: (value) {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["Message"] == "success") {
              GetInfoModel getInfoModel = GetInfoModel.fromJson(valueMap);
              requestId.value = getInfoModel.requestId;
              visiterId.value = getInfoModel.visiterId;
            } else {
              apiError("Api Error");
              toast(apiError.value.toString());
            }
          });
    } catch (err) {
      error(err.toString());
      toast(err.toString());
    } finally {
      isLoading(false);
    }
  }

  slideButton(context, CyberCieraModel cieraModel) async {
    isVerified(false);
    isOtherLoading(true);
    error("");
    apiError("");

    try {
      Map<String, dynamic> map = {
        "MasterUrl":cieraModel.masterUrlId,// "VYz433DfqQ5LhBcgaamnbw4Wy4K9CyQT",
        "BrowserIdentity": udid,
        "DeviceIp": deviceIp,
        "DeviceName": deviceName,
        // "DeviceType": Platform.isAndroid ? "Android" : "ios",
        // "DeviceBrowser": 'Chrome',
        "Protocol": "http",
        "second": "5",
        "RequestID": requestId.value,
        "VisiterId": visiterId.value
      };

      await postAPI(
          methodName: ApiConstant.verifiedSubmitForAndroid,
          param: map,
          callback: (value) async {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["Message"] == "success") {
              // Object? istrue= await showAnimatedDialog(
              //   context: context,
              //   alignment: Alignment.center,
              //   animationType: DialogTransitionType.slideFromBottomFade,
              //   curve: Curves.fastOutSlowIn,
              //   duration: const Duration(milliseconds: 500),
              //   builder: (BuildContext context) {
              //     return PopupScreen(
              //       VisiterId: visiterId.value,
              //       requestId: requestId.value,
              //     ).alertCard(context);
              //   },
              // );
              // if(istrue==true){
              //   isVerified(true);
              // }
              isVerified(true);
            } else {
              Object? istrue = await showAnimatedDialog(
                context: context,
                alignment: Alignment.center,
                animationType: DialogTransitionType.slideFromBottomFade,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 500),
                builder: (BuildContext context) {
                  return PopupScreen(
                  cieraModel: cieraModel,
                    visiterId: visiterId.value,
                    requestId: requestId.value,
                  ).alertCard(context);
                },
              );
              if (istrue == true) {
                isVerified(true);
              }
            }
          });
    } catch (err) {
      error(err.toString());
    } finally {
      isOtherLoading(false);
    }
  }
}
