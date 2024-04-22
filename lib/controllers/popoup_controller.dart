import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:public_ip_address/public_ip_address.dart';

import '../application_constants/app_constant.dart';
import '../application_constants/network_call.dart';
import '../common/common_widgets.dart';
import '../siarashield_flutter.dart';

class PopupController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isOtherLoading = false.obs;
  RxString error = "".obs;
  RxString apiError = "".obs;
  RxString requestId = "".obs;
  RxString visiterId = "".obs;
  String deviceName = "";
  String deviceIp = "";
  String udid = "";
  RxBool isVerified = false.obs;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final IpAddress _ipAddress = IpAddress();
  RxString captchaUrl = "".obs;

  getCaptcha({required double height, required double width, required String visiterId,required CyberCieraModel cieraModel}) async {
    isOtherLoading(true);
    error("");
    apiError("");
    captchaUrl("");

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
        "VisiterId": visiterId,
      };
      await postAPI(
          methodName: ApiConstant.captchaForAndroid,
          param: map,
          callback: (value) {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["Message"] == "success") {
              captchaUrl(valueMap["HtmlFormate"]);
            } else {
              toast("Api Error");
            }
          });
    } catch (err) {
      error(err.toString());
      toast(error.value);
    } finally {
      isOtherLoading(false);
    }
  }

  RxBool isSuccess = false.obs;

  submitCaptcha({required String txt, required String requestId, required String visiterId,required CyberCieraModel cieraModel}) async {
    isLoading(true);
    error("");
    apiError("");
    isSuccess(false);
    try {
      Map<String, dynamic> map = {
        "MasterUrl":cieraModel.masterUrlId,// "VYz433DfqQ5LhBcgaamnbw4Wy4K9CyQT",
        "DeviceIp": deviceIp,
        "DeviceType": Platform.isAndroid ? "Android" : "ios",
        "DeviceName": deviceName,
        "UserCaptcha": txt,
        "ByPass": "Netural",
        "BrowserIdentity": udid,
        "Timespent": "24",
        "Protocol": "http",
        "Flag": "1",
        "second": "2",
        "RequestID": requestId,
        "VisiterId": visiterId,
        "fillupsecond": "8"
      };

      await postAPI(
          methodName: ApiConstant.submitCaptchInfoForAndroid,
          param: map,
          callback: (value) {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["Message"] == "success") {
              isSuccess(true);
            } else {}
          });
    } catch (err) {
      error(err.toString());
      toast(error.value);
    } finally {
      isLoading(false);
    }
  }
}
