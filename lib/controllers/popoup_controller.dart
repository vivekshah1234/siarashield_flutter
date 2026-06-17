// import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:siarashield_flutter/constants/app_constant.dart';
import 'package:siarashield_flutter/constants/dio_service.dart';

import '../common/custom_widgets.dart';
import '../models/response_api.dart';
import '../services/generate_random_id.dart';
import '../services/get_device_infomation.dart';
import '../services/get_ip_address.dart';
import '../siarashield_flutter.dart';

class PopupController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isOtherLoading = false.obs;
  RxString error = "".obs;

  String deviceName = "";
  String deviceType = "";
  String deviceIp = "";
  String udid = "";
  RxBool isVerified = false.obs;
  RxString captchaUrl = "".obs;

  /// Fetches a CAPTCHA challenge for user verification.
  ///
  /// This function sends a `POST` request to the `captchaForAndroid` endpoint
  /// with device and user session details. It retrieves a CAPTCHA URL in HTML format
  /// if the request is successful.
  ///
  /// Parameters:
  /// - `height`: The device screen height (used for UI adjustments).
  /// - `width`: The device screen width (used for UI adjustments).
  /// - `visiterId`: A unique identifier for the user session.
  /// - `cieraModel`: An instance of `CyberCieraModel` containing API-related configurations.
  ///
  /// Function Workflow:
  /// 1. Sets `isOtherLoading` to `true` to indicate a loading state.
  /// 2. Clears previous error messages and CAPTCHA URLs.
  /// 3. Fetches the device's IP and unique ID (`udid`).
  /// 4. Detects the device type (`Android` or `iOS`) and extracts the device name.
  /// 5. Constructs a request payload containing:
  ///    - Master URL ID
  ///    - Request URL
  ///    - Browser Identity (`udid`)
  ///    - Device IP and details
  ///    - Screen dimensions
  ///    - User session (`VisiterId`)
  /// 6. Sends the request using `ApiManager.post()`.
  /// 7. Parses the response:
  ///    - If successful (`Message == "success"`), updates `captchaUrl` with the received HTML.
  ///    - Otherwise, displays an API error message.
  /// 8. Catches and logs any errors encountered.
  /// 9. Finally, sets `isOtherLoading` to `false` to stop the loading state.
  ///
  /// Returns:
  /// - Updates the `captchaUrl` observable with the CAPTCHA HTML.
  /// - Displays an error toast in case of failure.
  getCaptcha(
      {required double height,
      required double width,
      required String visiterId,
      required String requestId,
      required CyberSiaraModel cieraModel}) async {
    isOtherLoading(true);
    error("");
    captchaUrl("");
    try {
      deviceIp = await getPublicIp() ?? "";
      udid = await generateBrowserIdentity();
      deviceName = await getDeviceName();
      deviceType = getDeviceType();
      Map<String, dynamic> map = {
        "MasterUrlId": cieraModel.masterUrlId, // "VYz433DfqQ5LhBcgaamnbw4Wy4K9CyQT",
        "RequestUrl": cieraModel.requestUrl, // "com.app.cyber_ceiara",

        "BrowserIdentity": udid,

        "DeviceType": deviceType,

        "DeviceName": deviceName,
        "DeviceHeight": height.round(),
        "DeviceWidth": width.round(),
        "RequestID": requestId,
        "VisiterId": visiterId,
        "RequestType": "Open",
        "PluginNo": 0,
        "LanguageId": 1,
        "LangChange": 0,
        "ClickSecond": 1,
        "Iscookie": 1,

        // "DeviceIp": deviceIp,
        // "DeviceBrowser": 'Chrome',
      };
      ResponseAPI responseAPI = await ApiManager.post(methodName: ApiConstant.captchaForAndroid, params: map);
      Map<String, dynamic> valueMap = responseAPI.response;
      if (valueMap["Message"] == "success") {
        captchaUrl(valueMap["HtmlFormate"]);
      } else {
        toast("Api Error");
      }
    } catch (err) {
      error(err.toString());
      toast(error.value);
    } finally {
      isOtherLoading(false);
    }
  }

  /// Submits the CAPTCHA response for verification.
  ///
  /// This function sends a `POST` request to the `submitCaptchInfoForAndroid` endpoint,
  /// verifying the user-provided CAPTCHA code along with device and session details.
  /// If the CAPTCHA is successfully validated, the function further validates a token
  /// using `validateToken()`.
  ///
  /// Parameters:
  /// - `txt`: The user-entered CAPTCHA text.
  /// - `requestId`: A unique identifier for the request.
  /// - `visiterId`: A unique identifier for the visitor session.
  /// - `cieraModel`: An instance of `CyberCieraModel` containing API-related configurations.
  ///
  /// Function Workflow:
  /// 1. Sets `isLoading` to `true` to indicate processing.
  /// 2. Clears previous error messages.
  /// 3. Constructs a request payload containing:
  ///    - Master URL
  ///    - Device details (IP, type, name)
  ///    - Browser identity (`udid`)
  ///    - CAPTCHA input (`UserCaptcha`)
  ///    - Additional metadata (`ByPass`, `Timespent`, `Flag`, etc.)
  ///    - User session (`VisiterId`, `RequestID`)
  /// 4. Sends the request using `ApiManager.post()`.
  /// 5. Parses the response:
  ///    - If successful (`Message == "success"`), validates the token via `validateToken()`.
  ///      - If token validation succeeds, returns `true`.
  ///      - If token validation fails, sets an error message.
  ///    - If the CAPTCHA is incorrect, sets an error message.
  /// 6. Catches and logs any errors encountered.
  /// 7. Finally, sets `isLoading` to `false`.
  ///
  /// Returns:
  /// - `true` if CAPTCHA validation and token verification succeed.
  /// - `false` otherwise.
  Future<bool> submitCaptcha({required String txt, required String requestId, required String visiterId, required CyberSiaraModel cieraModel}) async {
    isLoading(true);
    error("");
    bool isSuccess = false;
    try {
      Map<String, dynamic> map = {
        "MasterUrl": cieraModel.masterUrlId,
        "DeviceIp": deviceIp,
        "DeviceType": deviceType,
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
      ResponseAPI responseAPI = await ApiManager.post(methodName: ApiConstant.submitCaptchInfoForAndroid, params: map);
      Map<String, dynamic> valueMap = (responseAPI.response);
      if (valueMap["Message"] == "success") {
        bool success = await validateToken(valueMap["data"], cieraModel);
        if (success) {
          isSuccess = success;
        } else {
          error("We cannot verify your private key.");
        }
      } else {
        error("You have enter wrong code");
      }
    } catch (err) {
      error(err.toString());
    } finally {
      isLoading(false);
    }
    return isSuccess;
  }

  /// Validates the authentication token received from the API.
  ///
  /// This function sends a `GET` request to the `validateToken` endpoint with the provided
  /// `bearerToken` and the `privateKey` from `cieraModel`. If the response message is `"Verified"`,
  /// the function returns `true`, indicating a successful token validation.
  ///
  /// Parameters:
  /// - `bearerToken`: The authentication token to be validated.
  /// - `cieraModel`: An instance of `CyberCieraModel` containing API-related configurations.
  ///
  /// Function Workflow:
  /// 1. Initializes `isSuccess` as `false`.
  /// 2. Calls `ApiManager.get()` with the required method name, `privateKey`, and `bearerToken`.
  /// 3. Parses the response:
  ///    - If the `Message` field in the response is `"Verified"`, sets `isSuccess = true`.
  /// 4. Catches and logs any errors encountered.
  /// 5. Returns `true` if the token is valid, otherwise `false`.
  ///
  /// Returns:
  /// - `true` if the token is successfully validated.
  /// - `false` in case of failure or an error.
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
