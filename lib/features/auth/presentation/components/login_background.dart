import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import 'login_hexagon_painter.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.loginGradientEdge,
          AppColors.loginGradientCenter,
          AppColors.loginGradientEdge,
        ],
      ),
    ),
    child: CustomPaint(painter: const LoginHexagonPainter(), child: child),
  );
}
