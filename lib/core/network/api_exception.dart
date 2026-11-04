import 'package:dio/dio.dart';

import 'api_config.dart';

class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
  });

  factory ApiException.fromDio(
    DioException error, {
    required String networkMessage,
  }) {
    final response = error.response;
    final body = response?.data;
    final message = body is Map ? body['message'] : null;
    final code = body is Map ? body['code'] : null;
    return ApiException(
      statusCode: response?.statusCode,
      code: code is String
          ? code
          : response == null
          ? ApiConfig.networkErrorCode
          : ApiConfig.httpErrorCode,
      message: message is String
          ? message
          : message is List
          ? message.join('\n')
          : response == null
          ? networkMessage
          : error.message ?? error.toString(),
    );
  }

  final int? statusCode;
  final String code;
  final String message;

  bool get isSessionRequired =>
      statusCode == ApiConfig.unauthorizedStatus &&
      code == ApiConfig.sessionRequiredCode;

  bool get isPasswordChangeRequired =>
      code == ApiConfig.passwordChangeRequiredCode;

  @override
  String toString() => message;
}
