import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockPortalUseCases portal;
  setUp(() => portal = MockPortalUseCases());

  blocTest<PlosCubit, PlosState>(
    'success exposes the list',
    build: () {
      when(
        () => portal.plos(portalContext),
      ).thenAnswer((_) async => plosSample());
      return PlosCubit(portal, portalContext);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const PlosState(),
      PlosState(isLoading: false, items: plosSample()),
    ],
  );

  blocTest<PlosCubit, PlosState>(
    'an empty program yields an empty, non-error state',
    build: () {
      when(() => portal.plos(portalContext)).thenAnswer((_) async => []);
      return PlosCubit(portal, portalContext);
    },
    act: (cubit) => cubit.load(),
    expect: () => [const PlosState(), const PlosState(isLoading: false)],
  );

  blocTest<PlosCubit, PlosState>(
    'failure carries the thrown message',
    build: () {
      when(() => portal.plos(portalContext)).thenThrow(
        const ApiException(statusCode: 500, code: 'HTTP', message: 'Lỗi PLO'),
      );
      return PlosCubit(portal, portalContext);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const PlosState(),
      const PlosState(isLoading: false, errorMessage: 'Lỗi PLO'),
    ],
  );
}
