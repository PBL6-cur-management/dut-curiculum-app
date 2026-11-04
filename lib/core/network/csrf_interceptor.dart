import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'api_config.dart';

@injectable
class CsrfInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConfig.csrfHeader] = ApiConfig.csrfValue;
    handler.next(options);
  }
}
