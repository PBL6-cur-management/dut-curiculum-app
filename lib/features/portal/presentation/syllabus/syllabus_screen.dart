import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/utils/decimal_format.dart';
import '../../../../common/widgets/loading_skeleton.dart';
import '../components/assessment_table.dart';
import '../components/attachment_tile.dart';
import '../components/clo_list.dart';
import '../components/html_section.dart';
import '../components/portal_disclosure.dart';
import '../components/portal_labels.dart';
import '../components/portal_page.dart';
import '../components/portal_section_header.dart';
import '../components/portal_state_panel.dart';
import '../components/syllabus_header.dart';
import '../components/week_list.dart';
import 'syllabus_cubit.dart';
import 'syllabus_state.dart';

class SyllabusScreen extends StatelessWidget {
  const SyllabusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(
      title: strings.syllabus,
      onBeforeContextChange: () => context.go(RoutePaths.curriculumProgram),
      body: BlocBuilder<SyllabusCubit, SyllabusState>(
        builder: (context, state) {
          if (state.isLoading) return const LoadingSkeleton();
          final data = state.data;
          if (data == null)
            return PortalStatePanel(
              message: state.errorMessage ?? strings.noData,
              isError: state.errorMessage != null,
              onRetry: context.read<SyllabusCubit>().load,
            );
          final cubit = context.read<SyllabusCubit>();
          return ListView(
            padding: const EdgeInsets.all(AppDimens.portalPageInset),
            children: [
              SyllabusHeader(
                name: data.courseName,
                details: [
                  data.courseCode,
                  strings.creditsValue(formatDecimal(data.credits)),
                  strings.revision(data.revisionNumber),
                ],
              ),
              PortalSectionHeader(title: strings.assessment),
              Text(strings.portalAssessmentNotice),
              if (data.assessments.isEmpty)
                Text(strings.noData)
              else
                AssessmentTable(
                  rows: [
                    for (final item in data.assessments)
                      (
                        component: '${item.code} · ${item.name}',
                        form: item.form ?? strings.notProvided,
                        weight: strings.percentValue(
                          formatDecimal(item.weight),
                        ),
                      ),
                  ],
                ),
              if (data.assessmentMethods?.trim().isNotEmpty ?? false)
                PortalDisclosure(
                  key: const PageStorageKey('assessment-methods'),
                  title: strings.assessmentMethods,
                  children: [
                    HtmlSection(
                      title: strings.assessmentMethods,
                      html: data.assessmentMethods!,
                    ),
                  ],
                ),
              if (data.courseDescription?.trim().isNotEmpty ?? false)
                PortalDisclosure(
                  key: const PageStorageKey('course-description'),
                  title: strings.courseDescription,
                  children: [
                    HtmlSection(
                      title: strings.courseDescription,
                      html: data.courseDescription!,
                    ),
                  ],
                ),
              PortalDisclosure(
                key: const PageStorageKey('clos'),
                title: strings.clos,
                children: [
                  if (data.clos.isEmpty)
                    Text(strings.noData)
                  else
                    CloList(
                      items: [
                        for (final item in data.clos)
                          (code: item.code, description: item.description),
                      ],
                    ),
                ],
              ),
              PortalDisclosure(
                key: const PageStorageKey('weeks'),
                title: strings.weeklyPlan,
                children: [
                  if (data.weeks.isEmpty)
                    Text(strings.noData)
                  else
                    WeekList(
                      items: [
                        for (final item in data.weeks)
                          (label: item.label, content: item.content),
                      ],
                    ),
                ],
              ),
              PortalDisclosure(
                key: const PageStorageKey('documents'),
                title: strings.attachments,
                children: [
                  if (state.errorMessage case final message?)
                    PortalStatePanel(message: message, isError: true),
                  if (data.attachments.isEmpty) Text(strings.noData),
                  for (final attachment in data.attachments)
                    AttachmentTile(
                      name: attachment.fileName,
                      kind: attachment.kind.label(strings),
                      size: '',
                      isDownloading: state.openingAttachmentId == attachment.id,
                      progress: state.downloadProgress,
                      onOpen: state.openingAttachmentId == null
                          ? () => cubit.openAttachment(attachment)
                          : null,
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
