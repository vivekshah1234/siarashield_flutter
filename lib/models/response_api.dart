/// A model class to represent API responses in a structured format.
class ResponseAPI {
  /// The HTTP status code of the API response.
  int code;

  /// The response body returned from the API, stored as a map.
  final Map<String, dynamic> response;

  /// A flag indicating whether the response contains an error.
  bool? isError;

  /// A flag to indicate if the error is due to cached data (optional).
  dynamic isCacheError;

  /// The actual error details, if any.
  dynamic error;

  /// Constructor to initialize the API response.
  ///
  /// - [code]: HTTP status code.
  /// - [response]: The actual response data from the API.
  /// - [isError]: Optional flag to indicate if the response contains an error.
  /// - [isCacheError]: Optional flag to indicate if the error is due to cache issues.
  /// - [error]: Optional field to store error details.
  ResponseAPI(this.code, this.response, {this.isError, this.isCacheError, this.error});
}
