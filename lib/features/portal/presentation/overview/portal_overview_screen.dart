import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/theme/app_dimens.dart';
import '../components/portal_menu_list.dart';
import '../components/portal_page.dart';
import '../context/portal_route.dart';

class PortalOverviewScreen extends StatelessWidget {
  const PortalOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalRoute(
      onBack: () => context.go(RoutePaths.home),
      builder: (portal, state) => PortalPage(
        title: strings.curriculum,
        onBack: () => context.go(RoutePaths.home),
        body: ListView(
          padding: const EdgeInsets.all(AppDimens.portalPageInset),
          children: [
            PortalMenuList(
              items: [
                (
                  icon: Icons.school_outlined,
                  label: strings.myCurriculum,
                  hint: strings.portalCurriculumHint,
                  onTap: () {
                    context.push(RoutePaths.curriculumProgram);
                  },
                ),
                (
                  icon: Icons.flag_outlined,
                  label: strings.plos,
                  hint: strings.portalPlosHint,
                  onTap: () {
                    context.push(RoutePaths.plos);
                  },
                ),
                (
                  icon: Icons.bar_chart_outlined,
                  label: strings.progressResults,
                  hint: strings.portalProgressHint,
                  onTap: () {
                    context.push(RoutePaths.progress);
                  },
                ),
                (
                  icon: Icons.checklist_outlined,
                  label: strings.portalEligibilityTitle,
                  hint: strings.portalEligibilityHint,
                  onTap: () {
                    context.push(RoutePaths.registration);
                  },
                ),
                (
                  icon: Icons.verified_outlined,
                  label: strings.graduation,
                  hint: strings.portalGraduationHint,
                  onTap: () {
                    context.push(RoutePaths.graduation);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
