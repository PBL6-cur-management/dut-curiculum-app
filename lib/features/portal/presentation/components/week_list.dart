import 'package:flutter/material.dart';

import 'portal_card.dart';

class WeekList extends StatelessWidget {
  const WeekList({super.key, required this.items});

  final List<({String label, String content})> items;

  @override
  Widget build(BuildContext context) => PortalCard(
    child: Column(
      children: [
        for (final (index, item) in items.indexed) ...[
          if (index > 0) const Divider(),
          ListTile(title: Text(item.label), subtitle: Text(item.content)),
        ],
      ],
    ),
  );
}
