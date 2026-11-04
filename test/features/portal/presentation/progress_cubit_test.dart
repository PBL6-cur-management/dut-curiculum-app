import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/academic_result.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_outcome.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/result_page.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_state.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockPortalUseCases portal;
  late AppLocalizations strings;
  late GraduationOutcome reviewed;
  late AcademicResult first;

  setUpAll(() async {
    strings = await loadStrings();
    reviewed = graduationSample(strings);
    first = resultsSample().items.single;
  });
  setUp(() => portal = MockPortalUseCases());

  AcademicResult resultNamed(String id) => AcademicResult(
    id: id,
    course: first.course,
    semester: first.semester,
    score10: first.score10,
    score4: first.score4,
    letterGrade: first.letterGrade,
    status: first.status,
  );

  ResultPage page(int number, List<String> ids, {int total = 3}) => ResultPage(
    items: [for (final id in ids) resultNamed(id)],
    total: total,
    page: number,
    pageSize: 2,
  );

  void stubGraduation(GraduationOutcome outcome) => when(
    () => portal.graduation(portalContext),
  ).thenAnswer((_) async => outcome);

  test(
    'reviewed outcome sets the progress fraction to recognised/required',
    () async {
      stubGraduation(reviewed);
      when(
        () => portal.results(portalContext, page: 1),
      ).thenAnswer((_) async => page(1, ['r1', 'r2']));
      final cubit = ProgressCubit(portal, portalContext);
      await cubit.load();
      expect(cubit.state.fraction, closeTo(3 / 120, 1e-9));
      expect(cubit.state.graduation, reviewed);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNull);
      await cubit.close();
    },
  );

  test('a diagnostic outcome shows no progress and no error', () async {
    stubGraduation(const GraduationCannotAudit('Thiếu cấu hình khoa'));
    when(
      () => portal.results(portalContext, page: 1),
    ).thenAnswer((_) async => page(1, ['r1'], total: 1));
    final cubit = ProgressCubit(portal, portalContext);
    await cubit.load();
    expect(
      cubit.state.graduation,
      const GraduationCannotAudit('Thiếu cấu hình khoa'),
    );
    expect(cubit.state.fraction, 0);
    expect(cubit.state.errorMessage, isNull);
    await cubit.close();
  });

  test('a graduation failure does not hide the results list', () async {
    when(() => portal.graduation(portalContext)).thenThrow(
      const ApiException(
        statusCode: 500,
        code: 'HTTP',
        message: 'Lỗi xét tốt nghiệp',
      ),
    );
    when(
      () => portal.results(portalContext, page: 1),
    ).thenAnswer((_) async => page(1, ['r1'], total: 1));
    final cubit = ProgressCubit(portal, portalContext);
    await cubit.load();
    expect(cubit.state.graduationError, 'Lỗi xét tốt nghiệp');
    expect(cubit.state.results.map((r) => r.id), ['r1']);
    expect(cubit.state.errorMessage, 'Lỗi xét tốt nghiệp');
    await cubit.close();
  });

  test('a results failure does not hide the graduation outcome', () async {
    stubGraduation(reviewed);
    when(() => portal.results(portalContext, page: 1)).thenThrow(
      const ApiException(statusCode: 500, code: 'HTTP', message: 'Lỗi kết quả'),
    );
    final cubit = ProgressCubit(portal, portalContext);
    await cubit.load();
    expect(cubit.state.graduation, reviewed);
    expect(cubit.state.resultsError, 'Lỗi kết quả');
    expect(cubit.state.results, isEmpty);
    await cubit.close();
  });

  test('both failures are reported together', () async {
    when(() => portal.graduation(portalContext)).thenThrow(
      const ApiException(statusCode: 500, code: 'HTTP', message: 'Lỗi A'),
    );
    when(() => portal.results(portalContext, page: 1)).thenThrow(
      const ApiException(statusCode: 500, code: 'HTTP', message: 'Lỗi B'),
    );
    final cubit = ProgressCubit(portal, portalContext);
    await cubit.load();
    expect(cubit.state.errorMessage, 'Lỗi A\nLỗi B');
    await cubit.close();
  });

  group('paging', () {
    ProgressCubit loadedFirstPage() {
      stubGraduation(reviewed);
      when(
        () => portal.results(portalContext, page: 1),
      ).thenAnswer((_) async => page(1, ['r1', 'r2']));
      return ProgressCubit(portal, portalContext);
    }

    test('loadMore appends the next page until everything is loaded', () async {
      final cubit = loadedFirstPage();
      when(
        () => portal.results(portalContext, page: 2),
      ).thenAnswer((_) async => page(2, ['r3']));
      await cubit.load();
      expect(cubit.state.hasMore, isTrue);
      await cubit.loadMore();
      expect(cubit.state.results.map((r) => r.id), ['r1', 'r2', 'r3']);
      expect(cubit.state.hasMore, isFalse);
      expect(cubit.state.isLoadingMore, isFalse);
      await cubit.loadMore();
      verifyNever(() => portal.results(portalContext, page: 3));
      await cubit.close();
    });

    test('a failed page keeps loaded rows and allows a retry', () async {
      final cubit = loadedFirstPage();
      var attempts = 0;
      when(() => portal.results(portalContext, page: 2)).thenAnswer((_) async {
        if (attempts++ == 0) {
          throw const ApiException(
            statusCode: 500,
            code: 'HTTP',
            message: 'Trang lỗi',
          );
        }
        return page(2, ['r3']);
      });
      await cubit.load();
      await cubit.loadMore();
      expect(cubit.state.resultsError, 'Trang lỗi');
      expect(cubit.state.results, hasLength(2));
      expect(cubit.state.isLoadingMore, isFalse);
      await cubit.loadMore();
      expect(cubit.state.results, hasLength(3));
      expect(cubit.state.resultsError, isNull);
      await cubit.close();
    });

    test(
      'a page that echoes the wrong page number is a contract error',
      () async {
        final cubit = loadedFirstPage();
        when(
          () => portal.results(portalContext, page: 2),
        ).thenAnswer((_) async => page(1, ['r3']));
        await cubit.load();
        await cubit.loadMore();
        expect(cubit.state.resultsError, isNotNull);
        expect(cubit.state.results, hasLength(2));
        await cubit.close();
      },
    );

    test(
      'an empty page while rows are still missing cannot loop forever',
      () async {
        final cubit = loadedFirstPage();
        when(
          () => portal.results(portalContext, page: 2),
        ).thenAnswer((_) async => page(2, []));
        await cubit.load();
        await cubit.loadMore();
        expect(cubit.state.resultsError, isNotNull);
        expect(cubit.state.nextPage, 2);
        await cubit.close();
      },
    );
  });

  blocTest<ProgressCubit, ProgressState>(
    'loadMore does nothing before the first page has loaded',
    build: () => ProgressCubit(portal, portalContext),
    act: (cubit) => cubit.loadMore(),
    expect: () => <ProgressState>[],
  );
}
