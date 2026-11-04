abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment('API_BASE_URL');
  static const csrfHeader = 'x-requested-with';
  static const csrfValue = 'XMLHttpRequest';
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);
  static const sessionRestoreTimeout = Duration(seconds: 5);
  static const resultsPageSize = 50;
  static const cookieDirectory = 'cookies';
  static const unauthorizedStatus = 401;
  static const sessionRequiredCode = 'SESSION_REQUIRED';
  static const passwordChangeRequiredCode = 'PASSWORD_CHANGE_REQUIRED';
  static const networkErrorCode = 'NETWORK';
  static const httpErrorCode = 'HTTP';
}
