import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../common/common_widgets.dart';
import '../models/responseapi.dart';
import 'app_constant.dart';

postAPI({required String methodName,  required Map<String, dynamic> param, required Function(ResponseAPI) callback}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    String url = ApiConstant.baseUrl + methodName;
    Uri uri = Uri.parse(url);
    log("==request== $uri");
    log("==params== $param");
    // log("==token== ${AppConstants.authToken}");
    await http.post(uri, headers: {"Content-Type": "application/json"}, body: json.encode(param)).then((value) {
      _handleResponse(value, callback);
    }).onError((error, stackTrace) {
      log("onError== $error");
      throw _handleError(error, callback);
    }).catchError((error) {
      log("catchError== $error");
      _handleError(error, callback);
    });
  } else {
    toast("No Internet");
    callback.call(ResponseAPI(
      0,
      "No Internet",
      isError: true,
    ));
  }
}

_handleResponse(http.Response value, Function(ResponseAPI) callback) {
  var logger = Logger(
    level: Level.info,
    printer: PrettyPrinter(methodCount: 0, noBoxingByDefault: false),
  );
  logger.i("==response== ${value.body}");
  callback.call(ResponseAPI(value.statusCode, value.body));
}

_handleError(value, Function(ResponseAPI) callback) {
  var logger = Logger(
    level: Level.error,
  );
  logger.e("error:::::::::::::: ${value.body}");
  callback.call(ResponseAPI(
    0,
    "Something went wrong",
    isError: true,
    error: value,
  ));
}



multipartPostAPIForWeb({
  required String methodName,
  required Map<String, String> param,
  required Function(ResponseAPI) callback,
  ADDPhoto? picture,
}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    var url = ApiConstant.baseUrl + methodName;
    var uri = Uri.parse(url);
    log("==request== $uri");
    log("==Params== $param");
    final imageUploadRequest = http.MultipartRequest('POST', uri);
    List<http.MultipartFile> files = [];
    if (picture != null) {
      log("==picture== $picture");

      http.MultipartFile file1 = http.MultipartFile.fromBytes(picture.fieldName, picture.photo.cast(), filename: picture.fileName);
      files.add(file1);

      imageUploadRequest.files.addAll(files);
    }

    imageUploadRequest.fields.addAll(param);

    // imageUploadRequest.headers.addAll(getHeaders());
    try {
      final streamedResponse = await imageUploadRequest.send();
      await http.Response.fromStream(streamedResponse).then((value) {
        _handleResponse(value, callback);
      }).onError((error, stackTrace) {
        _handleError(error, callback);
      }).catchError((error) {
        log("catchError== $error");
        _handleError(error, callback);
      });
    } catch (e) {
      _handleError(e, callback);
    }
  } else {
    callback.call(ResponseAPI(
      0,
      "No Internet",
      isError: true,
    ));
  }
}

multipartPostAPIForWeb2({
  required String methodName,
  required Map<String, String> param,
  required Function(ResponseAPI) callback,
  required List<ADDPhoto> picture,
}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    var url = ApiConstant.baseUrl + methodName;
    var uri = Uri.parse(url);
    log("==request== $uri");
    log("==Params== $param");
    final imageUploadRequest = http.MultipartRequest('POST', uri);
    List<http.MultipartFile> files = [];
    if (picture.isNotEmpty) {
      log("==picture== $picture");
      for (int i = 0; i < picture.length; i++) {
        http.MultipartFile file1 = http.MultipartFile.fromBytes(
          picture[i].fieldName,
          picture[i].photo.cast(),
          filename: picture[i].fileName,
        );
        files.add(file1);
      }
      imageUploadRequest.files.addAll(files);
    }

    imageUploadRequest.fields.addAll(param);

    // imageUploadRequest.headers.addAll(getHeaders());
    try {
      final streamedResponse = await imageUploadRequest.send();
      await http.Response.fromStream(streamedResponse).then((value) {
        _handleResponse(value, callback);
      }).onError((error, stackTrace) {
        _handleError(error, callback);
      }).catchError((error) {
        log("catchError== $error");
        _handleError(error, callback);
      });
    } catch (e) {
      _handleError(e, callback);
    }
  } else {
    callback.call(ResponseAPI(
      0,
      "No Internet",
      isError: true,
    ));
  }
}

class ADDPhoto {
  late final String fieldName;
  late final String fileName;
  late final Uint8List photo;
  late final TextEditingController? purityText;
  late final TextEditingController? weightText;

  ADDPhoto({required this.fieldName, required this.photo, required this.fileName, this.purityText, this.weightText});
}