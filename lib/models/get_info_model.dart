class GetInfoModel {
  GetInfoModel({
    // required this.HttpStatusCode,
    // required this.Message,
    // required this.data,
    // this.Captcha,
    // required this.HtmlFormate,
    // this.SecurityLevel,
    required this.requestId,
    // required this.FpStatus,
    // this.VisiterLanguage,
    required this.visiterId,
  });
  // late final int HttpStatusCode;
  // late final String Message;
  // late final Data data;
  // late final Null Captcha;
  // late final String HtmlFormate;
  // late final Null SecurityLevel;
  late final String requestId;
  // late final String FpStatus;
  // late final Null VisiterLanguage;
  late final String visiterId;

  GetInfoModel.fromJson(Map<String, dynamic> json) {
    // HttpStatusCode = json['HttpStatusCode'];
    // Message = json['Message'];
    // data = Data.fromJson(json['data']);
    // Captcha = null;
    // HtmlFormate = json['HtmlFormate'];
    // SecurityLevel = null;
    requestId = json['RequestId'];
    // FpStatus = json['FpStatus'];
    // VisiterLanguage = null;
    visiterId = json['Visiter_Id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // _data['HttpStatusCode'] = HttpStatusCode;
    // _data['Message'] = Message;
    // _data['data'] = data.toJson();
    // _data['Captcha'] = Captcha;
    // _data['HtmlFormate'] = HtmlFormate;
    // _data['SecurityLevel'] = SecurityLevel;
    data['RequestId'] = requestId;
    // _data['FpStatus'] = FpStatus;
    // _data['VisiterLanguage'] = VisiterLanguage;
    data['Visiter_Id'] = visiterId;
    return data;
  }
}

class Data {
  Data();

  Data.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    return data;
  }
}
