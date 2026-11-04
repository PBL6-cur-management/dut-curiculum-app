# dDUT Curriculum App

Flutter 3.38.7 / Dart ^3.10.7, Android and iOS.
Follow `.claude/rules/flutter-rules.md`.
Clean Architecture by feature; Cubit + Equatable; constructor injection.
Resolve dependencies only at the composition root with get_it + injectable.
Localization uses Flutter gen-l10n, not intl_utils.
User-visible text is Vietnamese; repository documentation is English.
Domain timestamps are epoch milliseconds, never DateTime objects.
Surface actual failures through state and BlocListener.
The app talks to the backend in `E:\PBL6\curriculum-management`.
Never change backend files from this project.
Never read or modify user-owned environment files.
Application ID remains `com.example.dut_curriculum_app`.

## Commands (run by the caller outside the restricted sandbox)
`flutter gen-l10n`
`dart run build_runner build --force-jit`
`flutter analyze`
`flutter run --dart-define-from-file=.env`

Flutter/Dart commands must not run inside the restricted execution sandbox.
Hooks require Git Bash; the sqflite hook is intentionally absent.
See `docs/implementation/` for the approved implementation sequence.
Pause 1 stops after the authentication and shell deliverables.
