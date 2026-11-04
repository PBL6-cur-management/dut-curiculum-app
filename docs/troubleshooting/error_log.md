# Error Log

## Flutter tooling stalls in the restricted sandbox

The caller identified denied SDK cache and APPDATA writes as the cause. The untouched tree analyzes cleanly outside the sandbox. Do not rerun Flutter/Dart commands inside it or broaden permissions. Run generation and analysis externally and return diagnostics to the execution session.

## [2026-11-01] Validation messages shown with a "FormatException:" prefix
**Symptom**: submitting the login form with empty fields, or the change-password form with an empty current password, would show "FormatException: Nhập mật khẩu hiện tại." instead of the plain Vietnamese message. Found by the cubit tests, not by a user.
**Possible cause**: `LoginCubit` and `ChangePasswordCubit` threw `FormatException(localizedText)` for local validation and surfaced `error.toString()`; `FormatException.toString()` prepends the class name.
**Resolution**: added `lib/core/validation_exception.dart` whose `toString()` returns only the message; both cubits now throw it (`login_cubit.dart`, `change_password_cubit.dart`).
**How to avoid**: never throw a built-in exception whose text is shown to users and then display `toString()`. Use a dedicated exception that owns its display text, or carry the message in state directly.

## [2026-11-01] App frozen on the launch screen when `API_BASE_URL` is missing
**Symptom**: on a device, the app stayed on the native splash screen forever. Logcat showed `Unhandled Exception: Bad state: Thiếu API_BASE_URL: chạy với --dart-define-from-file=.env` at `main.dart:14`.
**Possible cause**: `ApiConfig.baseUrl` is a compile-time `String.fromEnvironment`, so it is empty when the build is launched without `--dart-define-from-file` (IDE run button, `flutter install`, an APK built without the flag). `main()` checked it outside the `try` and threw a `StateError` before any `runApp`, so no Flutter frame was ever drawn and `StartupErrorApp` was never reached.
**Resolution**: `lib/main.dart` now runs `StartupErrorApp` with the localized `missingApiBaseUrl` message and returns, instead of throwing. Added `test/common/widgets/startup_error_app_test.dart`.
**How to avoid**: in `main()`, every failure after `ensureInitialized` must end in a `runApp`. An exception thrown before the first frame is invisible on the device. Also don't show `error.toString()` of a built-in error to users (`StateError` adds "Bad state:"); see the `FormatException` entry above.

## [2026-11-01] VS Code launch config never passed `API_BASE_URL`
**Symptom**: starting the app with the VS Code Run button showed "Thiếu API_BASE_URL…" (before that fix, the app froze on the splash screen), even though `.vscode/launch.json` listed `--dart-define-from-file=.env`.
**Possible cause**: the flag was under `args`. In Dart-Code, `args` are handed to the app's `main()`. Only `toolArgs` reach `flutter run`, so the define file was never read.
**Resolution**: `.vscode/launch.json` now passes the flag under `toolArgs`. Added a profile-mode configuration with the same `toolArgs`.
**How to avoid**: flags for the Flutter tool (`--dart-define*`, `--flavor`, `--device-id`) belong in `toolArgs`. `args` is for the program's own arguments.

## [2026-11-03] Startup waits up to 15 s before showing login
**Symptom**: on launch the app sat on a blank loading screen for a long time before the login screen, even for a first run with no saved login, and especially when the backend was off.
**Possible cause**: `SessionCubit.restore()` always called `GET /auth/me`, with no local check first, and the router holds the splash route while the session is `unknown`. With the server unreachable, the call waited out the general `connectTimeout` (15 s) before failing over to login.
**Resolution**: `auth_repository_impl.dart` returns signed-out at once when the cookie jar holds no cookie for `API_BASE_URL`. `auth_api.dart` cancels the restore call after `ApiConfig.sessionRestoreTimeout` (5 s); a cancel maps to the usual network error, so the user lands on login with that notice. The splash route now shows `StartupSplashScreen` (login gradient, dDUT wordmark, spinner, "Đang kiểm tra phiên đăng nhập"). Android launch resources draw the same gradient natively. Test: `test/features/auth/data/auth_repository_impl_test.dart`.
**How to avoid**: a network call that gates the first screen needs a local precondition (is there anything to restore?) and its own short timeout; the general request timeout is sized for data screens, not for startup.
