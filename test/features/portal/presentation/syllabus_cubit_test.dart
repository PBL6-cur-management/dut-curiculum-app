import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/core/network/contract_exception.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/material_kind.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/syllabus_attachment.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

const itemId = 'item-1';

void main() {
  late MockPortalUseCases portal;
  late MockAttachmentViewer viewer;
  final syllabus = syllabusSample();
  final attachment = syllabus.attachments.single;

  setUp(() {
    portal = MockPortalUseCases();
    viewer = MockAttachmentViewer();
  });

  SyllabusCubit build() => SyllabusCubit(portal, viewer, portalContext, itemId);

  void stubDownload(
    Future<String> Function(void Function(int, int)? onProgress) body,
  ) {
    when(
      () => portal.downloadAttachment(
        portalContext,
        itemId,
        attachment,
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (invocation) => body(
        invocation.namedArguments[#onProgress] as void Function(int, int)?,
      ),
    );
  }

  SyllabusState loaded({String? opening, double? progress, String? error}) =>
      SyllabusState(
        isLoading: false,
        data: syllabus,
        openingAttachmentId: opening,
        downloadProgress: progress,
        errorMessage: error,
      );

  group('load', () {
    blocTest<SyllabusCubit, SyllabusState>(
      'success exposes the syllabus',
      build: () {
        when(
          () => portal.syllabus(portalContext, itemId),
        ).thenAnswer((_) async => syllabus);
        return build();
      },
      act: (cubit) => cubit.load(),
      expect: () => [const SyllabusState(), loaded()],
    );

    blocTest<SyllabusCubit, SyllabusState>(
      'a not-issued syllabus shows the server message',
      build: () {
        when(() => portal.syllabus(portalContext, itemId)).thenThrow(
          const ApiException(
            statusCode: 404,
            code: 'PORTAL_SYLLABUS_NOT_ISSUED',
            message: 'Đề cương chưa được ban hành.',
          ),
        );
        return build();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const SyllabusState(),
        const SyllabusState(
          isLoading: false,
          errorMessage: 'Đề cương chưa được ban hành.',
        ),
      ],
    );
  });

  group('openAttachment', () {
    blocTest<SyllabusCubit, SyllabusState>(
      'downloads, reports progress, opens the file and returns to idle',
      build: () {
        stubDownload((onProgress) async {
          onProgress!(512, 1024);
          return '/cache/a.pdf';
        });
        when(() => viewer.open('/cache/a.pdf')).thenAnswer((_) async {});
        return build();
      },
      seed: () => loaded(),
      act: (cubit) => cubit.openAttachment(attachment),
      expect: () => [
        loaded(opening: attachment.id),
        loaded(opening: attachment.id, progress: 0.5),
        loaded(),
      ],
      verify: (_) => verify(() => viewer.open('/cache/a.pdf')).called(1),
    );

    blocTest<SyllabusCubit, SyllabusState>(
      'unknown total size leaves progress indeterminate',
      build: () {
        stubDownload((onProgress) async {
          onProgress!(100, -1);
          return '/cache/a.pdf';
        });
        when(() => viewer.open(any())).thenAnswer((_) async {});
        return build();
      },
      seed: () => loaded(),
      act: (cubit) => cubit.openAttachment(attachment),
      expect: () => [loaded(opening: attachment.id), loaded()],
    );

    blocTest<SyllabusCubit, SyllabusState>(
      'a download failure keeps the syllabus and shows the message',
      build: () {
        stubDownload(
          (_) async => throw const ApiException(
            statusCode: 404,
            code: 'PORTAL_ATTACHMENT_NOT_FOUND',
            message: 'Không tìm thấy tệp.',
          ),
        );
        return build();
      },
      seed: () => loaded(),
      act: (cubit) => cubit.openAttachment(attachment),
      expect: () => [
        loaded(opening: attachment.id),
        loaded(error: 'Không tìm thấy tệp.'),
      ],
      verify: (_) => verifyNever(() => viewer.open(any())),
    );

    blocTest<SyllabusCubit, SyllabusState>(
      'a viewer that cannot open the file reports its message',
      build: () {
        stubDownload((_) async => '/cache/a.pdf');
        when(
          () => viewer.open(any()),
        ).thenThrow(const ContractException('No app found to open file'));
        return build();
      },
      seed: () => loaded(),
      act: (cubit) => cubit.openAttachment(attachment),
      expect: () => [
        loaded(opening: attachment.id),
        loaded(error: 'No app found to open file'),
      ],
    );

    blocTest<SyllabusCubit, SyllabusState>(
      'a second tap during a download is ignored',
      build: build,
      seed: () => loaded(opening: 'other'),
      act: (cubit) => cubit.openAttachment(attachment),
      expect: () => <SyllabusState>[],
      verify: (_) => verifyNever(
        () => portal.downloadAttachment(
          portalContext,
          itemId,
          attachment,
          onProgress: any(named: 'onProgress'),
        ),
      ),
    );

    blocTest<SyllabusCubit, SyllabusState>(
      'nothing happens before the syllabus has loaded',
      build: build,
      act: (cubit) => cubit.openAttachment(
        const SyllabusAttachment(
          id: 'x',
          fileName: 'x.pdf',
          kind: MaterialKind.other,
          sizeBytes: 1,
        ),
      ),
      expect: () => <SyllabusState>[],
    );
  });
}
