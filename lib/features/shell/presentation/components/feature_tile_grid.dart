import 'package:flutter/material.dart';

import '../../../../common/theme/app_dimens.dart';
import 'feature_tile.dart';

class FeatureTileGrid extends StatelessWidget {
  const FeatureTileGrid({super.key, required this.tiles});

  final List<({IconData icon, String label, VoidCallback onTap})> tiles;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: tiles.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: AppDimens.gridColumns,
      crossAxisSpacing: AppDimens.homeTileGap,
      mainAxisSpacing: AppDimens.homeTileGap,
      mainAxisExtent: MediaQuery.textScalerOf(
        context,
      ).scale(AppDimens.featureTileHeight),
    ),
    itemBuilder: (context, index) {
      final tile = tiles[index];
      return FeatureTile(icon: tile.icon, label: tile.label, onTap: tile.onTap);
    },
  );
}
