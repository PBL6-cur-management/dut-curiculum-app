import 'package:flutter/material.dart';

import 'portal_card.dart';

class AssessmentTable extends StatelessWidget {
  const AssessmentTable({super.key, required this.rows});
  final List<({String component, String form, String weight})> rows;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final row in rows)
        PortalCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.component,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(row.form),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(row.weight),
              ),
            ],
          ),
        ),
    ],
  );
}
