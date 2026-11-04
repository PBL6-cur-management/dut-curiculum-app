import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/features/auth/data/auth_repository_impl.dart';
import 'package:dut_curriculum_app/features/auth/data/remote/auth_api.dart';

class _MockAuthApi extends Mock implements AuthApi {}

class _MockCookieJar extends Mock implements PersistCookieJar {}

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  test('no saved cookie means signed out without asking the server', () async {
    final api = _MockAuthApi();
    final jar = _MockCookieJar();
    when(() => jar.loadForRequest(any())).thenAnswer((_) async => <Cookie>[]);

    final user = await AuthRepositoryImpl(api, jar).currentUser();

    expect(user, isNull);
    verifyNever(() => api.currentUser());
  });
}
