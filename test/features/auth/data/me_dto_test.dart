import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dut_curriculum_app/features/auth/data/remote/dto/me_dto.dart';

import '../../../support/fixtures.dart';

void main() {
  test(
    'maps roles, null email and forced password flag into immutable domain',
    () {
      final user = MeDto.fromJson(objectFixture('auth_me')).toDomain();
      expect(user.username, 'synthetic');
      expect(user.email, isNull);
      expect(user.mustChangePassword, isTrue);
      expect(user.roleNames, ['STUDENT']);
      expect(
        user.copyWith(mustChangePassword: false).mustChangePassword,
        isFalse,
      );
      expect(user.mustChangePassword, isTrue);
      expect(() => user.roleNames.add('ADMIN'), throwsUnsupportedError);
    },
  );

  test('rejects wrong wire types rather than inventing a user', () {
    final json = objectFixture('auth_me')..['mustChangePassword'] = 'true';
    expect(
      () => MeDto.fromJson(json),
      throwsA(isA<CheckedFromJsonException>()),
    );
  });
}
