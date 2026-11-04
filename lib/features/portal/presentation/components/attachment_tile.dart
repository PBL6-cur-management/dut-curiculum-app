import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_dimens.dart';

class AttachmentTile extends StatelessWidget {
  const AttachmentTile({
    super.key,
    required this.name,
    required this.kind,
    required this.size,
    required this.isDownloading,
    required this.onOpen,
    this.progress,
  });

  final String name;
  final String kind;
  final String size;
  final bool isDownloading;
  final double? progress;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(name),
    subtitle: Text(kind),
    onTap: onOpen,
    trailing: isDownloading
        ? SizedBox.square(
            dimension: AppDimens.downloadIndicatorSize,
            child: CircularProgressIndicator(value: progress),
          )
        : IconButton(
            tooltip: AppLocalizations.of(context).downloadAttachment,
            onPressed: onOpen,
            icon: const Icon(Icons.download_outlined),
          ),
  );
}
