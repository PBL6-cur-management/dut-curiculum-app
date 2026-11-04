import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/routes/route_paths.dart';
import '../../../../common/theme/app_dimens.dart';
import '../../../../common/widgets/app_page.dart';
import '../../../../common/widgets/empty_panel.dart';
import '../../domain/model/home_tile.dart';
import '../components/home_tile_presentation.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.tile, this.title});

  final HomeTile tile;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return AppPage(
      appBar: AppBar(title: Text(title ?? tile.label(strings))),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.screenPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimens.contentMaxWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EmptyPanel(message: strings.placeholderBody),
                  const SizedBox(height: AppDimens.largeGap),
                  FilledButton(
                    onPressed: () => context.go(RoutePaths.curriculum),
                    child: Text(strings.placeholderOpenCurriculum),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
