import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:siarashield_flutter/constants/app_constant.dart';
import 'package:siarashield_flutter/constants/dio_service.dart';
import 'package:siarashield_flutter/constants/shared_prefrence_storage.dart';

import '../common/custom_widgets.dart';
import '../models/get_info_model.dart';
import '../models/response_api.dart';
import '../services/generate_random_id.dart';
import '../services/browser_name/get_browser_name.dart';
import '../services/get_device_information.dart';
import '../services/get_ip_address.dart';
import '../siarashield_flutter.dart';

class SaraShieldController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isOtherLoading = false.obs;
  RxString error = "".obs;
  RxString apiError = "".obs;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  RxString requestId = "".obs;
  RxString visiterId = "".obs;

  String deviceName = "";
  String deviceIp = "";
  String udid = "";

  RxBool isVerified = false.obs;

  DateTime? captchaOpenedAt;

  void startCaptchaTimer() {
    captchaOpenedAt = DateTime.now();
  }

  int get timeSpentInSeconds {
    if (captchaOpenedAt == null) return 0;

    return DateTime.now().difference(captchaOpenedAt!).inSeconds;
  }

  /// Fetches and sends device information to the CyberCiera API.
  ///
  /// This function retrieves the device's IP address, unique device ID (UDID),
  /// and other relevant details such as device type, browser identity, and dimensions.
  /// The collected data is then sent to an API endpoint (`getCyberSiaraForAndroid`).
  /// If the API response is successful, it updates `requestId` and `visiterId`,
  /// otherwise, it logs an error message.
  ///
  /// Parameters:
  /// - `height`: The height of the device screen.
  /// - `width`: The width of the device screen.
  /// - `cieraModel`: An instance of `CyberCieraModel` containing API-related information.
  ///
  /// This function:
  /// - Resets loading state and error messages before making an API call.
  /// - Retrieves the device's IP address and UDID.
  /// - Determines the device type (Android or iOS) and extracts the device name.
  /// - Constructs a request payload containing device details.
  /// - Sends the request using `ApiManager.post()`.
  /// - Parses the response and updates `requestId` and `visiterId` on success.
  /// - Displays an error message if the API request fails.
  getMyDeviceInfo(double height, double width, CyberSiaraModel cieraModel) async {
    isLoading(true);
    error("");
    apiError("");
    requestId("");
    visiterId("");
    removeToken();
    captchaOpenedAt = null;
    try {
      deviceName = "";
      deviceIp = await getPublicIp() ?? "";

      udid = await generateBrowserIdentity();

      deviceName = await getDeviceName();
      String deviceType = getDeviceType();
      String deviceBrowser = getBrowserName();
      print("deviceBrowser===>${deviceBrowser}");
      Map<String, dynamic> map = {
        "MasterUrlId": cieraModel.masterUrlId, // "VYz433DfqQ5LhBcgaamnbw4Wy4K9CyQT",
        "RequestUrl": cieraModel.requestUrl, // "com.app.cyber_ceiara",
        "BrowserIdentity": udid,
        "DeviceIp": deviceIp,
        "DeviceType": deviceType,
        "DeviceBrowser": deviceBrowser,
        "DeviceName": deviceName,
        "DeviceHeight": height.round(),
        "DeviceWidth": width.round(),
      };

      ResponseAPI responseAPI = await ApiManager.post(methodName: ApiConstant.getCyberSiaraForAndroid, params: map);
      Map<String, dynamic> valueMap = (responseAPI.response);
      if (valueMap["Message"] == "success") {
        GetInfoModel getInfoModel = GetInfoModel.fromJson(valueMap);
        startCaptchaTimer();
        requestId.value = getInfoModel.requestId;
        visiterId.value = getInfoModel.visiterId;
      } else {
        apiError(valueMap["Message"]);
        toast(apiError.value.toString());
      }
    } catch (err) {
      error(err.toString());
      toast(err.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Sends device verification data to the CyberCiera API.
  ///
  /// This function constructs a request payload with device-related information
  /// and sends it to the API endpoint (`verifiedSubmitForAndroid`) for verification.
  /// If the response is successful, it attempts to validate the received token.
  /// If validation succeeds, the `isVerified` flag is set to `true`; otherwise, it remains `false`.
  ///
  /// Parameters:
  /// - `context`: The current BuildContext (not used in this function but may be useful for UI-related actions).
  /// - `cieraModel`: An instance of `CyberCieraModel` containing API-related details.
  ///
  /// Function Workflow:
  /// 1. Resets `isVerified` and `isOtherLoading` state.
  /// 2. Clears previous error messages.
  /// 3. Constructs a request payload with device information, request ID, and visitor ID.
  /// 4. Sends an HTTP POST request via `ApiManager.post()`.
  /// 5. If API response is `"success"`, it validates the token:
  ///    - If validation succeeds, sets `isVerified` to `true`.
  ///    - If validation fails, logs an error and keeps `isVerified` as `false`.
  /// 6. If API response is `"fail"`, sets `isVerified` to `false`.
  /// 7. Handles API errors and unexpected exceptions, displaying appropriate error messages.
  /// 8. Resets `isOtherLoading` to `false` in the `finally` block.
  slideButton(CyberSiaraModel cieraModel) async {
    isVerified(false);
    isOtherLoading(true);
    error("");
    apiError("");
    String protocol = "http";
    if (kIsWeb) {
      final String currentUrl = Uri.base.toString();
      if (currentUrl.startsWith("https")) {
        protocol = "https";
      }
    }

    Map<String, dynamic> map = {
      "MasterUrl": cieraModel.masterUrlId,
      "BrowserIdentity": udid,
      "DeviceIp": deviceIp,
      "DeviceName": deviceName,
      "Protocol": protocol,
      "second": (timeSpentInSeconds <= 0 ? 1 : timeSpentInSeconds).toString(),
      "RequestID": requestId.value,
      "VisiterId": visiterId.value
    };
    try {
      ResponseAPI responseAPI = await ApiManager.post(methodName: ApiConstant.verifiedSubmitForAndroid, params: map);
      Map<String, dynamic> valueMap = responseAPI.response;
      if (valueMap["Message"] == "success") {
        bool success = await validateToken(valueMap["data"], cieraModel);
        if (success) {
          isVerified(true);
        } else {
          error("We cannot verify your key.");
          isVerified(false);
        }
      } else if (valueMap["Message"] == "fail") {
        isVerified(false);
      } else {
        apiError(valueMap["Message"]);
        toast(apiError.value.toString());
      }
    } catch (err) {
      apiError(err.toString());
    } finally {
      isOtherLoading(false);
    }
  }

  /// Validates the provided bearer token by making an API request.
  ///
  /// This function sends a `GET` request to the `validateToken` endpoint to verify
  /// whether the provided bearer token is valid. If the API response message is `"Verified"`,
  /// it returns `true`; otherwise, it returns `false`.
  ///
  /// Parameters:
  /// - `bearerToken`: The authentication token to be validated.
  /// - `cieraModel`: An instance of `CyberCieraModel` containing API credentials.
  ///
  /// Function Workflow:
  /// 1. Initializes `isSuccess` to `false`.
  /// 2. Calls `ApiManager.get()` with the `validateToken` endpoint, passing the `privateKey`
  ///    and `bearerToken` as parameters.
  /// 3. Parses the API response:
  ///    - If `"Message"` is `"Verified"`, sets `isSuccess` to `true`.
  /// 4. Catches and logs any errors encountered.
  /// 5. Returns `isSuccess` indicating whether validation was successful.
  ///
  /// Returns:
  /// - `true` if the token is verified.
  /// - `false` if verification fails or an error occurs.
  Future<bool> validateToken(String bearerToken, CyberSiaraModel cieraModel) async {
    bool isSuccess = false;
    try {
      ResponseAPI responseAPI =
          await ApiManager.get(methodName: ApiConstant.validateToken, privateKey: cieraModel.privateKey, bearerToken: bearerToken);
      Map<String, dynamic> valueMap = responseAPI.response;
      if (valueMap["Message"] == "Verified") {
        isSuccess = true;
      }
    } catch (err) {
      error(err.toString());
    }
    return isSuccess;
  }
}
