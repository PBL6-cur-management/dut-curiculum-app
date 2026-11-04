# Technical Reference

- Flutter 3.38.7 / Dart ^3.10.7. Dependencies are already resolved in pubspec.lock; versions are recorded in the implement report.
- API_BASE_URL is a compile-time define containing the API root including `/api`. The user maintains environment files. Missing configuration fails before dependency initialization.
- Dio uses persisted cookies in application support storage and `x-requested-with: XMLHttpRequest`. Non-login 401 responses publish session expiry. Auth endpoints are `/auth/login`, `/auth/me`, `/auth/logout`, and `/auth/change-password`; password changes return no body.
- gen-l10n writes source into lib/l10n. json_serializable and injectable generate part/config files. Generated sources are not authored manually.
- Android permits cleartext only for the three approved development hosts. iOS allows local networking; device builds remain unverified.
- Run generation and analysis outside the restricted sandbox, in order: `flutter gen-l10n`, `dart run build_runner build --force-jit`, `flutter analyze`.
- Portal routes now use `/curriculum` plus program/syllabus, PLO, progress, registration and graduation detail paths. The obsolete curriculum placeholder URL redirects to the overview. Other placeholder call sites are retained unchanged.
- Portal calls use programId/semesterId context; result pages use page and pageSize 50. Eligibility contractVersion 1 is strict; graduation schemaVersion is checked before current payload decoding and unknown versions remain unsupported outcomes.
- Attachment downloads use the session client and a sanitized temporary filename; AttachmentViewer wraps open_filex. No platform plugin is invoked by authored contract tests.
- Nine synthetic JSON fixtures and four contract-test files are present. Interceptor tests were blocked during file creation; Cubit/widget tests are not implemented. No new source has been generated, analyzed or tested in this continuation. Complete these tests before externally running `flutter test`.
- The raw getIt text scan also matches standard injectable generated output in getit_utils.config.dart; authored portal feature files do not use the locator. Generated source is never edited to satisfy a textual scan.
