# Progress Log

## 2026-11-01

Initial baseline attempt stalled inside the sandbox. Caller subsequently confirmed a clean untouched-tree baseline outside it. Resumed approved pause-1 scope with all Flutter/Dart invocation delegated to the caller. See the implement report for deliverable details and final verification limitations.

Completed E-01, E-02, C-01..C-06, A-01..A-06, and S-01..S-05 source deliverables. Both composition-root/timestamp boundary scans pass. Template, configuration, import, and localization checks pass. Stopped before portal/test phases; code generation and analyzer certification remain caller-owned.

## 2026-11-01 — Portal Continuation and Test Blocker

Caller cleared pause 1 after external generation, --force-jit build_runner, formatting and clean analysis; pauses 2/3 were waived. Authored P-01..P-11: domain/data, context, seven screens, real routes and attachment handling. Added nine synthetic fixtures and four contract-test files. No Flutter/Dart command, backend request or environment-file access occurred.

Stopped during T-01 after tool policy rejected writing the interceptor test, including a handler-only form. T-02/T-03 remain unstarted; T-04 is a truthful partial handoff. PowerShell pipeline launch failures were worked around with PTY execution, but the policy rejection was not bypassed. Timestamp and literal-Text scans pass; the locator scan additionally includes pre-existing generated injectable output. Complete implementation and caller automated checks before the user's full device walkthrough. See the implement report for the escalation and exact scope.

## 2026-11-01 — Tests and documentation complete

Finished T-01..T-04. Added interceptor, cubit (auth and portal), home/login widget and router redirect tests. Fixed a real bug the tests exposed: local validation messages carried a "FormatException:" prefix (`ValidationException`, see error log). Gates: `flutter analyze` No issues found!; `flutter test` 176/176. Not verified on a device.

## 2026-11-01 — Startup error screen for a missing API_BASE_URL

The first device run froze on the native splash screen because the build was launched without the dart-define file. `main.dart` threw before `runApp`. It now shows `StartupErrorApp` with the localized message; see error log. Gates: `flutter analyze` No issues found!; `flutter test` 177/177.

## 2026-11-01 — Profile without change password; README; demo data snapshots

Removed the change-password button from the profile. The route and screen remain for the forced first-login flow. Hid the debug banner in `app.dart` and `startup_error_app.dart`. Rewrote `README.md` with the test account, run steps, test walkthrough and troubleshooting. Every portal feature returned "Ảnh chụp khung chương trình chưa đầy đủ" because the restored `ctdt_real` dump predates the seed's snapshot writes. The local DB was backfilled (3243 rows); see the curriculum-management error log for 2026-11-01. Gates: `flutter analyze` No issues found!; `flutter test` 177/177.

## 2026-11-01 — Component restyle (Codex), colours unchanged

Codex restyled the components of 50 files across theme, shared widgets, shell, portal and change password. The changes: a spacing and radius scale in `app_dimens.dart`, flat cards with a hairline border, compact lists, label/value rows (`field_value_row.dart`), and status chips with an icon and a label. New files: `app_component_theme.dart`, `app_page.dart`, `field_value_row.dart` and `program_summary_card.dart`. `app_colors.dart` and the login files are unchanged; all 14 colours keep their values. Login keeps its dDUT look: `AppComponentTheme` is a theme extension, and it is applied only outside login and its bottom sheet. Gates: `flutter analyze` No issues found!; `flutter test` 177/177. Not yet checked on a device.

## 2026-11-03 — Curriculum redesign build (Codex), interrupted; startup splash

Codex built the curriculum redesign plan. The run died near the end when the provider returned 503, so it wrote no report. Every hand-edited file for CR-01, CR-03..05 and CR-07..13 had changed when it stopped; CR-02/CR-06 are codegen and were run afterwards. Gates after codegen: `flutter analyze` 0 errors (13 infos); `flutter test` 306/309: 2 tab tests in `portal_components_test.dart` and 1 test in `syllabus_screen_test.dart` fail. Still owed: resume Codex session `01a19ef9-b6a3-7493-9cbe-db84590ffeeb` for its report and final pass, and the 3 failures.

Startup: when the cookie jar is empty, the app goes straight to login; the restore call is capped at 5 s; a new `StartupSplashScreen` replaces the skeleton on the splash route; the Android native splash uses the login gradient (`res/values/colors.xml`, both `launch_background.xml`, plus `values-v31` and `values-night-v31` styles). See error_log 2026-11-03. Gates: `flutter analyze` 0 errors; `flutter test` 307/310 (the same 3 redesign failures); `flutter build apk --debug` OK.
