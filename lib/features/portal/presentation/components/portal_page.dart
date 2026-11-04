import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/routes/route_paths.dart';
import '../context/portal_context_bar.dart';
import 'portal_theme.dart';

class PortalPage extends StatelessWidget {
  const PortalPage({
    super.key,
    required this.title,
    required this.body,
    this.onBeforeContextChange,
    this.onBack,
  });
  final String title;
  final Widget body;
  final VoidCallback? onBeforeContextChange;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Theme(
    data: PortalTheme.from(Theme.of(context)),
    child: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: BackButton(
            onPressed:
                onBack ??
                () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RoutePaths.curriculum);
                  }
                },
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              PortalContextBar(onBeforeChange: onBeforeContextChange),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    ),
  );
}
