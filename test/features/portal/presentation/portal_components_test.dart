import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dut_curriculum_app/common/theme/app_colors.dart';
import 'package:dut_curriculum_app/common/theme/app_dimens.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/portal_card.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/portal_page.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/portal_tabs.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';

import '../../../support/portal_widget_harness.dart';

void main() {
  testWidgets('scoped toolbar and flat course surface use the portal tokens', (
    tester,
  ) async {
    final contextCubit = MockPortalContextCubit();
    whenListen(
      contextCubit,
      const Stream<PortalContextState>.empty(),
      initialState: portalContextStateSample(),
    );
    await tester.pumpWidget(
      portalHarness(
        contextCubit: contextCubit,
        child: const PortalPage(
          title: 'Mẫu',
          body: PortalCard(child: Text('Học phần mẫu')),
        ),
      ),
    );
    final toolbar = tester.widget<AppBar>(find.byType(AppBar));
    final scoped = Theme.of(tester.element(find.byType(AppBar)));
    expect(scoped.appBarTheme.backgroundColor, AppColors.brand);
    expect(scoped.appBarTheme.foregroundColor, AppColors.surface);
    expect(scoped.appBarTheme.centerTitle, isTrue);
    expect(
      toolbar.toolbarHeight ?? scoped.appBarTheme.toolbarHeight,
      AppDimens.portalToolbarHeight,
    );
    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(PortalCard),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.color, AppColors.portalCourseSurface);
    expect(material.elevation, AppDimens.portalFlatElevation);
    expect(
      material.borderRadius,
      BorderRadius.circular(AppDimens.portalCardRadius),
    );
    expect(material.shape, isNull);
  });
  testWidgets(
    'tabs expose selection, fill, foreground, top corners and reserved baseline',
    (tester) async {
      final semantics = tester.ensureSemantics();
      addTearDown(semantics.dispose);
      int? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PortalTabs(
              labels: const ['Tiến độ', 'Kết quả'],
              selected: 0,
              onSelected: (value) => selected = value,
            ),
          ),
        ),
      );
      final buttons = tester
          .widgetList<TextButton>(find.byType(TextButton))
          .toList();
      expect(
        buttons.first.style!.backgroundColor!.resolve({}),
        AppColors.brand,
      );
      expect(
        buttons.first.style!.foregroundColor!.resolve({}),
        AppColors.surface,
      );
      expect(
        buttons.last.style!.backgroundColor!.resolve({}),
        Colors.transparent,
      );
      expect(buttons.last.style!.foregroundColor!.resolve({}), AppColors.brand);
      final shape =
          buttons.first.style!.shape!.resolve({})! as RoundedRectangleBorder;
      expect(
        shape.borderRadius,
        BorderRadius.circular(AppDimens.portalPillRadius),
      );
      expect(
        tester.getBottomLeft(find.byType(TextButton).last).dy,
        tester.getBottomLeft(find.byType(TextButton).first).dy,
      );
      expect(
        tester
            .getSemantics(find.text('Tiến độ'))
            .hasFlag(SemanticsFlag.isSelected),
        isTrue,
      );
      await tester.tap(find.text('Kết quả'));
      expect(selected, 1);
    },
  );
  testWidgets(
    'tab counts are separate numeric text and retain accessible labels',
    (tester) async {
      final semantics = tester.ensureSemantics();
      addTearDown(semantics.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PortalTabs(
              labels: const ['Cho phép', 'Chưa cho phép'],
              counts: const [12, 3],
              selected: 0,
              onSelected: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Cho phép'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      final node = tester.getSemantics(find.text('Cho phép'));
      expect(node.label, contains('Cho phép'));
      expect(node.label, contains('12'));
      expect(node.hasFlag(SemanticsFlag.isSelected), isTrue);
    },
  );
  testWidgets('long card text grows at large scale without overflow', (
    tester,
  ) async {
    final contextCubit = MockPortalContextCubit();
    whenListen(
      contextCubit,
      const Stream<PortalContextState>.empty(),
      initialState: portalContextStateSample(),
    );
    await tester.binding.setSurfaceSize(
      const Size(portalTestWidth, portalTestHeight),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      portalHarness(
        contextCubit: contextCubit,
        textScale: portalLargeTextScale,
        child: const PortalPage(
          title: 'Mẫu',
          body: SingleChildScrollView(
            child: PortalCard(
              child: Text(
                'Học phần mẫu có tên dài và điều kiện cần đọc đầy đủ',
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
