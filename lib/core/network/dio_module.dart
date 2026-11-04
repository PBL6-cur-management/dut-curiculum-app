import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'api_config.dart';
import 'csrf_interceptor.dart';
import 'session_expiry_interceptor.dart';

@module
abstract class NetworkModule {
  @preResolve
  @singleton
  Future<PersistCookieJar> cookieJar() async {
    final directory = await getApplicationSupportDirectory();
    return PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage('${directory.path}/${ApiConfig.cookieDirectory}'),
    );
  }

  @singleton
  Dio dio(
    PersistCookieJar jar,
    CsrfInterceptor csrf,
    SessionExpiryInterceptor expiry,
  ) => Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl.replaceFirst(RegExp(r'/+$'), ''),
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
    ),
  )..interceptors.addAll([CookieManager(jar), csrf, expiry]);
}
