import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dut_curriculum_app/core/network/api_config.dart';
import 'package:dut_curriculum_app/core/network/api_paths.dart';
import 'package:dut_curriculum_app/core/network/csrf_interceptor.dart';
import 'package:dut_curriculum_app/core/network/session_expiry_interceptor.dart';
import 'package:dut_curriculum_app/core/session/session_events.dart';

import '../../support/stub_http_adapter.dart';

void main() {
  const root = 'https://synthetic.example';
  late SessionEvents events;
  late StubHttpAdapter adapter;
  late Dio dio;
  late int expiredCount;
  late StreamSubscription<void> subscription;

  ResponseBody json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  setUp(() {
    events = SessionEvents();
    expiredCount = 0;
    subscription = events.expired.listen((_) => expiredCount++);
    adapter = StubHttpAdapter(
      (options) => options.path == ApiPaths.me
          ? json(200, {'ok': true})
          : json(401, {'code': 'SESSION_REQUIRED', 'message': 'Hết phiên'}),
    );
    dio = Dio(BaseOptions(baseUrl: '$root/api'))
      ..httpClientAdapter = adapter
      ..interceptors.addAll([
        CsrfInterceptor(),
        SessionExpiryInterceptor(events),
      ]);
  });

  tearDown(() async {
    await subscription.cancel();
    await events.dispose();
  });

  test('every request carries the CSRF header the backend requires', () async {
    await dio.get<Object?>(ApiPaths.me);
    expect(
      adapter.requests.single.headers[ApiConfig.csrfHeader],
      ApiConfig.csrfValue,
    );
  });

  test('base URL path and API path compose to <root>/api/auth/login', () async {
    await expectLater(
      dio.post<Object?>(ApiPaths.login),
      throwsA(isA<DioException>()),
    );
    expect(adapter.requests.single.uri.toString(), '$root/api/auth/login');
  });

  test('401 on a protected path announces session expiry', () async {
    await expectLater(
      dio.get<Object?>(ApiPaths.portalMe),
      throwsA(isA<DioException>()),
    );
    await Future<void>.delayed(Duration.zero);
    expect(expiredCount, 1);
  });

  test('401 on login is wrong credentials, not expiry', () async {
    await expectLater(
      dio.post<Object?>(ApiPaths.login),
      throwsA(isA<DioException>()),
    );
    await Future<void>.delayed(Duration.zero);
    expect(expiredCount, 0);
  });

  test('non-401 failures do not announce expiry and still propagate', () async {
    adapter = StubHttpAdapter(
      (_) => json(500, {'code': 'BOOM', 'message': 'Lỗi máy chủ'}),
    );
    dio.httpClientAdapter = adapter;
    await expectLater(
      dio.get<Object?>(ApiPaths.portalMe),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          500,
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(expiredCount, 0);
  });
}
