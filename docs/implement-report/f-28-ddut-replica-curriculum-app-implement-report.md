# F-28 dDUT Replica Curriculum App — Implement Report

**Status**: COMPLETE as code — E/S/P/T deliverables landed; not yet verified on a device. The earlier tool-policy escalation is closed.
**Validation**: `dart format lib test` clean; `flutter analyze` "No issues found!"; `flutter test` 176/176 passed. No backend request, `flutter run` or build was made.
**Date**: 2026-11-01 (Asia/Bangkok).
**Scope**: portal and automated-test/documentation deliverables. The user owns the device walkthrough.

## Current Summary

The earlier E-01 through S-05 work remains intact and caller-verified. Portal models, data, Cubits, seven screens and real routes are authored. Four contract-test files and nine synthetic endpoint fixtures are authored. The interceptor-test write was rejected by tool policy, including a handler-only version with no request execution. The non-interactive stop rule applies; Cubit/widget tests and completion certification remain outstanding. Historical verification below applies only to its original scope, not the new portal source. No generated source was handwritten, backend request made, package added, or environment file read.

| ID | Files | ~lines | How verified |
|---|---|---:|---|
| E-01 | `.claude/**`, `CLAUDE.md`, `README.md`, architecture/technical/progress/troubleshooting docs | 839 | Seven SHA256 matches; settings equal template minus sqflite; JSON parse; CLAUDE.md <=40 lines |
| E-02 | pubspec, l10n/analyzer/build config, Android manifest/network XML, iOS plist, gitignore, launch config; startup guard in A-04 | 238 | JSON/XML parse; static configuration review; no package changes |
| C-01 | `lib/common/theme/*.dart` | 97 | Static token/theme review |
| C-02 | `lib/l10n/app_vi.arb` | 106 | ARB parses; referenced keys exist; web labels compared; caller gen-l10n pending |
| C-03 | `lib/core/network/{api_config,api_paths,api_exception,contract_exception}.dart` | 98 | Static contract/source review |
| C-04 | Dio module, two interceptors, session events | 85 | Static cookie/header/expiry review; no backend requests |
| C-05 | `lib/core/di/*.dart` | 22 | Composition-root scan passes; caller injectable generation pending |
| C-06 | Six shared widgets; date/decimal/file-size helpers; date parsing | 199 | Static import review; timestamp scan passes |
| A-01 | Auth session model, repository, use-case aggregator | 71 | Domain has no Flutter imports; authored imports resolve |
| A-02 | Auth API, repository implementation, four DTOs | 219 | Backend modeled fields and 204 contract checked; caller JSON generation pending |
| A-03 | `auth/presentation/session/*.dart` | 142 | Static transition/lifetime/error review |
| A-04 | Three route files, main, app, startup error app | 300 | Static redirect/ownership review; locator scan passes |
| A-05 | Login screen/cubit/state and six components | 444 | ARB/reference checks; pure-component scan; static failure/success review |
| A-06 | Password policy, cubit/state/screen, pure form | 221 | Compared policy to backend; static forced/voluntary navigation review |
| S-01 | Main shell, bottom navigation component | 94 | Indexed shell and branch state preservation reviewed statically |
| S-02 | HomeTile enum, presentation mapping | 52 | Eleven enum values, curriculum first, exhaustive label/icon mapping |
| S-03 | Home screen, header, date card, tiles/grid, avatar | 322 | Clock boundary scan; pure-component and localization checks |
| S-04 | Profile screen and info card | 151 | Static data/confirmation/logout wiring review |
| S-05 | Placeholder screen | 59 | Static known/unknown tile routes and non-looping pending curriculum destination |

Line counts are approximate authored file sizes, exclude generated outputs, and are not test coverage claims.

## Initial Attempt Summary (Historical)

The approved plan was read in full and the Flutter stack rules were inspected. The required first `flutter analyze` invocation produced no analyzer output and did not finish after several minutes. Its newly started, CPU-active command process was terminated; the original invocation then returned exit code 1 with empty output. This is an interrupted environment/tooling check, not an analyzer finding or a code verdict. The underlying startup failure has not been diagnosed. No application, platform, dependency, or template configuration was changed.

| ID | Files | ~lines | How verified |
|---|---|---:|---|
| E-01 | none | 0 | Not landed; baseline blocker |
| E-02 | none | 0 | Not landed; dependencies already present, remaining configuration not changed |
| C-01 | none | 0 | Not landed |
| C-02 | none | 0 | Not landed |
| C-03 | none | 0 | Not landed |
| C-04 | none | 0 | Not landed |
| C-05 | none | 0 | Not landed |
| C-06 | none | 0 | Not landed |
| A-01 | none | 0 | Not landed |
| A-02 | none | 0 | Not landed |
| A-03 | none | 0 | Not landed |
| A-04 | none | 0 | Not landed |
| A-05 | none | 0 | Not landed |
| A-06 | none | 0 | Not landed |
| S-01 | none | 0 | Not landed |
| S-02 | none | 0 | Not landed |
| S-03 | none | 0 | Not landed |
| S-04 | none | 0 | Not landed |
| S-05 | none | 0 | Not landed |

## Resolved Packages

Read from the existing `pubspec.lock`; no package operations were performed.

| Package | Resolved version |
|---|---|
| bloc_test | 10.0.0 |
| build_runner | 2.15.1 |
| cookie_jar | 4.0.9 |
| dio | 5.11.1 |
| dio_cookie_manager | 3.5.0 |
| equatable | 3.0.0 |
| flutter_bloc | 9.1.1 |
| flutter_lints | 6.0.0 |
| flutter_localizations | 0.0.0 (Flutter SDK) |
| flutter_widget_from_html_core | 0.17.4 |
| get_it | 9.3.0 |
| go_router | 17.5.0 |
| injectable | 2.7.1+4 |
| injectable_generator | 2.9.1 |
| intl | 0.20.2 |
| json_annotation | 4.9.0 |
| json_serializable | 6.11.2 |
| mocktail | 1.0.5 |
| open_filex | 5.0.0 |
| path_provider | 2.1.6 |

## Initial Verification (Historical)

- `flutter analyze` (pre-edit baseline): exit code **1 after explicit termination**; verbatim command output was empty. It stalled before producing any analyzer diagnostics. Do not interpret this as a source-code failure.
- `flutter gen-l10n`: not run; stopped before implementation.
- `dart run build_runner build --delete-conflicting-outputs`: not run; stopped before implementation.
- Final `flutter analyze`: not run; baseline could not complete.
- Required `getIt` and `DateTime` scans: not run; no application code changed.

## Incident

The baseline command resolved to `C:\dev\flutter\bin\flutter.bat`. It remained running without output for several minutes. The newly started command process associated with that invocation consumed CPU; stopping that process allowed the tool session to return exit code 1. Process-parent inspection through `Get-CimInstance Win32_Process` was denied by the environment, so no more specific root cause is claimed. No SDK files or permissions were changed and no unrelated pre-existing Dart processes were stopped.

## Initial Deviation (Historical)

The requested plan status `In progress — through S-05` was not applied because no deliverable reached completion. The plan remains unchanged rather than asserting false progress. This report is the only new file.

## Initial Escalations (Historical)

Completed: full plan/rule inspection, baseline attempt, and recording existing resolved package versions.

Blocked: the required baseline analysis cannot currently be obtained through the available Flutter entry point. Later generation and validation therefore cannot be certified.

Options: diagnose the Flutter startup stall in the existing approved environment, or have the environment owner repair the tool execution setup and restart this task. Do not broaden access, replace the SDK, or implement unverified work merely to bypass this gate.

Recommendation: restore a successful `flutter analyze` baseline in this working root, then resume E-01 through S-05. No implementation has to be reverted.

## Initial Not Done (Historical)

All requested implementation deliverables E-01, E-02, C-01..C-06, A-01..A-06, and S-01..S-05 remain unfinished. P-xx and T-xx were not started. No file whose name begins with `.env` was read, created, or modified; no backend calls, Flutter run/build, package additions/upgrades, git commands, or external system changes were performed.

## Baseline Correction and Resumption

The caller resolved the earlier blocker outside the sandbox: Flutter/Dart write to the SDK cache under `C:\dev\flutter\bin\cache` and configuration under APPDATA, which the sandbox denies. On the untouched tree the caller reports `flutter analyze` output `No issues found! (ran in 2.2s)` and `dart analyze` output `No issues found!`. These are caller-provided baseline results, not commands rerun here; exit codes were not supplied. The earlier incident is retained above as historical evidence, not current status.

The resumed instruction prohibits every Flutter/Dart command. Generated imports and parts will be authored, but generated files will be produced by the caller. Final in-sandbox verification is limited to the requested locator and timestamp scans plus static/configuration checks.

## E-01 — Project Rules and Documentation

Installed byte-for-byte Flutter rules, three agents, and three non-sqflite hooks. Added settings with only the sqflite hook removed, a short CLAUDE.md, and English architecture/progress/technical/troubleshooting skeletons. README is updated at integration.

## E-02 — Configuration

Enabled built-in localization generation; configured checked JSON generation and generated-source analyzer exclusions. Added Android internet permission, scoped cleartext hosts and viewer query; retained the application ID and activity path. Configured iOS display/local networking and editor launch arguments. Environment files remain entirely user-owned and untouched. Main startup configuration guard lands with composition-root integration.

Incident: initial Windows native argument quoting rejected three patches before changing their files. Retried using escaped native quotes; subsequent patches succeeded.

## C-01 — Theme

Added screenshot-derived colors, dimensions, and Material theme; wordmark and shell use no image assets.

## C-02 — Localization

Added Vietnamese ARB strings and typed placeholders. Generated imports target lib/l10n directly. Deviation: the screenshot's English welcome is translated to satisfy the stronger all-Vietnamese UI requirement. Generation is caller-owned.

## C-03 — Network Contracts

Added API roots/paths, readable API failures, and contract failures. Session-required detection checks both 401 and SESSION_REQUIRED, so unrelated authorization failures do not become a null user.

## C-04 — HTTP and Session Events

Added persisted cookies (respecting expiry), CSRF and non-login 401 interceptors, and constructor-injected broadcast events. Base URL normalization preserves the /api prefix; Dio concatenates relative request paths. No backend calls were made.

## C-05 — Dependency Injection

Added the single injectable initialization entry point and a Vietnamese localization module for non-widget validation/error copy without BuildContext. Config generation is deferred to the caller.

## C-06 — Shared UI and Formatting

Added cards, error/empty/loading/status/section widgets and decimal/date/file-size helpers. DateTime is confined to edge helpers. File-size and date-parsing foundations are reserved for the explicitly deferred portal data boundary; they have no pause-1 data source.

## A-01 — Auth Domain

Added an Equatable session user, repository interface, and constructor-injected use-case aggregator. Domain contains no Flutter imports.

## A-02 — Auth Data

Added four JSON DTOs, the auth API, and the repository implementation. Verified modeled fields and endpoints against backend auth sources; change-password consumes no body. Logout always attempts cookie cleanup and preserves both actual messages if request and cleanup both fail. Generated DTO parts are intentionally absent until caller codegen.

## A-03 — Session Cubit

Added restore/sign-in/password-update/logout flows, real error carriers, and session-expiry notices. Decision during build: a revision counter prevents a late restoration response from undoing sign-out or expiry; expected bootstrap 401 does not display an expiry notice before any session exists.

## A-05 — Login

Added gradient/painter background, text wordmark, Vietnamese landing, and a state-driven bottom-sheet form. Components own only form controls and visibility; the screen owns Cubit access and listeners. Only non-empty credentials are checked locally.

## A-06 — Change Password

Added policy matching backend constants/regex, a three-field form, error listeners, and forced-mode back-navigation protection. Session password state is updated only after server success; voluntary mode returns to its previous route.

## A-04 — Router and Composition Root

Added session-gated routing, indexed home/profile branches, route-scoped form cubits, and app-scoped session wiring. The app owns and disposes the router refresh listener. Startup checks configuration before DI and renders actual initialization failures. Deviation: the curriculum route temporarily uses the existing shell placeholder rather than referencing PortalContextCubit, which belongs to the prohibited portal phase. No P-xx code was started.

## S-01 — Shell and Navigation

Added the indexed navigation shell and floating rounded navigation bar with selected indicators and accessible labels. Branch switching does not reset the branch location.

## S-02 — Home Tiles

Added the pure-Dart eleven-value tile enum and presentation-only label/icon/destination mapping. Curriculum is first; other tiles retain screenshot order.

## S-03 — Home Screen

Added the user's profile header, initials avatar, local-calendar date card, and two-column feature grid. Decision during build: refresh the date once per minute and on app resume, with the clock read only in HomeScreen. Components receive data and callbacks; no real student's reference identity is copied.

## S-04 — Profile

Added profile detail rows, joined role names, password navigation, and confirmed logout. The actual logout failure is shown even though the client transitions to unauthenticated state.

## S-05 — Shared Placeholder

Added the shared placeholder, notifications title, unknown-tile error handling, and curriculum navigation. Decision during build: the temporary curriculum destination has an explicit pending message and a home button to avoid a self-navigation loop at pause 1.

## Current Verification

1. `flutter gen-l10n` — not run — caller runs them. Exit code/output: not applicable.
2. `dart run build_runner build --delete-conflicting-outputs` — not run — caller runs them. Exit code/output: not applicable.
3. `flutter analyze` — not run — caller runs them. Exit code/output: not applicable. The clean caller-provided untouched-tree baseline is recorded in Baseline Correction and Resumption, not claimed as analysis of this implementation.
4. `Get-ChildItem -Recurse lib -Filter *.dart | Select-String -Pattern 'getIt' | Select-Object Path -Unique` — exit 0:

```text
Path
----
E:\PBL6\dut_curriculum_app\lib\main.dart
E:\PBL6\dut_curriculum_app\lib\common\routes\app_router.dart
E:\PBL6\dut_curriculum_app\lib\core\di\getit_utils.dart
```

5. `Get-ChildItem -Recurse lib -Filter *.dart | Select-String -Pattern 'DateTime' | Select-Object Path -Unique` — exit 0:

```text
Path
----
E:\PBL6\dut_curriculum_app\lib\common\extensions\date_parsing.dart
E:\PBL6\dut_curriculum_app\lib\common\utils\date_format.dart
E:\PBL6\dut_curriculum_app\lib\features\shell\presentation\home\home_screen.dart
```

Additional static checks ran under PowerShell without Flutter/Dart. A first template-hash helper had an array-shape mistake; the corrected check ran with terminating errors and passed. A configuration check exposed native-argument quote loss in analyzer globs/settings; repaired the quoting and reran successfully. Final static-check output (exit 0):

```text
7 template copies match SHA256.
Settings match template minus sqflite; JSON/ARB/XML parse; CLAUDE.md is within 40 lines.
All authored relative imports and localization keys resolve (generated imports deferred).
No portal implementation or handwritten generated files.
```

The component scan found no Cubit lookups or TODO/FIXME/print calls in widget components. No compiler, formatter, generated-code, automated-test, platform-build, or runtime verdict is implied by these textual checks.

## Current Deviations

- Generation and analyzer gates are caller-owned under the resumed instruction; generated imports and DTO parts intentionally have no authored target yet.
- Curriculum ShellRoute/context provider is deferred with P-04 rather than instantiating prohibited portal code. The existing placeholder keeps `/curriculum` reachable without pretending it is implemented.
- All UI copy is Vietnamese, including the translated welcome. A localization DI module supplies non-widget validation/network copy without BuildContext.
- File-size formatting and date parsing are the C-06 foundations explicitly requested for the next phase; they have no pause-1 data source. No unreachable feature screen or commented-out implementation was added.
- Analyzer exclusions additionally cover the actual gen-l10n output directory because Flutter 3.38 writes generated localization next to the ARB.

## Borderline Calls

- Material outlined icons and a low-opacity hexagon/node painter replace licensed assets.
- Notifications reuse the shared placeholder with a notification title; no extra feature is modeled.
- Date refresh is once per minute and on resume; domain/data remain clock-free.
- Session revision checks prevent stale restore responses from resurrecting a departed session.
- Both logout and cookie-cleanup failures are retained if they occur together.

## Current Escalations

none

## Remaining Caller Work

Run the three deferred generation/analysis commands outside the sandbox and return diagnostics if repairs are needed. Exercise the auth/shell flows on a device against the seeded backend, including app restart and session expiry. Platform builds and formal tests remain unverified. Portal and test-phase implementation are deliberately not started; this is pause 1.

## Caller Verification (outside the sandbox)

- Changed files on disk match the Changes list of the resumed run: 96 files, none missing and none unlisted.
- `flutter gen-l10n`: exit 0.
- `dart run build_runner build --delete-conflicting-outputs`: exit 78, `'dart compile' does not support build hooks, use 'dart build' instead.` / `Failed to compile build script.`
- `dart run build_runner build --force-jit`: exit 0, `Built with build_runner/jit in 34s; wrote 20 outputs.` The same run warned `These options have been removed and were ignored: --delete-conflicting-outputs`.
- `flutter analyze`: one info, `avoid_renaming_method_parameters` at `lib/core/network/session_expiry_interceptor.dart:15` (`error` vs the overridden `err`). Renamed the parameter to `err`; re-run: `No issues found!`.
- `dart format --set-exit-if-changed lib`: 9 of 74 files differed; `dart format lib` applied; analyze still clean.
- The real student's name, email and code from the design screenshots do not appear in `lib/`, `docs/`, `.claude/`, `CLAUDE.md` or `README.md`.
- Dio 5.11.1 `RequestOptions.uri` builds the URL by joining `baseUrl + path` as strings (`options.dart:662`), so `API_BASE_URL=<host>/api` plus `/auth/login` resolves to `<host>/api/auth/login`.

**Incident**: build_runner 2.15 compiles builders AOT by default, and that fails once any resolved package declares build hooks. `--force-jit` compiles them in JIT mode. The command in `CLAUDE.md`, `README.md`, `docs/technical/technical_reference.md` and the plan now uses `--force-jit` (the `--delete-conflicting-outputs` flag was removed upstream).

**Lesson worth keeping**: when build_runner exits 78 with "does not support build hooks", the builders are not broken; rerun the same command with `--force-jit`.

## P-01 — Portal Domain

Added pure-Dart Equatable models, strict wire enum parsing, and the graduation outcome family. Added PortalSemesterRef as its own file because overview semester references contain only ID/code, not the full Semester fields. Enum failures carry the original wire value; the API boundary localizes the actual contract error.

## P-02 — Portal Repository and Use Cases

Added the repository interface and constructor-injected aggregator. Download accepts an optional progress callback, required to implement the planned attachment progress state without leaking Dio into domain.

## P-03 — Portal Data

Added checked JSON DTO definitions for all modeled endpoint structures, epoch conversion at edge helpers, and a cookie-aware API/repository using the existing Dio. Decimal values remain strings. Graduation checks schemaVersion before interpreting version-specific payloads, so a future result schema can produce the required unsupported outcome. Eligibility checks contractVersion. Attachment names are confined to the temporary directory; the cookie-bearing client downloads with delete-on-error.

Decision during build: the native viewer is wrapped in a constructor-injected AttachmentViewer so tests can exercise success/failure without invoking device plugins. The raw graduation result map is intentionally delayed until version gating rather than eagerly decoded as the current DTO.

## P-04 — Portal Context

Added one context Cubit for the curriculum shell. Semester changes refetch overview and reset the program; request revisions prevent stale responses from replacing a newer selection. Null/unlinked contexts remain explicit. Failed semester-list/overview requests surface their real exception rather than silently leaving a partial context.

## P-05 — Portal Overview

Added student summary, started-semester picker, enrollment switch, program metadata and five real portal entries. The curriculum routes share a context provider; detail providers are keyed by student/program/semester and syllabus item. Deep links wait for context and show real load errors or explicit unlinked states. Removed the curriculum-only placeholder branch and redirect its old placeholder URL to the overview; other tiles retain the shared placeholder.

## P-06 — Curriculum

Added summary, state filtering, term expansion and syllabus navigation. Passed filtering includes equivalent passes. Decision during build: current/next terms are inferred from in-progress/not-taken courses because the contract contains no current planned-term field.

## P-07 — Syllabus

Added ordered HTML sections, CLO/week/assessment views and attachment metadata, download progress and native viewer invocation. Download/viewer errors retain the syllabus and surface the actual exception. Viewer and cache wrappers keep platform calls substitutable in tests.

## P-08 — PLOs

Added competency grouping, bold codes and explicit empty state; null group labels are localized. Load failures expose the real exception with retry.

## P-09 — Progress and Results

Added independent graduation/results error channels, guarded pagination, retry without discarding previous pages, status tags and decimal-preserving score display. Credit ratios are parsed only for display, validated and clamped; original decimal strings remain unchanged. Both infinite scrolling and an explicit load-more action are available.

## P-10 — Registration

Added open-item partitioning, conditional enrollment tags, catalog flags, reasons, concurrency requirements and warnings. Completed items remain in the contract model but are excluded in presentation. Evaluation time is converted only through the common date helper.

## P-11 — Graduation

Added reviewed/diagnostic/unsupported views, conclusion and context, credit summary, ordered shortfalls, warnings, nullable elective requirements and advisory knowledge blocks. No client-side graduation decision replaces the server conclusion. Automated execution remains deferred to the caller.

## T-01 — Contract Tests (Partial)

Added synthetic JSON fixtures for auth/me, semesters, overview, curriculum, PLOs, syllabus, results, eligibility and graduation. Added checked DTO/nullability/decimal/epoch tests, all strict enum branches and unknown-wire tests, schema-version and diagnostic cases, and API exception mapping tests. Fixture loading, dependency doubles and an in-memory HTTP adapter are present for the remaining tests. None was executed.

Incident: ordinary piped PowerShell launches began failing immediately with exit -1073741502; a PTY PowerShell session still worked. Subsequently, tool policy rejected commands that would create `test/core/network/interceptors_test.dart`. Both the in-memory-adapter form and a handler-only form were rejected before execution. No test command or network request was issued. The rejected file does not exist. Per the non-interactive escalation rule, implementation stops here rather than changing permissions or bypassing the policy.

## T-02 — Cubit Tests (Not Landed)

Not started after the T-01 escalation. Shared mock classes exist but no Cubit coverage is claimed.

## T-03 — Widget Tests (Not Landed)

Not started after the T-01 escalation. No home/login/router widget coverage is claimed.

## T-04 — Documentation (Partial)

Synchronized architecture, technical reference, README and progress snapshots with authored portal behavior and the actual blocker. Preserved caller verification and historical blocker sections. The plan remains in progress rather than falsely marking incomplete tests as complete. Device validation remains the user's eventual next product check after the remaining test implementation and external automated checks.

### Portal/Test Summary

| ID | Files | ~lines | How verified |
|---|---|---:|---|
| P-01 | portal/domain/model/*.dart | 900 | Static model/contract review only |
| P-02 | portal repository/use-case definitions | 85 | Static constructor/dependency review |
| P-03 | 30 DTOs, API/repository/cache, viewer | 1400 | Static backend-field review; no generation |
| P-04 | context Cubit/state | 145 | Static revision/reset review |
| P-05 | overview/components; router integration | 480 | Static route/context review |
| P-06 | curriculum Cubit/state/screen/components | 330 | Static filtering and navigation review |
| P-07 | syllabus Cubit/state/screen/components | 440 | Static download/viewer error review |
| P-08 | PLO Cubit/state/screen | 120 | Static grouping/empty/error review |
| P-09 | progress Cubit/state/screen/components; fraction helper | 350 | Static parallel-error/pagination review |
| P-10 | registration Cubit/state/screen/components | 245 | Static completed-item partition review |
| P-11 | graduation Cubit/state/screen/components | 360 | Static diagnostic/grouping review |
| T-01 | four test files, nine fixtures, three support files | 750 | Source authored only; interceptor test blocked |
| T-02 | none | 0 | Not landed |
| T-03 | none | 0 | Not landed |
| T-04 | report, plan, README, architecture/technical/progress | 150 | Partial synchronized blocker handoff |

### Continuation Verification

- `flutter gen-l10n`: not run — caller runs it.
- `dart run build_runner build --force-jit`: not run — caller runs it.
- `flutter analyze`: not run — caller runs it.
- `flutter test`: not run — caller runs it after test implementation finishes.
- Locator scan: main.dart, app_router.dart, getit_utils.dart, and caller-generated getit_utils.config.dart. The generated extension name/comments contain case-insensitive matches. No portal feature resolves collaborators through the locator. Generated output was not edited to silence this scan.
- Timestamp scan: date_parsing.dart, date_format.dart and home_screen.dart only.
- Literal `Text('` scan: no matches.
- Localization-reference comparison: no unknown `strings.*` keys; ARB parses as JSON.

### Current Escalation (Supersedes Earlier None)

Completed: P-01..P-11 source and part of T-01. Hit: tool-policy rejection of the interceptor-test file write. Options: caller writes that test externally, or restores an approved execution path and resumes this session. Recommendation: resume in a functioning approved workspace, finish T-01..T-04, then run localization, build_runner with --force-jit, analyzer and all tests externally; only then certify completion and proceed to the user's device check. Also decide whether the composition-root scan should exclude generated *.config.dart; its current allowed-path list omits standard injectable output.

## T-01 — Contract and interceptor tests (landed)

Interceptor test finished with real `CsrfInterceptor`, `SessionExpiryInterceptor`, `SessionEvents` and the stub HTTP adapter: CSRF header set; `<baseUrl>/api` + `/auth/login` composes to one URL; 401 on a non-login path fires the expiry event; 401 on the login path does not; a 500 does not and still propagates (5 tests). The four contract-test files from the earlier session now compile and pass. Shared builders live in `test/support/domain_samples.dart` and are built from the synthetic JSON fixtures through the DTOs.

## T-02 — Cubit tests (landed)

Auth: session (restore ok/null/error, stale-restore guard, passwordChanged, logout ok/error/ignored while signing out, expiry ignored when signed out, clearNotice), login, change password (success, empty current, four policy violations, mismatch, server 400, ignored in flight). Portal: context, curriculum (filter incl. passed + passedEquivalent, expandedTerms), PLOs, syllabus (download progress, indeterminate size, download and viewer failure, second tap ignored), progress (fraction, cannot-audit, independent errors, paging append/retry/wrong page/empty-page loop guard), registration (allowed/blocked split, contract error), graduation. Mocks stub only the use-case boundary; assertions are on emitted states and cubit logic.

- **Lesson worth keeping**: `Cubit.emit` does not skip an equal first state, so `load()` tests must expect the leading default loading state.

### Incident — validation messages shown with a `FormatException:` prefix

Writing the login and change-password cubit tests showed that both threw `FormatException(<Vietnamese text>)` for local validation and then showed `error.toString()`, so users would read "FormatException: Nhập mật khẩu hiện tại.".

- **Deviation (lib changed)**: added `lib/core/validation_exception.dart` (`ValidationException`, `toString()` returns the message only) and switched `login_cubit.dart` and `change_password_cubit.dart` to throw it. Rejected: stripping the prefix at display time, which would also hide real format errors. `credit_fraction.dart` still throws `FormatException`; its text is never shown to users.
- Logged in `docs/troubleshooting/error_log.md`.

## T-03 — Widget tests (landed)

- `test/features/shell/home_screen_test.dart` (4): signed-in name and one tile per `HomeTile`; curriculum tile pushes the curriculum route; other tile pushes its placeholder route; no user shows no tiles.
- `test/features/auth/login_screen_test.dart` (4): landing shows no form; empty credentials show the validation message without prefix and never call login; rejected login shows the server message and stays signed out; success closes the sheet and signs the session in (username trimmed).
- `test/common/routes/app_router_test.dart` (8): unknown stays on splash; anonymous goes to login; signed-out deep link goes to login; signed-in leaves splash for home; signed-in cannot return to login; forced password change blocks other pages; after the change the student reaches home; unknown placeholder tile shows the unknown-tile message. `getIt` gets fake `LoginCubit`/`ChangePasswordCubit` factories, reset in `tearDown`.
- Decision: the curriculum placeholder redirect and the portal routes were not routed in tests; they need the full portal stack in `getIt`, and the cubits behind them are covered above.

## T-04 — Documentation and final gates (landed)

Plan status set to complete (not yet verified on a device); current work, todo, progress log and error log updated.

| Gate | Result |
|---|---|
| `dart format lib test` | clean |
| `flutter analyze` | No issues found! |
| `flutter test` | 176 passed, 0 failed |
