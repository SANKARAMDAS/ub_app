class CustomError {
  late bool error;
  late String errorMessage;

  CustomError({
    required this.error,
    required this.errorMessage,
  });

  CustomError.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorMessage = json['errorMessage'];
  }
}
