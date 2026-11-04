import 'package:flutter_test/flutter_test.dart';
import 'package:dut_curriculum_app/common/widgets/startup_error_app.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../support/domain_samples.dart';

void main() {
  late AppLocalizations strings;

  setUpAll(() async => strings = await loadStrings());

  testWidgets(
    'shows the missing base URL message without an exception prefix',
    (tester) async {
      await tester.pumpWidget(
        StartupErrorApp(message: strings.missingApiBaseUrl),
      );
      await tester.pumpAndSettle();

      expect(find.text(strings.missingApiBaseUrl), findsOneWidget);
      expect(find.textContaining('Bad state'), findsNothing);
    },
  );
}
