import 'package:flutter_test/flutter_test.dart';
import 'package:dut_curriculum_app/core/network/contract_exception.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/graduation_context_validator.dart';

import '../../../support/test_doubles.dart';

void main() {
  Map<String, dynamic> matching() => {
    'studentId': portalContext.studentId,
    'programId': portalContext.programId,
    'semesterId': portalContext.semesterId,
  };

  test('exact requested IDs are accepted', () {
    expect(
      () => validateGraduationContext(matching(), portalContext),
      returnsNormally,
    );
  });
  for (final key in ['studentId', 'programId', 'semesterId']) {
    for (final value in [null, 7, 'another']) {
      test('$key rejects $value', () {
        final returned = matching()..[key] = value;
        expect(
          () => validateGraduationContext(returned, portalContext),
          throwsA(isA<ContractException>()),
        );
      });
    }
    test('$key is mandatory', () {
      final returned = matching()..remove(key);
      expect(
        () => validateGraduationContext(returned, portalContext),
        throwsA(isA<ContractException>()),
      );
    });
  }
  for (final malformed in [null, 'context', <Object>[], 42]) {
    test('malformed context $malformed is rejected', () {
      expect(
        () => validateGraduationContext(malformed, portalContext),
        throwsA(isA<ContractException>()),
      );
    });
  }
}
