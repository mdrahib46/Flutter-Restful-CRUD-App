class NetworkResponse {
  bool isSuccess;
  int statusCode;
  dynamic responseData;
  String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = "Something went wrong",
  });
}
