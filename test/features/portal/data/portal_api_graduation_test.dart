import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dut_curriculum_app/core/network/contract_exception.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/attachment_cache.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/portal_api.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_outcome.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_context.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../support/test_doubles.dart';
import '../../../support/fixtures.dart';
import '../../../support/stub_http_adapter.dart';

void main() {
  late AppLocalizations strings;
  late Dio dio;
  late Map<String, dynamic> payload;
  late PortalApi api;
  setUpAll(() async {
    strings = await AppLocalizations.delegate.load(const Locale('vi'));
  });
  setUp(() {
    payload = objectFixture('graduation');
    final result = payload['result'] as Map<String, dynamic>;
    (result['context'] as Map<String, dynamic>).addAll({
      'studentId': portalContext.studentId,
      'programId': portalContext.programId,
      'semesterId': portalContext.semesterId,
    });
    dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
    dio.httpClientAdapter = StubHttpAdapter(
      (_) => ResponseBody.fromString(
        jsonEncode(payload),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      ),
    );
    api = PortalApi(dio, strings, AttachmentCache());
  });
  tearDown(() => dio.close(force: true));
  test('matching response reaches the real reviewed API boundary', () async {
    expect(await api.graduation(portalContext), isA<GraduationReviewed>());
  });
  for (final key in ['studentId', 'programId', 'semesterId']) {
    for (final value in [null, 8, 'wrong']) {
      test(
        'API rejects $key=$value without leaking received identifiers',
        () async {
          ((payload['result'] as Map<String, dynamic>)['context']
                  as Map<String, dynamic>)[key] =
              value;
          await expectLater(
            api.graduation(portalContext),
            throwsA(
              isA<ContractException>().having(
                (error) => error.message,
                'safe message',
                isNot(contains('wrong')),
              ),
            ),
          );
        },
      );
    }
    test('API rejects missing $key', () async {
      ((payload['result'] as Map<String, dynamic>)['context']
              as Map<String, dynamic>)
          .remove(key);
      await expectLater(
        api.graduation(portalContext),
        throwsA(isA<ContractException>()),
      );
    });
  }
  for (final malformed in [null, 'malformed-context', <Object>[], 42]) {
    test('reviewed API rejects malformed context $malformed', () async {
      (payload['result'] as Map<String, dynamic>)['context'] = malformed;
      await expectLater(
        api.graduation(portalContext),
        throwsA(isA<ContractException>()),
      );
    });
  }
  test('reviewed API requires a context object', () async {
    (payload['result'] as Map<String, dynamic>).remove('context');
    await expectLater(
      api.graduation(portalContext),
      throwsA(isA<ContractException>()),
    );
  });
  test('two distinct request keys cannot accept the same payload', () async {
    final requests = [
      PortalContext(
        studentId: 'other-student',
        programId: portalContext.programId,
        semesterId: portalContext.semesterId,
      ),
      PortalContext(
        studentId: portalContext.studentId,
        programId: 'other-program',
        semesterId: 'other-semester',
      ),
    ];
    await Future.wait([
      for (final request in requests)
        expectLater(api.graduation(request), throwsA(isA<ContractException>())),
    ]);
  });
  test(
    'unsupported schema remains unsupported before context validation',
    () async {
      (payload['result'] as Map<String, dynamic>)['schemaVersion'] = 99;
      (payload['result'] as Map<String, dynamic>)['context'] = null;
      expect(await api.graduation(portalContext), isA<GraduationUnsupported>());
    },
  );
  test('diagnostic outcome needs no reviewed context', () async {
    payload = {
      'status': 'CANNOT_AUDIT',
      'result': null,
      'error': {'code': 'SYN_DIAGNOSTIC', 'message': 'Chưa thể đánh giá'},
    };
    expect(await api.graduation(portalContext), isA<GraduationCannotAudit>());
  });
}
