# Flutter / Dart — Stack Rules

Pair with `ai_rules.md`. Apply both files together for Flutter projects.

---

## 1. Clean Architecture Layers

Three strict layers. Dependency flow is one-directional:

```
Presentation  →  Domain  ←  Data
```

- **Domain**: models, repository interfaces, use cases. Pure Dart — no platform/framework imports.
- **Data**: repository implementations, DAOs / local storage, remote services, DTOs.
- **Presentation**: UI widgets, Cubits / BLoCs, state classes.

Domain must never import Data or Presentation. Data must never import Presentation. Violations are errors, not warnings.

---

## 2. State Management — BLoC / Cubit

Every screen has: `XxxState`, `XxxCubit` (or `XxxBloc` for event-driven flows), and the screen widget.

```dart
// State — immutable, use Equatable (or freezed)
class XxxState extends Equatable {
  final List<Item> items;
  final bool isLoading;

  const XxxState({this.items = const [], this.isLoading = false});

  @override
  List<Object?> get props => [items, isLoading];
}

// Cubit
class XxxCubit extends Cubit<XxxState> {
  XxxCubit(this._useCase) : super(const XxxState());
  final XxxUseCase _useCase;
}
```

- Use `Cubit` for simple state with method calls.
- Use `Bloc` with explicit `XxxEvent` sealed class only when event mapping adds clarity (e.g., complex branching or external event streams).
- UI observes state via `BlocBuilder` / `BlocListener`. Never access cubit/bloc internals from widgets.
- One-shot side effects (navigation, snackbars) via `BlocListener`.

---

## 3. Package Structure (per feature)

```
lib/
├── common/
│   ├── extensions/
│   ├── routes/
│   ├── utils/
│   └── widgets/          # cross-feature shared widgets
├── core/
│   ├── dao/
│   ├── data/
│   ├── enums/
│   ├── models/
│   ├── repositories/     # abstract interfaces + composite read models
│   └── repository_impl/
├── features/<feature_name>/
│   ├── domain/
│   │   ├── model/        # entities, enums, exceptions
│   │   ├── repository/   # abstract repository interfaces
│   │   └── use_case/     # use cases, grouped in aggregator if needed
│   ├── data/
│   │   ├── local/        # DAOs (sqflite), repository impls, seed
│   │   └── remote/       # HTTP services, DTOs
│   └── presentation/
│       ├── <screen_name>/ # cubit, state, screen widget
│       └── components/    # shared reusable widgets for this feature
└── main.dart
```

---

## 4. Repository Pattern and Use Cases

- Domain defines the interface. Data implements it.
- Presentation never talks to DAOs, services, or storage directly — only through use cases or repository interfaces.
- Each use case does one thing. Group related use cases into an aggregator class injected as one dependency — do not inject individual use cases separately across many call sites.

---

## 5. DI — get_it + injectable

- `@singleton` for singletons (Database, HTTP client, repositories).
- `@preResolve` for async singletons resolved before `runApp()`.
- `@injectable` (factory) for use cases and cubits.
- `@module` abstract classes for third-party bindings.
- Keep `getit_utils.dart` (with `@injectableInit`) as the single registration entry point.
- Run `build_runner` after any DI annotation change.

### Constructor injection, not the service locator

**Every collaborator a class needs is a constructor parameter.** `getIt<T>()` is called only at
the composition root.

| Where | `getIt<T>()` |
|---|---|
| `main.dart`, `app.dart`, `common/routes/` | ✅ this *is* the composition root |
| A widget resolving a `Listenable` or a Cubit for `BlocProvider` | ✅ |
| Cubit, Bloc, repository, repository impl, data source, DAO, service | ❌ never |

Everything in the last row is constructed by `injectable`, so a collaborator only has to be
added to the constructor — the generated factory resolves it and no call site changes.

A locator call inside one of those classes is a **hidden dependency**: it does not appear in the
constructor, so a test cannot substitute it without registering a global singleton, and that
registration leaks into every other test in the file.

The symptom to watch for is a method whose **failure path is tested but whose success path is
not**. That asymmetry is usually not an oversight — it means the success path reaches the
locator and the test could not stub it.

```dart
// ❌ hidden dependency — untestable without a global registration
class RecordHistoryCubit extends Cubit<RecordHistoryState> {
  RecordHistoryCubit(this._repository, @factoryParam this._employeeId);

  Future<void> retryRecord(String clientId) async {
    await _repository.retryFailedRecord(clientId);
    unawaited(getIt<SyncService>().runFullSync());
  }
}

// ✅ declared and substitutable
class RecordHistoryCubit extends Cubit<RecordHistoryState> {
  RecordHistoryCubit(
    this._repository,
    this._syncService,
    @factoryParam this._employeeId,
  );

  Future<void> retryRecord(String clientId) async {
    await _repository.retryFailedRecord(clientId);
    unawaited(_syncService.runFullSync());
  }
}
```

---

## 6. Local Storage — sqflite

- DAOs are plain Dart classes wrapping `sqflite` queries.
- All DAO write methods accept `DatabaseExecutor` to support both standalone and transactional calls.
- Timestamps stored as `INTEGER` (epoch milliseconds).
- Never store `DateTime` directly — convert at the DAO boundary.
- Schema changes require a migration in `onUpgrade`. Never drop and recreate in production.

---

## 7. Naming Conventions

- Files and folders: `snake_case`
- Classes: `PascalCase`
- Cubits/Blocs: `XxxCubit` / `XxxBloc`
- States: `XxxState`
- Use cases: verb-noun (`upsert_task.dart`, class `UpsertTask`)
- Repository interfaces: `XxxRepository` (abstract class)
- Repository implementations: `XxxRepositoryImpl`
- DTOs: `XxxDto` with `fromJson` / `toJson`
- Models: `XxxModel` or plain name with `fromMap` / `toMap`

---

## 8. Widget Rules

- No business logic inside widgets — only display and callback dispatch to cubit.
- Prefer `const` constructors wherever possible.
- Do not pass cubits/blocs down the widget tree — use `BlocProvider` / `context.read<XxxCubit>()`.
- Extract reusable widgets into `presentation/components/` with a single responsibility per widget file.
- State and lambdas are passed down — never pass the Cubit itself into child widgets.
- Side effects via `BlocListener`, not inline in the build method.

---

## 9. Data Conventions

- All date/time values in domain and data layers are epoch milliseconds stored as `int`.
- No `DateTime` objects in domain or data layers.
- Use platform date/time utilities only inside helper/extension functions at the edges (UI formatting, picker input).
- Use enums for any value with a fixed set of options. Never use raw strings for status, type, or category fields that are compared in logic.

---

## 10. Seed and Migration Discipline

- Never break existing schema without a migration.
- Seed data belongs in the data layer, triggered on first install via a DB callback or initializer.
- Document every schema change in `docs/architecture/database_and_models.md`.

---

## 11. Freezed / Equatable Models

- Use `Equatable` for state classes (or `freezed` if enabled).
- Use `freezed` for domain models when `copyWith`, `==`, and `hashCode` are needed.
- Never manually write `copyWith`, `==`, or `hashCode` on models that use `freezed`.
- Run `build_runner` after any model change involving code generation.

---

## 12. Assets and Localization

- Asset paths defined in generated code via `flutter_gen` — never hardcode string paths.
- Localization strings managed via `intl_utils` — never hardcode user-visible strings inline.

---

## 13. Error Handling — No Silent Failures

Every call that can throw must be wrapped in try-catch. The catch block must always surface the error to the user — never swallow it.

**In Cubits / BLoCs:**
- `XxxState` must include an error carrier: `final String? errorMessage` (or a sealed `XxxError` type).
- Emit `errorMessage` derived from the actual exception — never a generic fallback string.
- Never leave state unchanged on failure — the UI must know something went wrong.

```dart
// ✅ correct
try {
  final result = await _useCase.execute(params);
  emit(state.copyWith(data: result, errorMessage: null));
} catch (e) {
  emit(state.copyWith(errorMessage: e.toString()));
}

// ❌ wrong — silent failure
try {
  await _useCase.execute(params);
} catch (_) {}

// ❌ wrong — generic message unrelated to actual error
} catch (e) {
  emit(state.copyWith(errorMessage: 'Something went wrong'));
}
```

**In the UI:**
- Observe `errorMessage` via `BlocListener` and show a `SnackBar` or dialog with the actual content.
- Never hide an error behind a loading spinner that never resolves.
- Never show a static "Error" label — always include what went wrong.

**Disallowed patterns:**
- Empty catch: `catch (e) { }`
- Print-only catch: `catch (e) { print(e); }` with no state emit or user notification
- Catch that only sets `isLoading: false` with no error signal

### Diagnostic logging you read on-device uses `debugPrint`, not `developer.log`

`developer.log` routes to the Dart VM service, which is absent in release/profile and has no
listener from a background isolate — so those lines never reach logcat, exactly where an
on-device push/sync bug lives. `debugPrint` goes through the engine's native logcat bridge (tag
`flutter`) in every build mode and every isolate.

- Any log you intend to read from a physical device — push, background isolate, sync, release
  QA — uses `debugPrint`. Capture with `adb logcat -s flutter`.
- `developer.log` is fine only for debug-session logging read through the IDE/DevTools.
- Pick the transport by *where you read it*, not by which API reads nicer.

---

## 14. UI Component Decomposition — Pure Presentational Widgets

Every screen must decompose its `build()` method into focused widget components. No monolithic `build()` exceeding ~80 lines.

**Component rules:**
- Components live in `features/<feature>/presentation/components/` or `common/widgets/` for cross-feature use.
- A component receives only data and callbacks via its constructor — nothing else.
- Components are pure UI: they render what they receive and call back what the user does.
- Components never access cubits via `context.read<>()` or `BlocProvider.of<>()` — that is the screen widget's responsibility.
- Components never import use cases, repositories, or any domain/data layer code.
- One component file = one widget class with one visual responsibility.

```dart
// ✅ correct — pure component
class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, required this.onTap, super.key});
  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) { ... }
}

// ❌ wrong — component reaching into BLoC
class TaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskCubit>(); // violation
    ...
  }
}
```

**Screen widget responsibility:**
- The screen widget owns `BlocBuilder` / `BlocListener` and extracts state fields.
- It passes extracted values and callbacks down to components.
- If the screen's `build()` grows beyond ~80 lines, extract the next logical section into a component.

---

## 15. No Dead Code

Every class, function, and file must be reachable from the app entry point via the router, DI registration, or a direct import. Do not leave orphaned screens, unused widgets, or commented-out code in the repository.

**Before adding a new screen/route**: confirm the router will wire it before writing any code.
**After merging or replacing a screen**: grep for every import and route reference to the old file, then delete it if nothing references it.

Signs of dead code:
- A public class defined in a file that is never imported outside that file itself
- A screen file that is not referenced in any route definition or DI binding
- A function that is only referenced by a call site that is itself unreachable
