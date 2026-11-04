import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_page.dart';
import 'components/bottom_nav_bar.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => AppPage(
    body: navigationShell,
    bottomNavigationBar: BottomNavBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => navigationShell.goBranch(index),
    ),
  );
}
