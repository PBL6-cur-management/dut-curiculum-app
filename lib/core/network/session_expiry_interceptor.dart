import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../session/session_events.dart';
import 'api_config.dart';
import 'api_paths.dart';

@injectable
class SessionExpiryInterceptor extends Interceptor {
  SessionExpiryInterceptor(this._events);

  final SessionEvents _events;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == ApiConfig.unauthorizedStatus &&
        err.requestOptions.path != ApiPaths.login) {
      _events.notifyExpired();
    }
    handler.next(err);
  }
}
