class ResponseAPI {
  int code;
  String response;
  bool? isError;
  dynamic isCacheError;
  Error? error;

  ResponseAPI(this.code, this.response, {this.isError, this.isCacheError, this.error});
}
