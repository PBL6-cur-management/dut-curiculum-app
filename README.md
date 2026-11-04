# dDUT Curriculum App

A Vietnamese Flutter client that reproduces the dDUT login and student shell. It runs on the PBL6 curriculum-management API (`E:\PBL6\curriculum-management\source\backend`). The design references contain a real student's name, email and photo, and none of it is bundled. The header shows the signed-in user's own data and initials.

## Test account

| Username | Password | Student code | Notes |
|---|---|---|---|
| `demo.sinhvien` | `demo` | `DEMOSV001` | Synthetic student. No forced password change. Every name and score is generated |

- The backend command `pnpm db:demo-student` creates the account. It is not part of the normal seed. Run it once per database, and again after a rebuild or restore.
- Re-running it resets the account's enrolment, results and password.
- The student is enrolled like a real student of the same programme: the default is programme `CNTT`, the largest cohort, with at least 4 started terms. Override this with `DEMO_STUDENT_PROGRAM_CODE` / `DEMO_STUDENT_COHORT_CODE` in the backend environment. `DEMO_STUDENT_USERNAME` / `DEMO_STUDENT_PASSWORD` change the credentials.
- The public demo server (`ctdt.oguri-lab.io.vn`) has **not** been given this account yet. Use a local backend until it is.
- Staff accounts (admin, lecturers) work on the web app, not here. This app is for students.

## Run it

### 1. Backend (in `curriculum-management/source/backend`)

```powershell
pnpm install; pnpm dev:setup
pnpm db:demo-student
pnpm dev
```

- `pnpm dev:setup` starts PostgreSQL, Redis and Mailpit in Docker. Compose requires `SCHOOL_DB_SIM_SA_PASSWORD` in the backend environment file, even though that service is unused.
- `DATABASE_URL` must point at a database with real programme data (`ctdt_real`). Without one, `db:demo-student` stops with "Không có đăng ký mẫu phù hợp".
- The API listens on port 3000, prefix `/api`. A phone on Wi-Fi needs Windows Firewall to allow inbound TCP 3000 for Node.

### 2. App (in this folder)

Create the root environment file with one line. It must include `/api`:

| Target | Value |
|---|---|
| Physical phone, same Wi-Fi as the PC | `API_BASE_URL=http://192.168.1.146:3000/api` (the PC's LAN IP; update it if the IP changes) |
| Android emulator, local backend | `API_BASE_URL=http://10.0.2.2:3000/api` |
| Deployed demo | `API_BASE_URL=https://ctdt.oguri-lab.io.vn/api` |

Then:

```powershell
flutter devices
flutter run -d <device-id> --dart-define-from-file=.env
```

- `API_BASE_URL` is compiled into the build. Every launch path must pass `--dart-define-from-file`: the IDE run button, `flutter install` and `flutter build apk` all need it. In VS Code, add `"toolArgs": ["--dart-define-from-file=.env"]` to the launch configuration.
- run with flutter run --dart-define-from-file=.env     
- After you change the value, stop the app and run it again. Hot reload does not pick it up.
- Android allows plain HTTP only to `10.0.2.2`, `localhost` and `192.168.1.146` (`android/app/src/main/res/xml/network_security_config.xml`). A different LAN IP must be added there.

## What to test

Log in as `demo.sinhvien`, then walk through:

- **Session**: log in; kill and reopen the app (the session should be restored); log out. The backend session expires after 60 idle minutes and the app returns to login.
- **Password**: the profile has no change-password entry. The change-password screen appears only for an account the backend flags as needing a new password at first login.
- **Home / profile**: header, tiles and profile data. Tiles other than curriculum are placeholders by design.
- **Curriculum** (first tile): switch semester and programme; curriculum and syllabi (open an attachment); PLOs; progress and results; registration eligibility; graduation review.

There is no timetable, fee or class data. The backend has none, and the app does not invent it.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Error screen "Thiếu API_BASE_URL…" | The build was launched without the define file | Run with `--dart-define-from-file=.env` (see above) |
| Login waits up to 15 s, then "Không kết nối được máy chủ…" | The phone can't reach the backend | Backend running? Same Wi-Fi? Firewall rule for port 3000? IP allowed in `network_security_config.xml`? |
| "Tên đăng nhập hoặc mật khẩu không đúng." with the demo account | The account is missing on that server | Run `pnpm db:demo-student` against the backend's database |
| Curriculum, eligibility and graduation say "Ảnh chụp khung chương trình chưa đầy đủ…" | Released programme versions have no frozen course name/credits. Databases restored from a dump taken before 2026-10-31 23:26 (+07) have this problem | Rebuild with `pnpm db:rebuild:real --yes`, or backfill: see `curriculum-management/docs/troubleshooting/error_log.md`, entry dated 2026-11-01 |

More diagnosed problems are in `docs/troubleshooting/error_log.md`.

## Development

Run these after changing ARB strings, DTOs or injectable classes:

```powershell
flutter gen-l10n
dart run build_runner build --force-jit
flutter analyze
flutter test
```

- `build_runner` needs `--force-jit`. Plain `dart run build_runner build` fails with "'dart compile' does not support build hooks".
- Generated files (`lib/l10n/app_localizations*.dart`, `*.g.dart`, `*.config.dart`) are never edited by hand.
- Tests use fixtures under `test/fixtures/` and stubbed HTTP; they never call a backend.

## Architecture and working rules

See `CLAUDE.md`, `.claude/rules/flutter-rules.md`, `docs/architecture/` and `docs/implementation/f-28-ddut-replica-curriculum-app-implementation-plan.md`. Features are split into domain, data and presentation layers, with Cubit + Equatable, constructor injection, checked DTOs and Vietnamese gen-l10n strings. Cookies persist in application-support storage and respect expiry. Real error messages reach state and are shown in the UI.

Status: code and automated tests are complete (`flutter analyze` clean, `flutter test` 177/177). The device walkthrough above has not been signed off; see `docs/progress/current_work.md`.
