import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'portal_section_header.dart';

class HtmlSection extends StatelessWidget {
  const HtmlSection({super.key, required this.title, required this.html});

  final String title;
  final String html;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PortalSectionHeader(title: title),
      HtmlWidget(html),
    ],
  );
}
