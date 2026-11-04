import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/app_dimens.dart';

class LoginHexagonPainter extends CustomPainter {
  const LoginHexagonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surface.withValues(alpha: AppDimens.backgroundAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppDimens.hexagonStroke;
    const radius = AppDimens.hexagonRadius;
    const diameter = radius * 2;
    final top = size.height * (1 - AppDimens.backgroundFraction);
    for (var row = 0; top + row * diameter < size.height + diameter; row++) {
      for (
        var column = 0;
        column * diameter < size.width + diameter;
        column++
      ) {
        final center = Offset(
          column * diameter + (row.isOdd ? radius : 0),
          top + row * diameter,
        );
        final path = Path();
        for (var vertex = 0; vertex < AppDimens.hexagonSides; vertex++) {
          final angle = math.pi * 2 * vertex / AppDimens.hexagonSides;
          final point =
              center + Offset(math.cos(angle), math.sin(angle)) * radius;
          if (vertex == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
          canvas.drawCircle(point, AppDimens.hexagonNodeRadius, paint);
        }
        canvas.drawPath(path..close(), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant LoginHexagonPainter oldDelegate) => false;
}
