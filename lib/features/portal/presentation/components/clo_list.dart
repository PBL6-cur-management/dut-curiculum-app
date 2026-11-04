import 'package:flutter/material.dart';

import 'portal_card.dart';

class CloList extends StatelessWidget {
  const CloList({super.key, required this.items});

  final List<({String code, String description})> items;

  @override
  Widget build(BuildContext context) => PortalCard(
    child: Column(
      children: [
        for (final (index, item) in items.indexed) ...[
          if (index > 0) const Divider(),
          ListTile(title: Text(item.code), subtitle: Text(item.description)),
        ],
      ],
    ),
  );
}
