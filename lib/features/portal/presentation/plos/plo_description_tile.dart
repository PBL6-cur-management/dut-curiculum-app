import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class PloDescriptionTile extends StatefulWidget {
  const PloDescriptionTile({
    super.key,
    required this.code,
    required this.description,
  });
  final String code;
  final String description;

  @override
  State<PloDescriptionTile> createState() => _PloDescriptionTileState();
}

class _PloDescriptionTileState extends State<PloDescriptionTile> {
  bool _expanded = false;

  static const _codeStyle = TextStyle(
    fontSize: AppDimens.portalMetaSize,
    fontWeight: FontWeight.w700,
    color: AppColors.brand,
  );
  static const _descriptionStyle = TextStyle(
    fontSize: AppDimens.portalCourseNameSize,
    color: AppColors.textPrimary,
  );

  // The description column's width is the card's minus the badge, so both are measured here.
  bool _overflows(BuildContext context, double width) {
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final badge = TextPainter(
      text: TextSpan(text: widget.code, style: _codeStyle),
      textDirection: direction,
      textScaler: scaler,
    )..layout();
    final description =
        TextPainter(
          text: TextSpan(text: widget.description, style: _descriptionStyle),
          textDirection: direction,
          textScaler: scaler,
          maxLines: AppDimens.portalOutcomePreviewLines,
        )..layout(
          maxWidth:
              width -
              badge.width -
              AppDimens.portalSpaceSm * 2 -
              AppDimens.portalSpaceMd,
        );
    final overflows = description.didExceedMaxLines;
    badge.dispose();
    description.dispose();
    return overflows;
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimens.portalSpaceMd),
    child: Material(
      color: AppColors.pageBackground,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(AppDimens.portalPanelRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final expandable = _overflows(
            context,
            constraints.maxWidth - AppDimens.portalSpaceLg * 2,
          );
          return InkWell(
            onTap: expandable
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.portalSpaceLg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimens.portalButtonRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.portalSpaceSm,
                        vertical: AppDimens.portalSpaceXs,
                      ),
                      child: Text(widget.code, style: _codeStyle),
                    ),
                  ),
                  const SizedBox(width: AppDimens.portalSpaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedSize(
                          duration: AppDimens.feedbackDuration,
                          alignment: Alignment.topCenter,
                          child: Text(
                            widget.description,
                            maxLines: _expanded
                                ? null
                                : AppDimens.portalOutcomePreviewLines,
                            overflow: _expanded ? null : TextOverflow.ellipsis,
                            style: _descriptionStyle,
                          ),
                        ),
                        if (expandable)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              _expanded ? Icons.expand_less : Icons.expand_more,
                              color: AppColors.brand,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
