# Curriculum Redesign Implementation Plan

Date: November 3, 2026. **Status: Source/test implementation and narrow documentation authored through CR-13; CR-02/CR-06 generation and all Flutter/runtime/device checks deferred to caller by explicit execution fence. Owner visual approval pending.** See Execution Status and Deviations for actual evidence, remaining validation and per-deliverable status. The contract below retains the approved first-Home-tile curriculum scope and Q1–Q5 defaults. CR-07 was a nonblocking checkpoint, not a stop; no captures or owner approval are claimed.

Companions: `docs/design/screen-content-spec.md` (phone jobs, screenshots and E1–E4), `docs/implementation/f-28-ddut-replica-curriculum-app-implementation-plan.md` (shell boundary), `docs/architecture/features_architecture.md`, and `docs/progress/current_work.md:3` (rejected previous restyle; last recorded 177/177 tests). The web establishes available data, **not a parity target**. All nine permitted images were viewed during the content-spec task; use their layouts, never personal values.

Paths are workspace-relative. `backend/` means `E:/PBL6/curriculum-management/source/backend/src/`; `web/` means `E:/PBL6/curriculum-management/source/frontend/src/`. Files/deliverables below define the approved ownership manifest; the execution record distinguishes authored files from deferred generated output and unperformed verification. Dart blocks define interfaces/layout skeletons; accompanying behavior is mandatory. The plan does not reproduce screenshot identity or grades.

## 0. Plan at a glance

| What | Why | How and where |
|---|---|---|
| Seven academic screens; one academic context | Answer one quick phone question per screen | `lib/features/portal/presentation/**`; CR-04, CR-07–CR-12 |
| New portal composition, not cosmetic tweaks | Owner rejected the previous generic component restyle | Feature-local theme/cards/disclosures plus append-only tokens; CR-03 |
| Curriculum visual slice first | Preserve an early, independently reviewable reference | CR-01–CR-07; capture nonblocking owner checkpoint, then continue through CR-13 |
| Equivalent explanation; response-context and unknown-verdict safety | Prevent misleading academic answers | Explicit small client/state exceptions; CR-05/CR-06, CR-11 |
| Existing infrastructure preserved | UI work is not a shell/backend rewrite | No dependencies/endpoints; no global theme or shell behavior changes |
| Regression, device evidence and synchronized docs | Recorded 177 is a baseline, not a result from this task | Tests owned by each screen; CR-13 aggregate checks, captures and architecture/progress updates |

There are **13 deliverables, CR-01–CR-13**. Feasibility: **47 BUILD NOW / 4 NEEDS BACKEND / 13 DROP**, across 64 T rows grouping recommendations sharing a disposition. No owner question blocks the full build; backend gaps E1–E4 remain explicitly excluded.

## 1. Scope and feasibility

### 1.1 Included

| Surface | Phone question | Deliverable |
|---|---|---|
| Shared context | Which programme and semester am I viewing? | CR-04 |
| Entry/overview | Where is the academic answer I need? | CR-08 |
| Curriculum | What courses remain in my applicable curriculum? | CR-07 |
| Syllabus detail | What will I learn and how am I assessed? | CR-09 |
| PLOs | What capabilities does this programme intend? | CR-10 |
| Progress and results | How far have I progressed; what results explain it? | CR-10 |
| Registration eligibility | Which unfinished courses can I consider, with what conditions? | CR-11 |
| Graduation review | What prevents a positive review right now? | CR-12 |

### 1.2 Not included

| Excluded | Boundary |
|---|---|
| Login, session/password-change UI | No auth contract, widget or redirect redesign |
| Home, including first tile | Keep placement, labels and navigation; feature begins after navigation |
| Profile, notifications, placeholders, bottom nav, shell | No redesign, identity relocation implementation, bells or floating nav |
| Home Results shortcut | No Home wiring/query-parameter feature; Progress defaults to Progress |
| Backend, web, live dDUT integrations | Read-only evidence; E1–E4 stop at the boundary |
| New packages/global theme replacement | Existing dependencies and non-portal consumers stay intact |

`lib/common/routes/app_router.dart` is a narrow integration exception: only portal wrappers/imports, not shell/auth/Home behavior or route paths. AppColors/AppDimens are append-only, not global restyling.

### 1.3 Acceptance mapping

| Requirement from brief/spec | Acceptance evidence | Deliverables |
|---|---|---|
| Identity-free academic content | No biography/cohort/account fields on seven pages | CR-07, CR-08, CR-12, CR-13 |
| One context owner, no editable catalogue version | Switch on a child route; one summary/sheet; no stale answers | CR-04, CR-13 |
| Phone relevance, not web parity | Triage and per-screen contracts below | CR-07–CR-12 |
| dDUT course/KPI hierarchy | CR-07 checkpoint capture plus final per-screen captures for later owner review | CR-03, CR-07, CR-13 |
| Correct equivalence and unknown eligibility | DTO/state/widget regressions | CR-05–CR-07, CR-11 |
| Honest empty/partial/unsupported/CANNOT_AUDIT | §7 matrix, no fabricated totals/statuses | CR-04, CR-09–CR-13 |
| No regression outside scope | Original 177 cases retained, new cases added, analyze clean | CR-13 |

### 1.4 Feasibility triage

BUILD NOW means existing client models **or existing called endpoints** suffice; permitted client/state exceptions are explicit deliverables. NEEDS BACKEND stops without contract design. DROP intentionally omits supported but low-value details. Layout rows cite the client receiving the change, not an imaginary API field.

| Spec item | Class | Evidence | Note |
|---|---|---|---|
| T01 — §1.1 shared context summary and edit sheet | BUILD NOW | `lib/features/portal/presentation/context/portal_context_state.dart:8`; `lib/common/routes/app_router.dart:152` | CR-04; one existing cubit owner. |
| T02 — programme code/name/type, semester, derived version/decision | BUILD NOW | `lib/features/portal/domain/model/portal_program.dart:14`; `lib/features/portal/domain/model/portal_overview.dart:14` | One programme is text; decision in disclosure. |
| T03 — primary-first options, dated semesters including future dates | BUILD NOW | `lib/features/portal/data/portal_repository_impl.dart:23`; `lib/features/portal/domain/model/semester.dart:13` | Preserve supplied ordering; known dates are not necessarily started. |
| T04 — retain programme across semester change if still valid | DROP | `lib/features/portal/presentation/context/portal_context_cubit.dart:18` | Small convenience does not justify changing tested reset-to-first semantics in a visual build. |
| T05 — keyed routes, suspended old answers, safe syllabus context switch | BUILD NOW | `lib/common/routes/app_router.dart:164`; `lib/common/routes/app_router.dart:177` | Preserve ValueKeys; context edit leaves old syllabus item. |
| T06 — no identity in academic content | BUILD NOW | `lib/features/portal/presentation/overview/portal_overview_screen.dart:70`; `lib/features/portal/presentation/graduation/graduation_screen.dart:86` | Remove copies only; no Profile/Home edits. |
| T07 — loading, missing student/semester/programme, retry/back gates | BUILD NOW | `lib/features/portal/domain/model/portal_overview.dart:13`; `lib/features/portal/presentation/context/portal_context_state.dart:31` | Missing programme means unresolved applicability, not proven non-enrollment. |
| T08 — unsupported/incomplete snapshot/CANNOT_AUDIT safety | BUILD NOW | `lib/features/portal/domain/model/graduation_outcome.dart:3`; `lib/features/portal/data/remote/dto/registration_eligibility_dto.dart:30` | Keep diagnostics distinct from negative conclusions. |
| T09 — explain each programme omitted by resolver | NEEDS BACKEND | Spec E3, `docs/design/screen-content-spec.md:619` | Stop; generic gate, no diagnostic field design. |
| T10 — entry context then five icon/label destinations with hints | BUILD NOW | `lib/features/portal/presentation/overview/portal_overview_screen.dart:106`; `lib/common/routes/route_paths.dart:12` | CR-08; no transcript/KPI wall. |
| T11 — entry biography/IDs/expanded issuing metadata | DROP | `lib/features/portal/presentation/overview/portal_overview_screen.dart:70` | Identity elsewhere; decision in context disclosure. |
| T12 — curriculum required-credit total | BUILD NOW | `lib/features/portal/domain/model/curriculum.dart:16` | Compact total, not metadata card. |
| T13 — planned terms and compulsory-only credit labels | BUILD NOW | `lib/features/portal/domain/model/curriculum_term.dart:11`; `lib/features/portal/presentation/curriculum/curriculum_state.dart:21` | Preserve ascending server order and unfiltered compulsory totals. |
| T14 — course code/name/credits/state; passed includes equivalent pass | BUILD NOW | `lib/features/portal/domain/model/curriculum_course.dart:22`; `lib/features/portal/presentation/curriculum/curriculum_state.dart:31` | Text plus status, not colour alone. |
| T15 — elective group identity and choose-within-group cue | BUILD NOW | `lib/features/portal/domain/model/curriculum_course.dart:25` | Stable first-seen group order; no invented counts. |
| T16 — one-tap best scores/all supplied scales | BUILD NOW | `lib/features/portal/domain/model/curriculum_course.dart:30` | Null unknown, never zero. |
| T17 — equivalent source identity joined by itemId | BUILD NOW | `lib/features/portal/data/remote/portal_api.dart:84`; `lib/features/portal/data/remote/dto/eligibility_reason_dto.dart:7` | CR-05–CR-07 small client projection; no backend change. |
| T18 — pinned syllabus action or explicit unavailable label | BUILD NOW | `lib/features/portal/domain/model/curriculum_course.dart:21`; `lib/features/portal/domain/model/curriculum_course.dart:33` | Separate from completion details. |
| T19 — current/next expansion heuristic, filters, clear-filter state | BUILD NOW | `lib/features/portal/presentation/curriculum/curriculum_state.dart:37`; `lib/features/portal/presentation/curriculum/curriculum_cubit.dart:33` | Existing heuristic, expansion keyed by context/filter. |
| T20 — full frame without attempts, nonblocking evidence failure | BUILD NOW | `lib/features/portal/domain/model/curriculum.dart:17`; `lib/features/portal/presentation/curriculum/curriculum_cubit.dart:18` | Evidence retry does not replace curriculum/state. |
| T21 — block symbols/repeat count/all scores on collapsed rows/PLO footer | DROP | `lib/features/portal/domain/model/curriculum_course.dart:27`; `lib/features/portal/presentation/curriculum/curriculum_screen.dart:111` | Those tasks belong to named breakdown/attempt history/PLOs. |
| T22 — repeated full programme/version/decision cards | DROP | `lib/features/portal/presentation/components/program_summary_card.dart:8` | Shared context owns applicability. |
| T23 — syllabus course/credits/pinned revision | BUILD NOW | `lib/features/portal/domain/model/syllabus.dart:25` | Compact header, no history wall. |
| T24 — assessment first: code/name/form/weight/narrative | BUILD NOW | `lib/features/portal/domain/model/syllabus.dart:33`; `lib/features/portal/domain/model/syllabus_assessment.dart:4` | Vertical cards, no horizontal DataTable. |
| T25 — course description, outcomes/weeks and assessment-method disclosures | BUILD NOW | `lib/features/portal/domain/model/syllabus.dart:30`; `lib/features/portal/domain/model/syllabus.dart:35` | Assessment-method HTML is one tap away, never expanded by default. No objectives/teaching/reference panels. |
| T26 — document name/type/open/progress/partial error | BUILD NOW | `lib/features/portal/domain/model/syllabus_attachment.dart:4`; `lib/features/portal/presentation/syllabus/syllabus_cubit.dart:41` | Retain authenticated download/cache/opener; no visible byte-size row. |
| T27 — structured conditional-assessment/pass thresholds | NEEDS BACKEND | Spec E1, `docs/design/screen-content-spec.md:617` | Stop; show narrative/documents without completeness claim. |
| T28 — publication timestamps, objectives/teaching/reference panels, file sizes | DROP | `lib/features/portal/domain/model/syllabus.dart:29`; `lib/features/portal/domain/model/syllabus.dart:31`; `lib/features/portal/presentation/components/attachment_tile.dart:30` | These do not change the quick assessment/preparation action, even behind extra disclosures. Issued documents remain available. |
| T29 — PLO code/description preview/expand/optional group, backend order | BUILD NOW | `lib/features/portal/domain/model/plo.dart:10`; `lib/features/portal/presentation/plos/plos_screen.dart:44` | Per-outcome stable expansion, not an all-expanded description list or attainment. |
| T30 — PLO matrices/attainment/approval metadata | DROP | `lib/features/portal/domain/model/plo.dart:3` | Not this read-only phone job; do not invent performance data. |
| T31 — recognized/required/missing credit hero | BUILD NOW | `lib/features/portal/domain/model/graduation_credits.dart:4`; `lib/features/portal/presentation/progress/progress_state.dart:23` | Use server totals, not sums of attempts. |
| T32 — supporting capped percentage; zero denominator N/A | BUILD NOW | `lib/features/portal/presentation/progress/progress_state.dart:28`; `lib/features/portal/domain/model/graduation_credits.dart:4` | Display rule only; totals unchanged. |
| T33 — one-tap compulsory/elective/group/named-block breakdown | BUILD NOW | `lib/features/portal/domain/model/graduation_result.dart:32`; `lib/features/portal/domain/model/graduation_result.dart:35` | Null requirement unspecified; blocks descriptive. |
| T34 — material warnings beside progress | BUILD NOW | `lib/features/portal/domain/model/graduation_result.dart:34` | No diagnostic log/warning wall. |
| T35 — local Progress/Results switch | BUILD NOW | `lib/features/portal/presentation/progress/progress_state.dart:23`; `lib/features/portal/presentation/progress/progress_state.dart:24` | Existing calls unchanged. |
| T36 — actual result semester, code/name, main grade/status | BUILD NOW | `lib/features/portal/domain/model/academic_result.dart:18` | Preserve server newest-first order, not per-page resorting. |
| T37 — one-tap alternate score scales | BUILD NOW | `lib/features/portal/domain/model/academic_result.dart:20` | Letter, otherwise labelled /10 then /4, otherwise unknown. |
| T38 — paging/partial errors preserve loaded history | BUILD NOW | `lib/features/portal/presentation/progress/progress_cubit.dart:79`; `lib/features/portal/presentation/progress/progress_state.dart:31` | Independent history/calculation states. |
| T39 — optional resultSemesterId filter | DROP | `lib/features/portal/data/remote/portal_api.dart:73`; `lib/features/portal/domain/use_case/portal_use_cases.dart:40` | Public calls accept page only; recent-first paging suffices; avoid another picker. |
| T40 — history may contain courses not credited to programme | BUILD NOW | `lib/features/portal/domain/model/academic_result.dart:18`; `lib/features/portal/data/remote/portal_api.dart:75` | Short scope note; do not infer credits. |
| T41 — GPA/conduct/charts/live registrations/windows/limits/actions | NEEDS BACKEND | Spec E2, `docs/design/screen-content-spec.md:618` | Stop; hierarchy only, no unsupported metrics/transactions. |
| T42 — progress verdict/revision log/zero-credit counters | DROP | `lib/features/portal/domain/model/graduation_result.dart:31` | Verdict belongs to Graduation; condition courses stay in course/shortfall detail. |
| T43 — advice-only limitation | BUILD NOW | `lib/features/portal/presentation/registration/registration_screen.dart:20` | Explicit new copy; no enrolment controls. |
| T44 — allowed/conditional vs blocked tabs/statuses/unfinished counts | BUILD NOW | `lib/features/portal/domain/model/eligibility_item.dart:25`; `lib/features/portal/presentation/registration/registration_state.dart:18` | Tighten allowed getter explicitly. |
| T45 — unfinished null verdict unknown, never allowed | BUILD NOW | `lib/features/portal/presentation/registration/registration_screen.dart:88` | Separate unknown list, no third main tab. |
| T46 — advice course/credits/planned term/reason/concurrent courses | BUILD NOW | `lib/features/portal/domain/model/eligibility_item.dart:20`; `lib/features/portal/domain/model/eligibility_item.dart:28` | First important reason collapsed; all messages on tap. |
| T47 — full reason messages and affected-course catalogue/warnings | BUILD NOW | `lib/features/portal/domain/model/eligibility_report.dart:4`; `lib/features/portal/domain/model/eligibility_item.dart:23` | Match warnings by course ID. |
| T48 — extra structured threshold/relation/evidence panels | DROP | `lib/features/portal/data/remote/dto/eligibility_reason_dto.dart:12` | Complete server messages already explain conditions; duplicate panels add little. T17 is the justified identity exception. |
| T49 — completed candidates/repeated semester/timestamp hero | DROP | `lib/features/portal/presentation/registration/registration_screen.dart:55`; `lib/features/portal/domain/model/eligibility_item.dart:25` | Context labels semester; completed items are not candidates. |
| T50 — complete prerequisite/downstream graph | NEEDS BACKEND | Spec E4, `docs/design/screen-content-spec.md:620` | Stop; evaluated reasons are not an authoritative full graph. |
| T51 — empty category/all completed/incomplete snapshot/partial warnings | BUILD NOW | `lib/features/portal/presentation/registration/registration_state.dart:14`; `lib/features/portal/domain/model/eligibility_report.dart:4` | All completed does not mean graduation approved. |
| T52 — graduation conclusion/limitation first | BUILD NOW | `lib/features/portal/domain/model/graduation_result.dart:31`; `lib/features/portal/presentation/graduation/graduation_screen.dart:80`; `lib/l10n/app_vi.arb:70` | Disclaimer already exists; reposition/restyle, no duplicate key. |
| T53 — grouped shortfalls/exact titles/messages | BUILD NOW | `lib/features/portal/domain/model/graduation_result.dart:33`; `lib/features/portal/presentation/components/shortfall_group.dart:7` | Server criteria, no local pass engine. |
| T54 — material review warnings/explicit no-shortfalls result | BUILD NOW | `lib/features/portal/domain/model/graduation_result.dart:34` | Conclusion authoritative; empty shortfalls alone not eligibility. |
| T55 — evaluation time/version in one-tap basis | BUILD NOW | `lib/features/portal/domain/model/graduation_result.dart:25`; `lib/features/portal/domain/model/graduation_result.dart:29` | Programme/semester already in context. |
| T56 — optional versionSource provenance display | DROP | `lib/features/portal/data/remote/dto/graduation_context_dto.dart:7` | Time/version remain in basis; defer source metadata display only. Response-context validation is separately mandatory T63. |
| T57 — graduation link to Progress breakdown | BUILD NOW | `lib/common/routes/route_paths.dart:16`; `lib/features/portal/domain/model/graduation_result.dart:35` | Ordinary Progress route, no new query contract. |
| T58 — cohort/all groups/blocks/recognition/free ledgers/advisory gaps in audit | DROP | `lib/features/portal/presentation/graduation/graduation_screen.dart:86`; `lib/features/portal/presentation/graduation/graduation_screen.dart:124` | Purposeful breakdown in Progress; desktop ledgers omitted. |
| T59 — CANNOT_AUDIT/unsupported distinct from ineligible | BUILD NOW | `lib/features/portal/presentation/graduation/graduation_screen.dart:49` | No stale conclusion/credit hero behind diagnostic. |
| T60 — blue toolbar/pale summary/grey course cards | BUILD NOW | `lib/features/portal/presentation/components/course_row.dart:8`; `lib/common/theme/app_colors.dart:3` | CR-03 concrete tokens. |
| T61 — text badges/disclosures/touch targets/scalable layout | BUILD NOW | `lib/features/portal/presentation/components/course_state_chip.dart:4`; `lib/features/portal/presentation/components/term_section.dart:5` | No fixed heights clipping text. |
| T62 — screenshot bells/utility pills/activities/search UI | DROP | `lib/features/portal/presentation/overview/portal_overview_screen.dart:26` | Shell/unsupported functions excluded; transferable card grammar only. |
| T63 — validate returned graduation context before exposing reviewed data | BUILD NOW | `lib/features/portal/data/remote/portal_api.dart:91`; `lib/features/portal/data/remote/dto/graduation_outcome_dto.dart:28`; `backend/features/graduation/graduation.dto.ts:39` | Existing response includes student/programme/semester IDs. CR-05 validates them at the client boundary; route keys alone do not validate payloads. Applies to Progress and Graduation. |
| T64 — compact recognized/required/missing credit line at total-credit shortfall | BUILD NOW | `lib/features/portal/domain/model/graduation_credits.dart:13`; `lib/features/portal/domain/model/shortfall_category.dart:7` | CR-12 uses supplied totals only when a totalCredits shortfall exists; detailed accounting stays in Progress. |

All curriculum-relevant must-show, must-not-show, context/state and layout recommendations are covered above; closely related exclusions share rows. Other spec screens contribute only curriculum boundaries. T04/T39/T48/T56 are deliberate value/scope reductions, not backend escalations or spec factual corrections.

## 2. Contract verification

### 2.1 Existing reads, unchanged contracts

| Read | Actual caller / backend evidence | Build behavior |
|---|---|---|
| `GET /semesters`, `GET /portal/me?semesterId` | `lib/features/portal/data/remote/portal_api.dart:38`, `lib/features/portal/data/remote/portal_api.dart:45`; `backend/features/student-portal/student-portal.controller.ts:32` | Same context load/switch; nullable link/semester and empty programmes are meaningful. |
| `GET /portal/curriculum` | `lib/features/portal/data/remote/portal_api.dart:51`; `backend/features/student-portal/student-portal.controller.ts:43` | Same context query; no newest-catalogue fallback. |
| `GET /portal/plos` | `lib/features/portal/data/remote/portal_api.dart:57`; `backend/features/student-portal/student-portal.controller.ts:54` | Preserve supplied order/group labels. |
| Syllabus and attachment file under `/portal/curriculum-items/:itemId/syllabus` | `lib/features/portal/data/remote/portal_api.dart:67`, `lib/features/portal/data/remote/portal_api.dart:97`; `backend/features/student-portal/student-portal.controller.ts:65`, `backend/features/student-portal/student-portal.controller.ts:79` | Pinned item, authorization, cache/opener/progress unchanged. |
| `GET /students/:id/results` | `lib/features/portal/data/remote/portal_api.dart:73`; `backend/features/students/students-read.service.ts:183` | Context + page/pageSize only in client; cutoff by selected semester start; newest semester first; not limited to programme recognition. |
| `GET /students/:id/registration-eligibility` | `lib/features/portal/data/remote/portal_api.dart:84`; `backend/features/registration-eligibility/registration-eligibility.controller.ts:17` | Same read for advice and optional equivalent-course evidence, never a mutation. |
| `GET /students/:id/graduation` | `lib/features/portal/data/remote/portal_api.dart:91`; `lib/features/portal/data/remote/dto/graduation_outcome_dto.dart:12` | Preserve version gate and exclusive reviewed/diagnostic outcomes; validate reviewed response IDs before returning data to either consumer (CR-05). |

Repository/use-case/API signatures remain unchanged. `startedSemesters()` actually filters non-null dates, not dates before now (`lib/features/portal/data/portal_repository_impl.dart:23`). Do not change that behavior. `ProgressCubit.load()` already fetches audit/history independently (`lib/features/portal/presentation/progress/progress_cubit.dart:20`); switching tabs must not discard or refetch them.

### 2.2 Full field audit of the extended DTO chain

The only wire projection extended is existing eligibility reasons. Source: `backend/features/registration-eligibility/dto/registration-eligibility.dto.ts:18`, `backend/features/registration-eligibility/dto/registration-eligibility.dto.ts:28`, `backend/features/registration-eligibility/dto/registration-eligibility.dto.ts:71`. Backend line references in this table refer to that file. Include unchanged/unmapped properties to prevent accidental schema replacement.

| DTO / every wire field | Wire type / line | Flutter destination / action |
|---|---|---|
| CourseRef: `id`, `courseCode`, `courseName` | required strings, lines 19–21 | Existing `CourseRefDto` -> `CourseRef.id/code/name`, unchanged (`lib/features/portal/data/remote/dto/course_ref_dto.dart:7`). |
| CourseRef: `nameSource` | required SNAPSHOT/CATALOG, line 26 | Remain unmapped; no phone value. |
| Reason: `code` | required reason-code string, line 33 | NEW optional `String? code` on client DTO for backward-compatible synthetic fixtures; exact `EQUIVALENT_COMPLETED` check. Unknown codes retain message. |
| Reason: `message` | required string, line 36 | Existing required String and domain message list retained. |
| Reason: `evidenceCourse` | CourseRef or null, line 47 | NEW optional `CourseRefDto?`; first matching non-null equivalent evidence -> optional domain `equivalentCourse`. |
| Reason: `causeCode`, `relationType` | nullable codes, lines 35/41 | Remain unmapped (T48). |
| Reason: `requiredCourse`, `viaCourse` | nullable CourseRef, lines 43/45 | Remain unmapped; complete human message still available. |
| Reason: `evidenceResultId`, `requiredScore4`, `actualScore4`, `actualStatus` | nullable strings/enums, lines 48–57 | Remain unmapped; no private result IDs/duplicate threshold panels. |
| Reason: `path` | required CourseRef array, line 59 | Remain unmapped; not an authoritative full graph. |
| Item: `itemId`, `course`, `credits`, `catalogStatus`, `plannedSemester` | string, CourseRef, decimal string, enum, number, lines 72–78 | Existing fields unchanged (`lib/features/portal/data/remote/dto/eligibility_item_dto.dart:28`); join by itemId, never name. |
| Item: `completed`, `eligibility`, `statusText` | boolean, nullable enum, string, lines 79–82 | Preserve; null is not eligible. |
| Item: `reasons`, `requiredConcurrentCourses` | required arrays, lines 84/86 | Existing message/CourseRef lists preserved; add only derived optional equivalentCourse (`lib/features/portal/data/remote/dto/eligibility_item_dto.dart:50`). |

`EligibilityItem.equivalentCourse` is **not a new backend field**. Add it to Equatable props with an optional constructor default. Evaluator `backend/shared/registration-eligibility/eligibility-evaluator.ts:160` emits completed records with null eligibility and selects same/equivalent reason at `backend/shared/registration-eligibility/eligibility-evaluator.ts:169`. Keep those records in the domain report for Curriculum even though advice hides them.

### 2.3 Mismatch log

| Item | Tempting assumption | Verified source / resolution |
|---|---|---|
| CR-12 / spec violation | No live/not-official limitation exists | It already renders `graduationInfo` as a section heading (`lib/features/portal/presentation/graduation/graduation_screen.dart:80`; `lib/l10n/app_vi.arb:70`). Correct that false spec claim only; improve hierarchy. |
| CR-04 | Dated means started-only | Repository includes future dates; preserve behavior, use truthful labels. |
| CR-10 | Results-semester filter already exists in client calls | Public signatures accept page only; DROP optional filter, no multi-layer expansion. |
| CR-11 | Null unfinished verdict is safe to recommend | `lib/features/portal/presentation/registration/registration_state.dart:18` currently admits it; explicitly correct getter. |
| CR-05 / T56 | Keyed routes prove the returned payload matches the request | They only isolate widget/provider lifetime. Existing backend context IDs (`backend/features/graduation/graduation.dto.ts:39`) must separately match the requested student/programme/semester; API boundary rejects a mismatch. |

## 3. Decisions

| ID | Decision | Why | Rejected alternative |
|---|---|---|---|
| D1 | Feature-local visual layer, append-only common tokens | Curriculum-only scope | Replacing global theme/cards would restyle shell/login. |
| D2 | One existing context cubit; one visible summary/edit sheet | Consistent owner, no drift | New context cubit or per-screen selector forms. |
| D3 | Preserve reset-to-first after semester switch | Established tested semantics | Retain-if-valid convenience during visual build. |
| D4 | Visible read-only version in shared summary; decision in sheet; no identity | Entry immediately answers applicability | Hiding version in the sheet or adding full programme/student cards. |
| D5 | Grey course cards, centered blue toolbar, job-specific summary | Real dDUT hierarchy | Another small radius/colour tweak to rejected composition. |
| D6 | Separate completion details and syllabus actions | Explanation reachable without syllabus | Whole row opens only syllabus. |
| D7 | Equivalent evidence fetched only on demand via existing read | Useful explanation, nonblocking | New endpoint, guessing from grade, eager advice request every visit. |
| D8 | Local Progress/Results switch; no semester filter/Home shortcut | Phone simplicity and scope | Desktop transcript filters or shell edits. |
| D9 | Two advice tabs plus separate unknown list | Preserve conditional/blocked/unknown semantics | Fake Registered tab, null-to-green fallback. |
| D10 | Full server reason messages, no duplicate structured threshold panels | Existing model answers conditions | Map every backend field for web parity. |
| D11 | Review conclusion/limitation/shortfalls with conditional compact credit support; breakdown in Progress | Different jobs, without losing credit-shortfall context | Full accounting below verdict or omitting relevant compact totals. |
| D12 | Compile/testable Curriculum slice and nonblocking review checkpoint, then complete all screens | Owner explicitly chose uninterrupted build with final visual review | Waiting for approval after CR-07. |
| D13 | Preserve all existing palette constants; append only two sampled surfaces; keep formatters/semantic mappings | Owner expressly permits missing dDUT colours as named additions | Replacing existing palette, duplicating brand, grade cutoffs, floating-point sums. |
| D14 | Validate returned reviewed IDs against the exact requested context in PortalApi | Route identity and payload correctness are separate guarantees | Showing a mismatched verdict or inventing backend fields. |

## 4. Deliberate differences and visual contract

The web's expanded metadata, all-term expansion, PLO footer, assessment table and full audit ledgers are not mirrored (`web/features/student-portal/pages/PortalCurriculumPage.tsx:92`, `web/features/student-portal/pages/PortalCurriculumPage.tsx:129`). Useful details are one tap away; phone page jobs stay separate. T04/T39/T48/T56 are intentional spec reductions, not factual corrections. Whole-screen Curriculum/syllabus/PLO/graduation compositions have **no dDUT reference**; they borrow the following measured primitives.

### 4.1 Reference application map

| Image in `design/` | Transfer / boundary |
|---|---|
| `20261101-163230.jpg` | Login hero: no curriculum transfer; login untouched. |
| `20261101-163250.jpg` | Rounded overview grouping/outer spacing, not identity/tiles/nav. |
| `20261101-163257.jpg` | Same spacing continuation, not shell feature grid. |
| `20261101-163303.jpg` | Blue toolbar/two-tab hierarchy/course state pill; no registered data/actions. |
| `20261101-163309.jpg` | Horizontal pale-blue credit KPI hierarchy, no GPA/conduct charts. |
| `20261102-223735.jpg` | Two-tab eligibility empty state, single message and open whitespace. |
| `20261102-223809.jpg` | Small status pill and separated course facts. |
| `20261102-223814.jpg` | Main course grammar: muted code/credits, blue title, readable dependency detail. |
| `20261102-223821.jpg` | White-on-pale grouped cards only; no activities/search/rewards feature. |

### 4.2 Measurable style tokens

These are logical-pixel interpretations, not calibrated screenshot px-to-dp measurements. Preserve every existing AppColors/AppDimens constant/value. New geometry is declared only in AppDimens; new colours only in AppColors. No inline hex or numeric layout/text-size literals in widget implementations. FontWeight enum names and arithmetic identities are not magic geometry. The hex samples below are documentation for declarations in AppColors, not permission to put them in widgets.

| Component/token | Concrete build specification | Source |
|---|---|---|
| Page | Child pages `AppColors.surface`; overview/gates may use existing pageBackground; no gradient | from dDUT `20261102-223814.jpg`, `20261102-223821.jpg` |
| Toolbar | Brand background/surface foreground; centered title/back; `portalToolbarHeight=56.0`, `portalIconSize=24.0`; no bell | from dDUT `20261101-163303.jpg`; bell excluded by scope |
| Summary surface | NEW `portalSummarySurface = Color(0xFFE8F1F8)` in AppColors | **sampled from `20261101-163309.jpg`**, also observed in `20261102-223821.jpg` |
| Course surface | NEW `portalCourseSurface = Color(0xFFF6F6F6)` in AppColors | **sampled from `20261102-223814.jpg`** |
| Brand/palette | Use existing brand; sampled toolbar approximately #4072B7 does not merit a near-duplicate constant. Keep all status/login/wordmark constants | from dDUT `20261102-223814.jpg`, `20261101-163230.jpg` |
| Spacing | AppDimens: `portalSpaceXs=4.0`, `portalSpaceSm=8.0`, `portalSpaceMd=12.0`, `portalSpaceLg=16.0`, `portalSpaceXl=24.0`; `portalPageInset=16.0`; card gap12, section gap24 | from dDUT `20261102-223814.jpg`, `20261101-163250.jpg`, `20261101-163257.jpg` |
| Course card | `portalCardRadius=12.0`, padding portalSpaceLg; no shadow/border (`BorderSide.none`); separate cards by portalSpaceMd | from dDUT `20261102-223814.jpg` |
| White grouped card | Same radius/padding; `portalCardElevation=1.0` only on overview groups; `portalFlatElevation=0.0` on course cards | from dDUT `20261102-223821.jpg`, `20261101-163250.jpg` |
| Rows/dividers | `portalMenuRowMinHeight=64.0`, `portalTouchMin=48.0`, `portalCourseMinHeight=104.0`; minimums grow with content; `portalDividerWidth=1.0`, `portalDividerAlpha=0.12` applied to textSecondary, inside white groups only | from dDUT `20261102-223814.jpg`, `20261102-223809.jpg`; minimum targets are accessible adaptations |
| Section header | Brand, left-aligned, `portalSectionSize=16.0` w600; spaceLg above/spaceSm below; no tinted header rectangles | from dDUT `20261102-223814.jpg` |
| Tabs | Two equal widths, min48 (portalTouchMin); body14 w600; selected fill brand/foreground surface; unselected fill surface/foreground textSecondary. Top-only corner radius `portalTabRadius=4.0`, square bottom aligned to shared baseline `portalDividerWidth` in textSecondary at portalDividerAlpha; no selected underline or pill container | from dDUT `20261102-223735.jpg`, `20261101-163303.jpg` |
| Filters | Horizontal scrolling compact chips, min interactive target48; visible inset horizontal12/vertical4; `portalPillRadius=24.0` | from dDUT pill grammar `20261101-163303.jpg`; filters themselves **no dDUT reference** |
| Badges | Caption12 w600, status text (optional existing status icon); semantic fill `portalBadgeAlpha=0.10`; radius24, inset horizontal8/vertical4; optional icon `portalBadgeIconSize=16.0` | from dDUT `20261102-223809.jpg`; never colour alone |
| Type | `portalTitleSize=18.0` w600 toolbar; course/section16 w600 (course brand); `portalBodySize=14.0` w400; `portalCaptionSize=12.0` w400 muted; `portalLineHeight=1.4`; system font. `portalOutcomePreviewLines=2` for collapsed outcome text, unrestricted full text on expand | type from dDUT `20261102-223814.jpg`, `20261101-163303.jpg`; preview length **no dDUT reference** |
| Numbers | `portalKpiSize=32.0` w700 recognized credits left; required/missing14 right; credits12 opposite code; `portalScoreSize=20.0` w700 result grade trailing, scale12; tabular figures | from dDUT `20261101-163309.jpg`, `20261102-223809.jpg`; result score placement **no dDUT reference** |
| KPI | One horizontal pale card, gap16, `portalProgressHeight=4.0`; vertical below `portalKpiBreakpoint=360.0` available width; no duplicate chart | from dDUT `20261101-163309.jpg`; responsive threshold **no dDUT reference** |
| Context/sheet | Compact summary: programme title; semester and read-only applied-version caption below, wrapping as needed, `portalContextMinHeight=64.0` minimum only. Edit affordance; decision details in sheet, `portalSheetRadius=16.0`, inset16; safe-area scroll, no forced fractional height. Null version visibly uses existing noVersion label | summary grammar from dDUT `20261102-223735.jpg`; version line/shared selector sheet **no dDUT reference** |
| States | Icon24/body14/inset16/one retry or context action; no stack of huge empty cards | from dDUT `20261102-223735.jpg` |

All component dimensions above become AppDimens constants, including aliases when reusing an existing value. Use `FontFeature.tabularFigures()` for key values. Rows grow at scaled text; numeric right alignment yields to wrapping, not hiding values. Do not truncate status/conditions or impose screenshot screen dimensions.

### 4.3 Common layer: per-file disposition

KEEP preserves outside consumers; it does not preserve the rejected portal composition. Portal consumers move to the isolated layer.

| File | Disposition | Reason |
|---|---|---|
| `lib/common/theme/app_colors.dart` | KEEP + append CR-03 | Every current constant/value intact; two surfaces added. |
| `lib/common/theme/app_dimens.dart` | KEEP + append CR-03 | Named portal geometry only. |
| `lib/common/theme/app_theme.dart` | KEEP | No global restyle. |
| `lib/common/theme/app_component_theme.dart` | KEEP | Bypassed within portal, not rewritten. |
| `lib/common/widgets/app_card.dart` | KEEP | PortalCard replaces portal consumption only. |
| `lib/common/widgets/app_page.dart` | KEEP | PortalPage replaces portal consumption only. |
| `lib/common/widgets/section_header.dart` | KEEP | PortalSectionHeader inside feature. |
| `lib/common/widgets/status_chip.dart` | KEEP | PortalBadge inside feature. |
| `lib/common/widgets/field_value_row.dart` | KEEP | No repeated metadata rows on portal first views. |
| `lib/common/widgets/error_panel.dart` | KEEP | PortalStatePanel inside feature. |
| `lib/common/widgets/empty_panel.dart` | KEEP | Same isolation. |
| `lib/common/widgets/loading_skeleton.dart` | KEEP | Reusable loader; scoped theme supplies look. |
| `lib/common/widgets/startup_error_app.dart` | KEEP | Out of scope. |

### 4.4 Portal component disposition / caller migration

Paths in the first column are under `lib/features/portal/presentation/components/`; caller paths are under `lib/features/portal/presentation/`. REPLACE means modify implementation in the same file. Keep constructor unless explicitly changed by the owning deliverable.

| File | Disposition / owner | Current caller -> destination |
|---|---|---|
| `student_summary_card.dart` | DELETE CR-08 | overview/portal_overview_screen.dart:70 -> remove biography. |
| `program_switch.dart` | DELETE CR-08 | overview/portal_overview_screen.dart:89 -> CR-04 sheet. |
| `semester_picker.dart` | DELETE CR-08 | overview/portal_overview_screen.dart:78 -> CR-04 sheet. |
| `program_summary_card.dart` | DELETE CR-07 | curriculum/curriculum_screen.dart:53 -> context + total credits. |
| `course_row.dart` | REPLACE CR-07 | curriculum/curriculum_screen.dart:99 -> new course/actions signature. |
| `course_filter_bar.dart` | REPLACE CR-07 | curriculum screen -> retain items/selectedId/onSelected. |
| `term_section.dart` | REPLACE CR-07 | curriculum/curriculum_screen.dart:74 -> retain expansion contract. |
| `course_state_chip.dart` | REPLACE CR-07 | course_row.dart -> delegate PortalBadge, label/color retained. |
| `portal_menu_list.dart` | REPLACE CR-08 | overview/portal_overview_screen.dart:106 -> add icon/hint records. |
| `syllabus_header.dart` | REPLACE CR-09 | syllabus screen -> compact pinned header. |
| `assessment_table.dart` | REPLACE CR-09 | syllabus/syllabus_screen.dart:102 -> same rows, vertical layout. |
| `html_section.dart` | REPLACE CR-09 | syllabus screen -> keep renderer, scoped heading. |
| `clo_list.dart` | REPLACE CR-09 | syllabus/syllabus_screen.dart:85 -> same wrapping records behind learning disclosure; plos/plos_screen.dart:52 moves to PloDescriptionTile in CR-10. |
| `week_list.dart` | REPLACE CR-09 | syllabus/syllabus_screen.dart:96 -> same label/content records. |
| `attachment_tile.dart` | REPLACE CR-09 | syllabus/syllabus_screen.dart:122 -> progress/open/disabled contract retained. |
| `credit_progress_card.dart` | REPLACE CR-10 | progress/progress_screen.dart:65 and graduation/graduation_screen.dart:93 -> KPI; graduation caller removed CR-12. |
| `result_row.dart` | REPLACE CR-10 | progress screen -> AcademicResult/details signature. |
| `elective_group_row.dart` | REPLACE CR-10 | graduation screen -> compatible until CR-12; new Progress disclosure. |
| `knowledge_block_row.dart` | REPLACE CR-10 | graduation screen -> compatible until CR-12; Progress named earned credits only. |
| `eligibility_item_card.dart` | REPLACE CR-11 | registration/registration_screen.dart:89 -> add details callback. |
| `eligibility_chip.dart` | REPLACE CR-11 | eligibility_item_card.dart -> PortalBadge. |
| `conclusion_banner.dart` | REPLACE CR-12 | graduation/graduation_screen.dart:81 -> conclusion, not biography. |
| `shortfall_group.dart` | REPLACE CR-12 | graduation/graduation_screen.dart:108 -> same records, new grouping. |
| `no_context_panel.dart` | REPLACE CR-04 | overview/portal_overview_screen.dart:65 and :87 -> neutral PortalStatePanel. |
| `portal_labels.dart` | KEEP | Existing course/result/eligibility/conclusion mappings remain semantic authority. |

Repeat scoped `rg` for symbol/import before future deletions. If an unexpected caller appears, stop that deletion rather than broadening scope. No common shared function is removed. Existing constructor compatibility protects intermediary builds; breaking signatures have only the callers above.

## 5. Deliverables

Each Files list is exhaustive for that deliverable. Directory creation is permitted during the later build only for listed NEW files. Do not edit domain/data/cubits outside CR-05/CR-07/CR-11. No dependency changes. Keep one Widget class per file; extract each listed panel/sheet rather than hiding multiple widget classes in a screen file. Private build methods are allowed. All user-facing copy uses existing localization keys or the exact CR-01 additions.

### CR-01 — Explicit portal localization source

**Files:** MODIFY `lib/l10n/app_vi.arb` only. Existing language is Vietnamese; document prose remains English. Reuse current keys for course/semester/version/decision/state labels, assessment/outcomes/weeks/documents, credit labels, scores, attempts, loadMore, graduationInfo, shortfalls, warnings, unsupportedResultVersion, retry and noStudentLinked. Do not modify existing key text (it may serve shell/auth).

**Shape:** add the following keys and values; placeholders are all String. Add ARB metadata for every placeholder with that type. No other new l10n keys are permitted without updating this deliverable.

| New key | Exact Vietnamese value |
|---|---|
| `portalContext` | `Ngữ cảnh học tập` |
| `portalChangeContext` | `Đổi chương trình hoặc học kỳ` |
| `portalAppliedCurriculum` | `Chương trình áp dụng` |
| `portalMissingSemester` | `Chưa có học kỳ có ngày bắt đầu để xem. Vui lòng thử lại hoặc liên hệ đơn vị đào tạo.` |
| `portalNoApplicableProgram` | `Chưa xác định được chương trình áp dụng trong học kỳ này. Hãy đổi học kỳ, thử lại hoặc liên hệ đơn vị đào tạo.` |
| `portalCompulsoryCredits` | `{value} TC bắt buộc` |
| `portalNoTerms` | `Chưa có học phần trong phiên bản chương trình này.` |
| `portalNoFilterMatches` | `Không có học phần phù hợp với bộ lọc.` |
| `portalClearFilter` | `Xóa bộ lọc` |
| `portalChooseWithinGroup` | `Chọn học phần trong nhóm này` |
| `portalCourseDetails` | `Chi tiết kết quả học phần` |
| `portalEquivalentFrom` | `Được công nhận qua học phần {course}` |
| `portalEquivalentUnavailable` | `Chưa tải được học phần tương đương. Kết quả công nhận vẫn được giữ nguyên.` |
| `portalEquivalentNotSupplied` | `Chưa có thông tin học phần nguồn trong dữ liệu trả về.` |
| `portalNoIssuedSyllabus` | `Chưa liên kết đề cương đã ban hành` |
| `portalAssessmentNotice` | `Chỉ hiển thị thành phần và mô tả đánh giá được cung cấp. Xem tài liệu ban hành để biết điều kiện đánh giá đầy đủ.` |
| `portalCreditBreakdown` | `Chi tiết tín chỉ` |
| `portalAttemptDetails` | `Chi tiết lần học` |
| `portalScore10` | `{value}/10` |
| `portalScore4` | `{value}/4` |
| `portalHistoryScope` | `Lịch sử có thể gồm học phần không được tính tín chỉ cho chương trình đang xem.` |
| `portalProgressTab` | `Tiến độ` |
| `portalResultsTab` | `Kết quả` |
| `portalEligibilityTitle` | `Điều kiện đăng ký` |
| `portalEligibilityAdvice` | `Thông tin tham khảo về điều kiện học phần, không phải đăng ký lớp hay xác nhận lớp được mở.` |
| `portalUnknownEligibility` | `Chưa đủ thông tin kết luận điều kiện đăng ký` |
| `portalNoCandidates` | `Không có học phần chưa hoàn thành trong nhóm này.` |
| `portalAllCompleted` | `Tất cả học phần trong dữ liệu trả về đã hoàn thành.` |
| `portalConditions` | `Điều kiện cần lưu ý` |
| `portalEvaluationBasis` | `Cơ sở và thời điểm đánh giá` |
| `portalNoShortfalls` | `Không có điều kiện còn thiếu trong kết quả đánh giá trả về.` |
| `portalNotApplicable` | `Không áp dụng` |
| `portalCurriculumHint` | `Xem học phần cần hoàn thành` |
| `portalPlosHint` | `Xem năng lực chương trình hướng tới` |
| `portalProgressHint` | `Kiểm tra tín chỉ và kết quả đã ghi nhận` |
| `portalEligibilityHint` | `Kiểm tra điều kiện trước khi đăng ký` |
| `portalGraduationHint` | `Xem điều kiện tốt nghiệp còn thiếu` |

Expected generated Dart interface (not manually edited):

```dart
abstract class AppLocalizations {
  String get portalContext;
  String portalCompulsoryCredits(String value);
  String portalEquivalentFrom(String course);
  String get portalEligibilityAdvice;
  String get portalEvaluationBasis;
}
```

**Rationale:** mirror existing placeholder metadata and `creditsValue(String)`/`scores(...)` in `lib/l10n/app_vi.arb:151`; keep phone-only labels scoped, not shell strings.

**Gotchas:** no English literals in widgets, duplicate graduation disclaimer, punctuation-built translated sentences, or new “Registered” success copy. Counts use existing course-count/credit formatting only when semantically correct; main tab count can be a separate numeric Text with localized tab label semantics, not a new invented sentence. Assessment notice acknowledges E1 without technical backend jargon.

**Verify:** ARB parses; compare added key set to table; no existing key changed. **Depends on:** —.

### CR-02 — Localization generation, separate step

**Files:** MODIFY generated `lib/l10n/app_localizations.dart`; MODIFY generated `lib/l10n/app_localizations_vi.dart`. No `l10n.yaml` changes.

**Shape:** generator produces typed getters and String placeholder methods, for example:

```dart
String portalCompulsoryCredits(String value);
String portalEquivalentFrom(String course);
```

**Rationale:** use current `l10n.yaml` and generated interface conventions, not a custom strings object.

**Gotchas:** generated files are never hand-authored; no second locale/package. Generation commands in this plan are for the build session, not this planning run.

**Verify:** future `flutter gen-l10n`; only the two listed generated outputs change; all CR-01 getters compile. **Depends on:** CR-01.

### CR-03 — Isolated dDUT portal tokens and primitives

**Files:** MODIFY `lib/common/theme/app_colors.dart`; MODIFY `lib/common/theme/app_dimens.dart` (append-only); NEW all of:

- `lib/features/portal/presentation/components/portal_theme.dart`
- `lib/features/portal/presentation/components/portal_card.dart`
- `lib/features/portal/presentation/components/portal_section_header.dart`
- `lib/features/portal/presentation/components/portal_badge.dart`
- `lib/features/portal/presentation/components/portal_disclosure.dart`
- `lib/features/portal/presentation/components/portal_tabs.dart`
- `lib/features/portal/presentation/components/portal_state_panel.dart`

**Shape:** declare every §4.2 token, exactly those two sampled colours, and scoped text/theme overrides. Public widget interfaces:

```dart
abstract final class PortalTheme {
  static ThemeData from(ThemeData base) => base.copyWith(
    scaffoldBackgroundColor: AppColors.surface,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: AppColors.brand,
      foregroundColor: AppColors.surface,
      centerTitle: true,
      toolbarHeight: AppDimens.portalToolbarHeight,
      titleTextStyle: const TextStyle(
        fontSize: AppDimens.portalTitleSize,
        fontWeight: FontWeight.w600,
        color: AppColors.surface,
      ),
    ),
  );
}
```

Also override textTheme, card/expansion/list/tab/chip defaults locally according to §4.2. Do not call global `usesLegacySheetStyle` to choose portal visuals. New widgets, one file each:

```dart
class PortalCard extends StatelessWidget {
  const PortalCard({super.key, required this.child,
    this.color = AppColors.portalCourseSurface,
    this.elevation = AppDimens.portalFlatElevation});
  final Widget child;
  final Color color;
  final double elevation;
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    elevation: elevation,
    borderRadius: BorderRadius.circular(AppDimens.portalCardRadius),
    child: Padding(
      padding: const EdgeInsets.all(AppDimens.portalSpaceLg), child: child),
  );
}

class PortalSectionHeader extends StatelessWidget {
  const PortalSectionHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppDimens.portalSpaceLg,
      bottom: AppDimens.portalSpaceSm),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

class PortalBadge extends StatelessWidget {
  const PortalBadge({super.key, required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: AppDimens.portalBadgeAlpha),
      borderRadius: BorderRadius.circular(AppDimens.portalPillRadius)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.portalSpaceSm,
        vertical: AppDimens.portalSpaceXs),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: color)),
    ),
  );
}

class PortalDisclosure extends StatelessWidget {
  const PortalDisclosure({super.key, required this.title,
    required this.children, this.initiallyExpanded = false});
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: Text(title), initiallyExpanded: initiallyExpanded, children: children);
}

class PortalTabs extends StatelessWidget {
  const PortalTabs({super.key, required this.labels, required this.selected,
    required this.onSelected, this.counts})
      : assert(counts == null || counts.length == labels.length);
  final List<String> labels;
  final List<int>? counts;
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Row(children: [
    for (final entry in labels.indexed)
      Expanded(child: Semantics(selected: selected == entry.$1,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: selected == entry.$1
              ? AppColors.brand : AppColors.surface,
            foregroundColor: selected == entry.$1
              ? AppColors.surface : AppColors.textSecondary,
            minimumSize: const Size.fromHeight(AppDimens.portalTouchMin),
            shape: const RoundedRectangleBorder(borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppDimens.portalTabRadius))),
          ),
          onPressed: () => onSelected(entry.$1), child: Wrap(
            alignment: WrapAlignment.center, spacing: AppDimens.portalSpaceSm,
            children: [Text(entry.$2),
              if (counts case final values?) Text('${values[entry.$1]}')])))),
  ]);
}

class PortalStatePanel extends StatelessWidget {
  const PortalStatePanel({super.key, required this.message,
    this.onRetry, this.isError = false});
  final String message;
  final VoidCallback? onRetry;
  final bool isError;
  @override
  Widget build(BuildContext context) => PortalCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text(message), if (onRetry != null)
      TextButton(onPressed: onRetry,
        child: Text(AppLocalizations.of(context).retry))],
  ));
}
```

Complete these skeletons with min-target constraints, the tabs' shared thin baseline (not a selected underline), selected fill/foreground and semantics, optional badge status icon via semantic mapping, state icon/tone, white-card elevation option, and §4.2 text styles. Do not leave skeleton buttons visually identical. Expansion headers get stable PageStorageKeys from callers. Tabs have only local selection callbacks, no request logic. Component tests assert selected brand/surface foreground, unselected surface/textSecondary, top-only corners and bottom alignment, not merely selected semantics.

**Rationale:** mirror the composition signatures of `lib/common/widgets/app_card.dart:8` and `lib/features/portal/presentation/components/term_section.dart:5`, while replacing their rejected default hierarchy locally. This is not a second global theme.

**Gotchas:** Theme must wrap a Builder so descendants construct their AppBars/styles under the scoped theme. No ThemeData change above portal subtree. Add `dart:ui` FontFeature only where needed, not a font dependency. Material ink/semantics must survive rounded clipping. Avoid decorative shadows on grey course cards.

**Verify:** CR-07 component tests: blue/white toolbar, no generic outline on course card, token dimensions, selected tab semantics, growing text without overflow. Compare non-portal Home/login screenshots before/after: unchanged. **Depends on:** CR-02.

### CR-04 — One portal page/context surface and route gate

**Files:** NEW:

- `lib/features/portal/presentation/components/portal_page.dart`
- `lib/features/portal/presentation/context/portal_context_bar.dart`
- `lib/features/portal/presentation/context/portal_context_sheet.dart`
- `lib/features/portal/presentation/context/portal_route.dart`

MODIFY `lib/features/portal/presentation/components/no_context_panel.dart`; MODIFY `lib/common/routes/app_router.dart` only portal imports/wrappers/private gate extraction. `PortalContextCubit/State` remain unchanged.

**Shape:**

```dart
class PortalPage extends StatelessWidget {
  const PortalPage({super.key, required this.title, required this.body,
    this.onBeforeContextChange, this.onBack});
  final String title;
  final Widget body;
  final VoidCallback? onBeforeContextChange;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) => Theme(
    data: PortalTheme.from(Theme.of(context)),
    child: Builder(builder: (context) => Scaffold(
      appBar: AppBar(title: Text(title), leading: BackButton(
        onPressed: onBack ?? () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RoutePaths.curriculum);
          }
        })),
      body: SafeArea(top: false, child: Column(children: [
        PortalContextBar(onBeforeChange: onBeforeContextChange),
        Expanded(child: body),
      ])),
    )),
  );
}

class PortalContextBar extends StatelessWidget {
  const PortalContextBar({super.key, this.onBeforeChange});
  final VoidCallback? onBeforeChange;
  @override
  Widget build(BuildContext context) => BlocBuilder<PortalContextCubit,
    PortalContextState>(builder: (context, state) => ListTile(
      tileColor: AppColors.portalSummarySurface,
      title: Text(state.selectedProgram?.programName ??
        AppLocalizations.of(context).portalAppliedCurriculum),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(state.overview?.semester?.code ??
          AppLocalizations.of(context).notProvided),
        Text(state.selectedProgram?.versionNumber != null
          ? AppLocalizations.of(context).fieldValue(
              AppLocalizations.of(context).version,
              state.selectedProgram!.versionNumber!)
          : AppLocalizations.of(context).noVersion),
      ]),
      trailing: const Icon(Icons.expand_more),
      onTap: () => showPortalContextSheet(context, onBeforeChange: onBeforeChange),
    ));
}

Future<void> showPortalContextSheet(BuildContext context,
  {VoidCallback? onBeforeChange}) => showModalBottomSheet<void>(
  context: context, isScrollControlled: true, useSafeArea: true,
  builder: (_) => BlocProvider.value(
    value: context.read<PortalContextCubit>(),
    child: PortalContextSheet(onBeforeChange: onBeforeChange)),
);

class PortalContextSheet extends StatelessWidget {
  const PortalContextSheet({super.key, this.onBeforeChange});
  final VoidCallback? onBeforeChange;
  @override
  Widget build(BuildContext context) => BlocBuilder<PortalContextCubit,
    PortalContextState>(builder: (context, state) => ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppDimens.portalPageInset),
      children: [
        Text(AppLocalizations.of(context).portalContext),
        for (final program in state.overview?.programs ?? const <PortalProgram>[])
          ListTile(title: Text(program.programName),
            subtitle: Text(program.programCode)),
        for (final semester in state.semesters)
          ListTile(title: Text(semester.code)),
      ],
    ));
}

class PortalRoute extends StatelessWidget {
  const PortalRoute({super.key, required this.builder, this.onBack});
  final Widget Function(PortalContext portal, PortalContextState state) builder;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) => BlocBuilder<PortalContextCubit,
    PortalContextState>(builder: (context, state) {
      final portal = state.context;
      if (!state.isLoading && state.errorMessage == null &&
          state.semesters.isNotEmpty && portal != null) {
        return builder(portal, state);
      }
      return PortalPage(title: AppLocalizations.of(context).curriculum,
        onBack: onBack ?? () => context.go(RoutePaths.curriculum),
        body: state.isLoading ? const LoadingSkeleton() : PortalStatePanel(
          message: state.errorMessage ??
            AppLocalizations.of(context).portalNoApplicableProgram,
          onRetry: context.read<PortalContextCubit>().load));
    });
}
```

Complete sheet choice handlers: use selected radio/check semantics, code/name/type labels, read-only version/decision; single programme has no redundant radio. Show semester options after programmes. Capture cubit, dismiss sheet, invoke `onBeforeChange`, then call existing `selectProgram` or `selectSemester`. Disable duplicate selection/loading. Selecting the current value just dismisses; never clear/recreate cubit. A changed semester closes the sheet and visibly reloads context; student can reopen to select another returned programme. Null version/decision uses current notProvided/noVersion labels. Include an explicit Close affordance with existing Material localized tooltip.

Gate order: loading, request error, missing linked student, missing dated/selected semester, missing applicable programme, then body. Skeleton's generic message must be replaced by those ordered specific branches. With no semester/programme show CR-01 guidance and retry/context access. No sign-out/account state changes here; existing auth gates dispose the feature tree. Normal child Back pops when possible, otherwise goes to area entry. Gate Back goes to area entry; overview passes an explicit Home callback to both PortalRoute and PortalPage so its missing-context gate cannot loop to itself.

Extract private `_PortalRoute` without changing its `Widget Function(PortalContext, PortalContextState)` contract. Replace all **six** calls: Curriculum router line164, syllabus177, PLO190, Progress200, eligibility210, Graduation222. Preserve `ValueKey(portal)` and `ValueKey((portal,itemId))`, getIt factories and loads. Keep eligibility's existing semesterCode constructor until CR-11 removes its redundant body heading; it may remain compatible afterward. No route-path changes or query parameters.

For syllabus, PortalPage receives `onBeforeContextChange: () => context.go(RoutePaths.curriculumProgram)`. This deliberately exits an item pinned to the old programme before mutating context. Never reuse the old itemId under a new context. Gate/normal pages each render one summary, never nested PortalPages.

**Rationale:** extract the actual private gate at `lib/common/routes/app_router.dart:235`; reuse `PortalContextState.context` rather than reconstructing resolution in widgets. Sheet provider mirrors the existing route-owned lifetime.

**Gotchas:** modal routes may not inherit providers; use BlocProvider.value, never close that cubit from the sheet. Do not display previous context's answer during switch. Existing overview remains legacy until CR-08; do not partially redesign it before the CR-07 checkpoint capture. This is an explicit temporary migration state, not final permission for duplicate selector forms or an approval stop.

**Verify:** CR-07 context widget tests cover missing gates, deep link, single/multiple programmes, future dated semester, one visible summary including applied version without opening the sheet, visible missing-version label, sheet selection/dismiss/reload, stale response and syllabus exit. Existing auth/router tests unchanged. **Depends on:** CR-03.

### CR-05 — Equivalent-course projection and reviewed-context validation

**Files:** MODIFY `lib/features/portal/data/remote/dto/eligibility_reason_dto.dart`; MODIFY `lib/features/portal/data/remote/dto/eligibility_item_dto.dart`; MODIFY `lib/features/portal/domain/model/eligibility_item.dart`; MODIFY `test/features/portal/data/portal_dto_test.dart`; MODIFY `lib/features/portal/data/remote/portal_api.dart`; NEW `lib/features/portal/data/remote/graduation_context_validator.dart`; NEW `test/features/portal/data/graduation_context_validator_test.dart`; NEW `test/features/portal/data/portal_api_graduation_test.dart`. No repository/API public signature, use-case, outcome/domain, context-cubit or backend changes. The API implementation change is the explicit safety exception justified by T63.

**Shape:**

```dart
@JsonSerializable()
class EligibilityReasonDto {
  const EligibilityReasonDto({required this.message, this.code, this.evidenceCourse});
  factory EligibilityReasonDto.fromJson(Map<String, dynamic> json) =>
    _$EligibilityReasonDtoFromJson(json);
  final String message;
  final String? code;
  final CourseRefDto? evidenceCourse;
  Map<String, dynamic> toJson() => _$EligibilityReasonDtoToJson(this);
}
```

Add optional `this.equivalentCourse` / `final CourseRef? equivalentCourse` to existing EligibilityItem, retaining every required constructor parameter/list and adding the property to props. Existing EligibilityItemDto.toDomain adds:

```dart
CourseRef? get equivalentCourse => reasons
  .where((reason) => reason.code == 'EQUIVALENT_COMPLETED')
  .map((reason) => reason.evidenceCourse?.toDomain())
  .whereType<CourseRef>()
  .firstOrNull;
```

Use that derived getter for the new optional domain field. The exact wire reason code is protocol text, not a l10n string. If desired declare its named private constant in the DTO; do not add a second backend enum/model just for one comparison.

**Rationale:** extend the existing `EligibilityReasonDto`/nested `CourseRefDto.toDomain` mirror, not a parallel decoder (`lib/features/portal/data/remote/dto/eligibility_item_dto.dart:41`). Current report must retain completed rows to supply evidence.

**Gotchas:** same-course COURSE_COMPLETED is not equivalent; code without evidence remains null; unknown reason still preserves message; no throwing because optional evidence is absent. Constructor call sites: EligibilityItemDto.toDomain, `test/support/domain_samples.dart`, `test/features/portal/presentation/registration_cubit_test.dart`; optional parameter leaves the last two unchanged. Existing DTO fixture JSON without these fields continues to decode.

**Shape — context validation:** validate existing wire IDs without adding them to display/domain models. In the NEW validator file import PortalContext and ContractException:

```dart
void validateGraduationContext(Object? returned, PortalContext expected) {
  if (returned is! Map<String, dynamic> ||
      returned['studentId'] != expected.studentId ||
      returned['programId'] != expected.programId ||
      returned['semesterId'] != expected.semesterId) {
    throw const ContractException('graduation-context-mismatch');
  }
}
```

In PortalApi replace only graduation's decode callback with `(body) => _decodeGraduation(_object(body), context)` and add this private method (import the helper):

```dart
GraduationOutcome _decodeGraduation(Map<String, dynamic> body,
    PortalContext expected) {
  final envelope = GraduationOutcomeDto.fromJson(body);
  final outcome = envelope.toDomain(_strings);
  if (outcome is GraduationReviewed) {
    validateGraduationContext(envelope.result?['context'], expected);
  }
  return outcome;
}
```

Decode/version-check first: current-schema reviewed data must pass exact non-null ID equality before escaping the API. Diagnostic CANNOT_AUDIT has no reviewed context, and future schema remains GraduationUnsupported rather than being misclassified as malformed. Do not validate programme/version *labels* or infer identities from their text. The existing `_get` ContractException path produces localized invalid-response error state, suppressing the verdict on both Progress and Graduation while preserving independent Results history; retry and context change stay available. Do not include received IDs in error text. Missing/null/wrong-type IDs are failures, not a compatibility exemption. New fields are not requested: backend IDs already exist at `backend/features/graduation/graduation.dto.ts:39`–`:41`; client display DTO currently drops them (`lib/features/portal/data/remote/dto/graduation_context_dto.dart:7`).

**Test shape:** both new files use `void main()` with flutter_test. Validator tests call the function with synthetic PortalContext and literal maps. API tests use existing `test/support/stub_http_adapter.dart:5`, Dio, `objectFixture('graduation')`, `AttachmentCache()` (no download/pathFor call), and localized strings from existing DTO-test setup. Mutate fresh synthetic fixture IDs to the requested context, then vary one at a time; assert the real `PortalApi.graduation` boundary, not just the helper. No new mock or file-system fixture required. Mirror `test/core/network/interceptors_test.dart` for ResponseBody/Dio adapter setup.

**Verify:** after CR-06, run `flutter test test/features/portal/data/portal_dto_test.dart test/features/portal/data/graduation_context_validator_test.dart test/features/portal/data/portal_api_graduation_test.dart`. DTO cases: equivalent identity retained, ordinary completed not equivalent, absent/null evidence, unknown code, reasons/concurrency unchanged, equality. Context cases: exact match, each mismatched ID, missing/null/non-string ID, malformed context, two differently keyed requests receiving the wrong payload, CANNOT_AUDIT unchanged, unsupported schema unchanged. API asserts mismatch throws ContractException, never GraduationReviewed. Existing cubit error tests plus CR-10/CR-12 widgets cover no stale verdict. **Depends on:** —; verification after CR-06.

### CR-06 — DTO generation, separate step

**Files:** MODIFY generated `lib/features/portal/data/remote/dto/eligibility_reason_dto.g.dart` only. Inspect generator output; no DI changes are expected because constructors registered with getIt are unchanged.

**Shape:** generated decoder will include `code: json['code'] as String?` and nullable nested CourseRefDto.fromJson; serializer includes matching optional fields under current build.yaml conventions. Factory remains:

```dart
factory EligibilityReasonDto.fromJson(Map<String, dynamic> json) =>
  _$EligibilityReasonDtoFromJson(json);
```

**Rationale:** follow existing json_serializable part files; never edit generated decoding by hand.

**Gotchas:** preserve checked decoding configuration. Do not accept unrelated mass regeneration silently. If existing build_runner updates other generated files, inspect why and keep only required, reproducible changes; otherwise stop/report the mismatch.

**Verify:** future `dart run build_runner build --delete-conflicting-outputs`, then `flutter test test/features/portal/data/portal_dto_test.dart test/features/portal/data/graduation_context_validator_test.dart test/features/portal/data/portal_api_graduation_test.dart`. That flag concerns generated outputs, not permission to delete source files. **Depends on:** CR-05.

### CR-07 — Curriculum vertical slice and nonblocking visual checkpoint

**Files — MODIFY:**

- `lib/features/portal/presentation/curriculum/curriculum_screen.dart`
- `lib/features/portal/presentation/curriculum/curriculum_cubit.dart`
- `lib/features/portal/presentation/curriculum/curriculum_state.dart`
- `lib/features/portal/presentation/components/course_row.dart`
- `lib/features/portal/presentation/components/course_filter_bar.dart`
- `lib/features/portal/presentation/components/course_state_chip.dart`
- `lib/features/portal/presentation/components/term_section.dart`
- `test/features/portal/presentation/curriculum_cubit_test.dart`

**Files — NEW:**

- `lib/features/portal/presentation/curriculum/course_details_sheet.dart`
- `test/support/portal_widget_harness.dart`
- `test/features/portal/presentation/portal_components_test.dart`
- `test/features/portal/presentation/portal_context_widgets_test.dart`
- `test/features/portal/presentation/curriculum_screen_test.dart`

**Files — DELETE:** `lib/features/portal/presentation/components/program_summary_card.dart` after removing its sole curriculum caller/import. No new course/domain model.

**Shape — state exception justified by T17:** optional evidence must be cached separately from the curriculum request, not invalidate its successful answer. Extend existing constructor/props with these defaults:

```dart
final Map<String, CourseRef> equivalentCourses;
final bool equivalentLoaded;
final bool isLoadingEquivalent;
final String? equivalentError;
```

Constructor defaults are `const {}`, false, false, null. Add this copyWith to the existing state (not a new state class); retain all current fields and add evidence fields to props:

```dart
CurriculumState copyWith({bool? isLoading, Curriculum? data,
  CourseState? filter, String? errorMessage, bool clearFilter = false,
  bool clearError = false, Map<String, CourseRef>? equivalentCourses,
  bool? equivalentLoaded, bool? isLoadingEquivalent, String? equivalentError,
  bool clearEquivalentError = false}) => CurriculumState(
    isLoading: isLoading ?? this.isLoading,
    data: data ?? this.data,
    filter: clearFilter ? null : filter ?? this.filter,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    equivalentCourses: equivalentCourses ?? this.equivalentCourses,
    equivalentLoaded: equivalentLoaded ?? this.equivalentLoaded,
    isLoadingEquivalent: isLoadingEquivalent ?? this.isLoadingEquivalent,
    equivalentError: clearEquivalentError ? null : equivalentError ?? this.equivalentError,
  );
```

Keep old `terms`, `_matches`, `expandedTerms` behavior unchanged. `setFilter` becomes `emit(state.copyWith(filter: filter, clearFilter: filter == null))`; preserve all evidence fields rather than rebuilding state and dropping them. Normal load resets data/evidence with its existing fresh constructor, so copyWith does not need a nullable data-clear sentinel.

```dart
Future<void> loadEquivalentCourses({bool force = false}) async {
  if (state.data == null || state.isLoadingEquivalent ||
      (state.equivalentLoaded && !force)) return;
  final revision = _revision;
  emit(state.copyWith(isLoadingEquivalent: true, clearEquivalentError: true));
  try {
    final report = await _portal.eligibility(context);
    if (isClosed || revision != _revision) return;
    emit(state.copyWith(
      isLoadingEquivalent: false,
      equivalentLoaded: true,
      equivalentCourses: Map.unmodifiable({
        for (final item in report.items)
          if (item.equivalentCourse case final source?) item.itemId: source,
      }),
    ));
  } catch (error) {
    if (isClosed || revision != _revision) return;
    emit(state.copyWith(isLoadingEquivalent: false,
      equivalentError: error.toString()));
  }
}
```

`load()` keeps its original two-state success/failure sequence and increments existing `_revision`, resetting optional evidence through the initial state. Never call enrichment from load/build. The existing revision invalidates a late evidence reply after reload; one in-flight evidence call at a time suffices. Failed enrichment leaves loaded curriculum/filter intact and allows explicit retry. Store missing mapping after a successful response as “not supplied,” not an error or a reason to fetch forever. Ignore enrichment results for items whose authoritative curriculum state is not passedEquivalent; do not use eligibility to recompute curriculum completion.

**Shape — new course/card interfaces:**

```dart
class CourseRow extends StatelessWidget {
  const CourseRow({super.key, required this.course, required this.onDetails,
    required this.onSyllabus});
  final CurriculumCourse course;
  final VoidCallback onDetails;
  final VoidCallback? onSyllabus;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final tag = course.state.tag(strings);
    return PortalCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Expanded(child: Text(course.courseCode)),
          Text(strings.creditsValue(formatDecimal(course.credits)))]),
        Text(course.courseName, style: Theme.of(context).textTheme.titleMedium),
        TextButton(onPressed: onDetails,
          child: CourseStateChip(label: tag.label, color: tag.color)),
        if (onSyllabus != null)
          TextButton(onPressed: onSyllabus, child: Text(strings.syllabus))
        else Text(strings.portalNoIssuedSyllabus),
      ],
    ));
  }
}

class CourseDetailsSheet extends StatelessWidget {
  const CourseDetailsSheet({super.key, required this.course});
  final CurriculumCourse course;
  @override
  Widget build(BuildContext context) => BlocBuilder<CurriculumCubit,
    CurriculumState>(builder: (context, state) {
      final strings = AppLocalizations.of(context);
      final source = state.equivalentCourses[course.itemId];
      return ListView(shrinkWrap: true,
        padding: const EdgeInsets.all(AppDimens.portalPageInset), children: [
          Text(strings.portalCourseDetails),
          Text(course.courseName),
          Text(strings.scores(
            course.score10 == null ? strings.notProvided : formatDecimal(course.score10!),
            course.score4 == null ? strings.notProvided : formatDecimal(course.score4!),
            course.letterGrade ?? strings.notProvided)),
          if (source != null)
            Text(strings.portalEquivalentFrom('${source.code} · ${source.name}')),
        ]);
    });
}
```

Finish detail states: only equivalent state triggers/show evidence loader; evidence error uses portalEquivalentUnavailable plus retry, successful missing identity uses portalEquivalentNotSupplied. Preserve authoritative status text in every case. ShowModalBottomSheet provides `BlocProvider.value(value: context.read<CurriculumCubit>(), child: CourseDetailsSheet(course: course))`; request `loadEquivalentCourses()` once on opening passedEquivalent details. Modal has SafeArea, Close semantics and scrolling. Do not transcribe production values into test data.

`CurriculumScreen` remains `const CurriculumScreen({super.key}) extends StatelessWidget`. Its build returns `PortalPage(title: strings.myCurriculum, body: BlocBuilder<CurriculumCubit, CurriculumState>(...))`. Implement ordered loading/error/data branches with PortalStatePanel and retry cubit.load; no duplicate error snackbar. Data branch is a ListView with required-credit total, CourseFilterBar, then TermSections. CourseRow's only caller now supplies course, details callback, and nullable syllabus route callback. TermSection retains `title`, `credits`, `initiallyExpanded`, `children`; CourseFilterBar retains `(String? id, String label)` items/selectedId/onSelected; CourseStateChip retains label/color, delegates PortalBadge. Use context/filter PageStorageKeys for expansion, and itemId keys for cards.

**Screen layout:** blue toolbar/shared context; compact required total; horizontal status filters; ascending planned-term disclosure headers with **compulsory** credits; grey rounded course cards. Course header order is code/credits, blue course name, elective cue if relevant, tappable status/details, syllabus action/unavailable. From dDUT `20261102-223814.jpg`; compact badges from `20261102-223809.jpg`. Term grouping/filter/score sheet: **no dDUT reference**. Group elective alternatives within each term by non-null groupName, stable first-seen order, with choose-within-group cue. Unnamed elective items get elective label only; never group all unknowns into a fictitious requirement. Compulsory rows keep their relative order. No block tags, repeat counts, biography, decision card or score wall.

**States:** no terms -> portalNoTerms; filtered no match -> portalNoFilterMatches + portalClearFilter calling setFilter(null); no attempts still shows complete frame; curriculum request failure retries only curriculum; optional evidence failure never hides terms. A missing snapshot stays an error and does not substitute catalogue data.

**Test harness shape:** a function, not a second app:

```dart
Widget portalHarness({required PortalContextCubit contextCubit,
  required Widget child}) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider.value(value: contextCubit, child: child),
  );
```

Use existing MockPortalUseCases/domain samples plus typed MockCubit test doubles in the harness file when needed; do not introduce a new mocking dependency. Test fixture widths/text scales are named constants in that test support file, not production layout literals.

**Rationale:** retain current cubit revision/filter/expansion logic (`lib/features/portal/presentation/curriculum/curriculum_cubit.dart:18`, `lib/features/portal/presentation/curriculum/curriculum_state.dart:37`) while replacing screen composition and adding only the missing evidence channel. Mirror existing BlocBuilder/provider test patterns, not a new state architecture.

**Gotchas:** term credits do not change with filtering; equivalent pass remains in passed filter. Preserve decimal formatting. Course details must work when hasSyllabus is false. Do not mark an elective option as required solely because listed. Screen title/credit labels cannot be a second context card. Same-item IDs from another context must not inherit expansion/evidence state.

**Verify:** future focused `flutter test test/features/portal/data/portal_dto_test.dart test/features/portal/presentation/curriculum_cubit_test.dart test/features/portal/presentation/portal_components_test.dart test/features/portal/presentation/portal_context_widgets_test.dart test/features/portal/presentation/curriculum_screen_test.dart`; `flutter analyze`. Existing load/filter tests retain expectations; add evidence success/no-evidence/failure/retry/cache/filter-preservation/reload-race/close tests. Widget tests cover card hierarchy, elective grouping, syllabus absent/present, no identity/metadata, clear filter, one context bar, scaled text, null scores, accessible controls. Device capture Curriculum and its state/context sheets with safe synthetic data; compare to reference card hierarchy.

**Depends on:** CR-02, CR-03, CR-04, CR-06.

**OWNER REVIEW CHECKPOINT (nonblocking):** shared style/context plus **ONE rebuilt screen: Curriculum**. Capture the actual device look, including cards/type/spacing/context/filters and expanded detail. Label it CR-07 checkpoint evidence for the owner to inspect after the full run; proceed directly through CR-08–CR-13 without asking or waiting. Legacy overview/other pages are not yet redesigned at this capture. Automated failures remain engineering gates, not requests for visual permission. Apply Q1's proposed tokens/density now; any later owner-requested refinement is a follow-up, not a blocker for this build.

### CR-08 — Academic launcher and legacy component deletion

**Files:** MODIFY `lib/features/portal/presentation/overview/portal_overview_screen.dart`; MODIFY `lib/features/portal/presentation/components/portal_menu_list.dart`; NEW `test/features/portal/presentation/portal_overview_screen_test.dart`; MODIFY `test/support/portal_widget_harness.dart`; DELETE `lib/features/portal/presentation/components/student_summary_card.dart`; DELETE `lib/features/portal/presentation/components/program_switch.dart`; DELETE `lib/features/portal/presentation/components/semester_picker.dart`. Remove their only overview imports/calls; do not move the card elsewhere.

**Shape:**

```dart
class PortalMenuList extends StatelessWidget {
  const PortalMenuList({super.key, required this.items});
  final List<({IconData icon, String label, String hint, VoidCallback onTap})> items;
  @override
  Widget build(BuildContext context) => PortalCard(
    color: AppColors.surface, elevation: AppDimens.portalCardElevation,
    child: Column(children: [for (final item in items)
      ListTile(leading: Icon(item.icon), title: Text(item.label),
        subtitle: Text(item.hint), trailing: const Icon(Icons.chevron_right),
        onTap: item.onTap)],
    ),
  );
}

class PortalOverviewScreen extends StatelessWidget {
  const PortalOverviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalRoute(onBack: () => context.go(RoutePaths.home),
      builder: (portal, state) => PortalPage(
      title: strings.curriculum, onBack: () => context.go(RoutePaths.home),
      body: ListView(padding: const EdgeInsets.all(AppDimens.portalPageInset),
        children: [PortalMenuList(items: [
          (icon: Icons.school_outlined, label: strings.myCurriculum,
            hint: strings.portalCurriculumHint,
            onTap: () => context.push(RoutePaths.curriculumProgram)),
        ])]),
    ));
  }
}
```

Complete all five records in exact order: Curriculum (`school_outlined`), PLOs (`flag_outlined`), Progress/results (`bar_chart_outlined`), eligibility (`checklist_outlined`), graduation (`verified_outlined`), each using existing route constant/label and CR-01 hint. Add internal row dividers/minimum64 and top-level Back to existing Home route using PortalPage.onBack. PortalRoute may wrap the overview locally as above; do not also wrap it in the router. It owns no second cubit/selector.

**Layout:** one shared context summary, then five short icon/label/hint rows in a white rounded group. Rounded spacing from dDUT `20261101-163250.jpg` and `20261101-163257.jpg`; actual academic launcher composition **no dDUT reference**. No second tile dashboard, identity, KPI, transcript or expanded programme metadata.

**States:** same shared gates; no context -> no academic destination links, but retry/context/back remain. Error copy does not claim not enrolled. Applied version (or noVersion) is visible in the shared summary without opening the sheet; missing decision is shown only in the sheet. Neither suppresses otherwise valid navigation. No snapshot request is added merely to decorate entry.

**Rationale:** replace existing five-record `PortalMenuList` caller (`lib/features/portal/presentation/overview/portal_overview_screen.dart:106`) rather than adding another feature menu or shell tile model.

**Gotchas:** overview currently owns the only usages of all three deleted widgets (enumerated §4.4); re-run rg first. Routing to Home is existing behavior, not a Home redesign. No student name/code/status/cohort is kept “for familiarity.”

**Test shape:** create the listed screen-test file now using CR-07's portalHarness/context mock and synthetic domain samples. Use `testWidgets`/WidgetTester, pump the real PortalOverviewScreen under the actual GoRouter route map where navigation is asserted. No new overview cubit. Extend the harness only for shared route setup. CR-13's example is the common test pattern, not deferred file ownership.

**Verify:** `flutter test test/features/portal/presentation/portal_overview_screen_test.dart` checks five working routes, context gating, applied/missing version visible initially and absence of identity/duplicate selectors. Device capture launcher plus missing-context state. **Depends on:** CR-07; no owner approval dependency.

### CR-09 — Assessment-first syllabus with on-demand learning/documents

**Files — MODIFY:**

- `lib/features/portal/presentation/syllabus/syllabus_screen.dart`
- `lib/features/portal/presentation/components/syllabus_header.dart`
- `lib/features/portal/presentation/components/assessment_table.dart`
- `lib/features/portal/presentation/components/html_section.dart`
- `lib/features/portal/presentation/components/clo_list.dart`
- `lib/features/portal/presentation/components/week_list.dart`
- `lib/features/portal/presentation/components/attachment_tile.dart`
- `test/support/portal_widget_harness.dart`

**Files — NEW:** `test/features/portal/presentation/syllabus_screen_test.dart`. No SyllabusCubit/State/download/cache changes or dependencies.

**Shape:** retain AssessmentTable's existing public name/record contract while replacing its implementation (a later rename has no student value):

```dart
class AssessmentTable extends StatelessWidget {
  const AssessmentTable({super.key, required this.rows});
  final List<({String component, String form, String weight})> rows;
  @override
  Widget build(BuildContext context) => Column(children: [
    for (final row in rows)
      PortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(row.component), Text(row.form),
          Align(alignment: AlignmentDirectional.centerEnd,
            child: Text(row.weight))])),
  ]);
}

class SyllabusScreen extends StatelessWidget {
  const SyllabusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(title: strings.syllabus,
      onBeforeContextChange: () => context.go(RoutePaths.curriculumProgram),
      body: BlocBuilder<SyllabusCubit, SyllabusState>(
        builder: (context, state) {
          final data = state.data;
          if (data == null) return const LoadingSkeleton();
          return ListView(
            padding: const EdgeInsets.all(AppDimens.portalPageInset),
            children: [
              SyllabusHeader(name: data.courseName, details: [data.courseCode,
                strings.creditsValue(formatDecimal(data.credits)),
                strings.revision(data.revisionNumber)]),
              PortalSectionHeader(title: strings.assessment),
              AssessmentTable(rows: [for (final item in data.assessments)
                (component: '${item.code} · ${item.name}',
                  form: item.form ?? strings.notProvided,
                  weight: strings.percentValue(formatDecimal(item.weight)))]),
              Text(strings.portalAssessmentNotice),
              PortalDisclosure(title: strings.clos, children: [CloList(
                items: [for (final item in data.clos)
                  (code: item.code, description: item.description)])]),
              PortalDisclosure(title: strings.weeklyPlan, children: [WeekList(
                items: [for (final item in data.weeks)
                  (label: item.label, content: item.content)])]),
            ]);
        }),
    );
  }
}
```

Complete branches before `data==null`: full loading, failed request retry load, successful empty optional sections. The skeleton null-data loader is only for an actual load, not an infinite fallback. Within the assessment group add `PortalDisclosure(title: strings.assessmentMethods, children: [HtmlSection(title: strings.assessmentMethods, html: data.assessmentMethods!)])` only when supplied/nonblank; initially collapsed. Never render that HTML in the main flow. Add collapsed courseDescription (preview first meaningful text block, full HTML inside disclosure), CLOs, weekly plan, then Documents containing attachments only. Omit objectives, teachingMethods and references completely, not merely behind another disclosure (spec §2.5 exclusions). Reuse existing localized headings; no new “Learning” label required. Do not parse HTML by substring cutting markup; use the existing HtmlWidget renderer with normal wrapping inside expanded content. If a safe short preview is not possible without a parser, omit the preview and offer the named disclosure (no dependency).

SyllabusHeader retains `name`/`List<String> details`; caller supplies only code/credits/revision, not publishedAt. HtmlSection retains title/html, uses PortalSectionHeader plus HtmlWidget. CloList retains `(String code,String description)` records and WeekList `(String label,String content)`; these are already behind their syllabus disclosures, with wrapping vertical rows and no horizontal tables. PLOs stop using CloList in CR-10. AttachmentTile keeps name/kind/isDownloading/progress/onOpen and existing single-download disable semantics; its size argument may remain for compatibility but MUST NOT render size text or reserve a size row. Scope widgets through PortalTheme; do not alter remote HTML content or attachment URLs.

**Layout:** toolbar/course-title grammar from dDUT `20261102-223814.jpg`; assessment-first vertical disclosures are **no dDUT reference**. Documents and outcomes are one tap away, not a long expanded web document. Weights are trailing numeric text with explicit percent, never progress charts implying achieved grades.

**States:** no linked syllabus follows existing request error/unavailable flow; no assessment components displays noData plus available narrative/documents and the E1 notice, never a fabricated formula. Empty CLO/week/document sections show localized noData inside disclosure. Download failure stays inline beside attachments while syllabus remains readable; opening state/progress kept. Existing unsupported/forbidden message never becomes successful empty content. Context change exits pinned item as CR-04.

**Rationale:** mirror existing syllabus mapping/actions (`lib/features/portal/presentation/syllabus/syllabus_screen.dart:101`, `lib/features/portal/presentation/syllabus/syllabus_screen.dart:121`) and keep the already installed HtmlWidget/attachment stack. Only composition changes.

**Gotchas:** CLO widget is still used by legacy PLOs until CR-10; maintain constructor so CR-10 starts from a compiling tree. Weights are supplied decimal strings; do not recompute assessment formulas. Never turn a missing narrative into a pass-condition assertion. No published/revision history screen, objectives/teaching/reference panels or byte-size rows.

**Test shape:** the new screen-test file follows CR-13's example with NEW `class MockSyllabusCubit extends MockCubit<SyllabusState> implements SyllabusCubit {}` in the listed harness; use existing syllabus synthetic samples and typed stream states. Its file and all these cases are owned by CR-09, not created later.

**Verify:** `flutter test test/features/portal/presentation/syllabus_screen_test.dart test/features/portal/presentation/syllabus_cubit_test.dart`: assessment before disclosures, no horizontal DataTable, weights/unknown form, assessment-method HTML absent until tapped and collapseable, excluded narratives/byte sizes absent even when supplied, accessible learning/document disclosures, attachment pending/error does not hide data, context change leaves old item. Device captures first view and expanded assessment/documents. **Depends on:** CR-08.

### CR-10 — Readable PLOs and credit-first Progress/Results

**Files — MODIFY:**

- `lib/features/portal/presentation/plos/plos_screen.dart`
- `lib/features/portal/presentation/progress/progress_screen.dart`
- `lib/features/portal/presentation/components/credit_progress_card.dart`
- `lib/features/portal/presentation/components/result_row.dart`
- `lib/features/portal/presentation/components/elective_group_row.dart`
- `lib/features/portal/presentation/components/knowledge_block_row.dart`
- `test/support/portal_widget_harness.dart`

**Files — NEW:** `lib/features/portal/presentation/plos/plo_description_tile.dart`; `lib/features/portal/presentation/progress/credit_breakdown.dart`; `lib/features/portal/presentation/progress/result_details_sheet.dart`; `test/features/portal/presentation/plos_screen_test.dart`; `test/features/portal/presentation/progress_screen_test.dart`. No Plos/Progress cubit/state/domain/data changes.

**Shape — PLO page:**

```dart
class PlosScreen extends StatelessWidget {
  const PlosScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(title: strings.plos,
      body: BlocBuilder<PlosCubit, PlosState>(builder: (context, state) {
        if (state.isLoading) return const LoadingSkeleton();
        if (state.errorMessage case final message?) {
          return PortalStatePanel(message: message, isError: true,
            onRetry: context.read<PlosCubit>().load);
        }
        if (state.items.isEmpty) return PortalStatePanel(message: strings.noPlos);
        return ListView(
          padding: const EdgeInsets.all(AppDimens.portalPageInset),
          children: [for (final group in state.items.map(
            (item) => item.competencyGroup).toSet()) ...[
              PortalSectionHeader(title: group ?? strings.other),
              for (final (index, item) in state.items.indexed)
                if (item.competencyGroup == group)
                  PloDescriptionTile(
                    key: ValueKey((context.read<PortalContextCubit>().state.context,
                      group, item.code, index)),
                    code: item.code, description: item.description),
          ]]);
      }));
  }
}
```

**Shape — NEW per-outcome widget** (one Widget plus its State in the named file; mirror existing stateful presentation pattern in ProgressScreen and ExpansionTile behavior in TermSection):

```dart
class PloDescriptionTile extends StatefulWidget {
  const PloDescriptionTile({super.key, required this.code,
    required this.description});
  final String code;
  final String description;
  @override
  State<PloDescriptionTile> createState() => _PloDescriptionTileState();
}

class _PloDescriptionTileState extends State<PloDescriptionTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) => PortalCard(child: ExpansionTile(
    initiallyExpanded: false,
    onExpansionChanged: (value) => setState(() => _expanded = value),
    title: Text(widget.code),
    subtitle: _expanded ? null : Text(widget.description,
      maxLines: AppDimens.portalOutcomePreviewLines,
      overflow: TextOverflow.ellipsis),
    children: [Text(widget.description)],
  ));
}
```

PLO code is short bold/blue via scoped title style; initial description is a two-line body preview, full untruncated description opens/collapses independently in one tap. No all-expanded mode, mapping matrix, personal attainment, credits or duplicate context. Use the parent ValueKey containing complete context, group, code and original response index for stable identity across rebuilds and duplicate codes; a changed context resets it. Do not use a label-only key or share one expansion bool across rows. No persistence across route exit is required; local State suffices, no PageStorage restoration that could disagree with `_expanded`. Preserve first-seen group/order; blank group can use existing other label. Grouped cards borrow dDUT `20261102-223814.jpg`; PLO/disclosure composition **no dDUT reference**. Existing Material expansion semantics/tooltips need no new l10n key.

**Shape — Progress local selection and new detail interfaces:**

```dart
enum ProgressView { progress, results }

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  ProgressView _view = ProgressView.progress;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(title: strings.progressResults,
      body: Column(children: [
        PortalTabs(labels: [strings.portalProgressTab, strings.portalResultsTab],
          selected: _view.index,
          onSelected: (selected) => setState(() => _view = ProgressView.values[selected])),
        Expanded(child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) => _view == ProgressView.progress
            ? _progress(context, state) : _results(context, state))),
      ]));
  }

  Widget _progress(BuildContext context, ProgressState state) {
    final strings = AppLocalizations.of(context);
    final outcome = state.graduation;
    if (outcome case GraduationReviewed(:final result)) {
      return ListView(padding: const EdgeInsets.all(AppDimens.portalPageInset),
        children: [CreditProgressCard(fraction: state.fraction,
          required: result.credits.requiredTotal,
          recognized: result.credits.recognizedTotal,
          missing: result.credits.missingTotal,
          compulsory: result.credits.compulsory,
          elective: result.credits.elective, free: result.credits.free),
          PortalDisclosure(title: strings.portalCreditBreakdown,
            children: [CreditBreakdown(result: result)]),
        ]);
    }
    if (state.isLoading) return const LoadingSkeleton();
    return PortalStatePanel(message: state.graduationError ?? strings.noData,
      onRetry: context.read<ProgressCubit>().load);
  }

  Widget _results(BuildContext context, ProgressState state) => ListView(
    padding: const EdgeInsets.all(AppDimens.portalPageInset), children: [
      Text(AppLocalizations.of(context).portalHistoryScope),
      for (final result in state.results)
        ResultRow(result: result, onDetails: () => showModalBottomSheet<void>(
          context: context, useSafeArea: true, isScrollControlled: true,
          builder: (_) => ResultDetailsSheet(result: result))),
      if (state.hasMore) TextButton(
        onPressed: state.isLoadingMore ? null : context.read<ProgressCubit>().loadMore,
        child: Text(AppLocalizations.of(context).loadMore)),
    ]);
}

class CreditBreakdown extends StatelessWidget {
  const CreditBreakdown({super.key, required this.result});
  final GraduationResult result;
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(AppLocalizations.of(context).fieldValue(
      AppLocalizations.of(context).compulsoryCredits,
      AppLocalizations.of(context).creditsValue(result.credits.compulsory))),
    Text(AppLocalizations.of(context).fieldValue(
      AppLocalizations.of(context).electiveCredits,
      AppLocalizations.of(context).creditsValue(result.credits.elective))),
    for (final block in result.knowledgeBlocks)
      ListTile(title: Text(block.blockName ?? block.blockSymbol ??
        AppLocalizations.of(context).other),
        trailing: Text(AppLocalizations.of(context).creditsValue(block.earnedCredits))),
  ]);
}

class ResultRow extends StatelessWidget {
  const ResultRow({super.key, required this.result, required this.onDetails});
  final AcademicResult result;
  final VoidCallback onDetails;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final grade = result.letterGrade ?? (result.score10 != null
      ? strings.portalScore10(formatDecimal(result.score10!))
      : result.score4 != null
        ? strings.portalScore4(formatDecimal(result.score4!)) : strings.notProvided);
    final tag = result.status.tag(strings);
    return InkWell(onTap: onDetails, child: PortalCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(result.course.code)),
          Text(strings.semesterCodeLabel(result.semester.code))]),
        Row(children: [Expanded(child: Text(result.course.name,
          style: Theme.of(context).textTheme.titleMedium)),
          Text(grade, style: const TextStyle(fontSize: AppDimens.portalScoreSize,
            fontWeight: FontWeight.w700))]),
        PortalBadge(label: tag.label, color: tag.color),
      ])));
  }
}

class ResultDetailsSheet extends StatelessWidget {
  const ResultDetailsSheet({super.key, required this.result});
  final AcademicResult result;
  @override
  Widget build(BuildContext context) => ListView(shrinkWrap: true,
    padding: const EdgeInsets.all(AppDimens.portalPageInset), children: [
      Text(AppLocalizations.of(context).portalAttemptDetails),
      Text(result.course.name),
      Text(AppLocalizations.of(context).scores(
        result.score10 == null ? AppLocalizations.of(context).notProvided : formatDecimal(result.score10!),
        result.score4 == null ? AppLocalizations.of(context).notProvided : formatDecimal(result.score4!),
        result.letterGrade ?? AppLocalizations.of(context).notProvided)),
    ]);
}
```

Complete skeleton branches: Progress distinguishes GraduationCannotAudit message, GraduationUnsupported explanation and request failure, without stale KPI. Material warnings appear adjacent to summary. Results loading/empty, first-page failure, subsequent-page failure with loaded rows retained, loading-more spinner and explicit retry must follow current cubit capabilities. A retry that calls load may refetch both sections (existing contract); do not promise independent retry endpoints. Whole-screen blocking/error snackbar is removed; errors remain in the affected tab and switching still works. PageStorageKeys preserve tab scroll; context-keyed provider recreation resets selection/evidence/scroll safely.

CreditProgressCard retains current fraction/required/recognized/missing/compulsory/elective/free constructor until its other caller is removed. Display **only** recognized as the large left KPI, required/missing on right, supporting capped percent and progress line. Compulsory/elective/free parameters are not extra headline rows. A required total numerically zero displays portalNotApplicable and no percentage/bar; do not show 0% as a result. Use existing decimal formatting/parsing conventions, not sums of attempts. Narrow layout stacks when below portalKpiBreakpoint.

Complete CreditBreakdown with clearly labelled compulsory/elective values, elective-group progress (credit and course counts when supplied) using existing ElectiveGroupRow constructor, then named-block earned credits. KnowledgeBlockRow keeps its old constructor for interim graduation compilation but now renders only title/earned; no advisoryGap/catalogRequiredCredits threshold rows. Null requirements say notSpecified; zero remains a real supplied value. Blocks are descriptive, as existing knowledgeBlocks text explains; do not restyle them as failures. No free-credit ledger, recognition ledger, timestamps or extra counters.

Complete ResultRow's responsive/wrapping layout with muted code and actual semester above blue name, status badge, main trailing score with explicit scale via the CR-01 portalScore10/portalScore4 keys; never show bare numeric /4 as if /10. Alternate scales/status are in ResultDetailsSheet. No inferred pass cutoff or credit recognition from grade. Use semantic result ID keys, not course ID (repeat attempts share a course).

**Layout:** credit KPI from dDUT `20261101-163309.jpg`; compact course/status grammar from `20261102-223809.jpg`; tab hierarchy from `20261102-223735.jpg`; combined Progress/Results composition and attempt sheets **no dDUT reference**. No GPA/conduct/study-year chart substitutes.

**Rationale:** reuse `ProgressState` independent fields, current paging, and already mapped `GraduationResult` groups/blocks (`lib/features/portal/presentation/progress/progress_state.dart:23`; `lib/features/portal/domain/model/graduation_result.dart:35`). Mirror the current PLO grouping but not its rejected generic page styling.

**Gotchas:** no resultSemesterId controls/signature changes, no Home shortcut edits. Graduation still compiles during CR-10 because shared card/row constructors remain compatible. Keep PlosCubit/ProgressCubit tests unchanged. Known denominator/percentage arithmetic is not license for credit aggregation.

**Test shape:** create both listed screen-test files during CR-10 using portalHarness and NEW typed mocks `class MockPlosCubit extends MockCubit<PlosState> implements PlosCubit {}` and `class MockProgressCubit extends MockCubit<ProgressState> implements ProgressCubit {}` in the listed harness. Use synthetic domain_samples and CR-13's common WidgetTester pattern, not later-created files.

**Verify:** `flutter test test/features/portal/presentation/plos_screen_test.dart test/features/portal/presentation/progress_screen_test.dart test/features/portal/presentation/progress_cubit_test.dart`. PLO cases: first-seen grouping/order, empty/error, two-line previews with no full-description children initially built, one tap opens full text without opening another item, collapse restores preview, expansion survives same-context rebuild, duplicate codes do not share state, context change resets expansion, no attainment. Progress cases: both tabs, zero denominator, cap, missing requirements, material warnings, all outcome/error combinations including reviewed-context validation failure (error/no audit hero while Results stays usable), repeat attempts, labelled numeric fallback, load-more retry preserving rows, scope note. Existing Progress cubit tests stay green unchanged. Device captures both tabs, breakdown, attempt detail and PLO collapsed/expanded. **Depends on:** CR-09.

### CR-11 — Advice-only eligibility with honest unknown state

**Files — MODIFY:** `lib/features/portal/presentation/registration/registration_screen.dart`; `lib/features/portal/presentation/registration/registration_state.dart`; `lib/features/portal/presentation/components/eligibility_item_card.dart`; `lib/features/portal/presentation/components/eligibility_chip.dart`; `test/features/portal/presentation/registration_cubit_test.dart`; `test/support/portal_widget_harness.dart`. **NEW:** `lib/features/portal/presentation/registration/eligibility_details_sheet.dart`; `test/features/portal/presentation/registration_screen_test.dart`. RegistrationCubit/domain/data remain unchanged (apart from CR-05's optional evidence projection).

**Shape — intentional state safety correction:**

```dart
List<EligibilityItem> get allowed => List.unmodifiable(
  (report?.items ?? const <EligibilityItem>[]).where((item) =>
    !item.completed && (item.eligibility == Eligibility.eligible ||
      item.eligibility == Eligibility.conditional)));

List<EligibilityItem> get unknown => List.unmodifiable(
  (report?.items ?? const <EligibilityItem>[]).where((item) =>
    !item.completed && item.eligibility == null));
```

Keep blocked getter unchanged; no additional state field/emission. Remove UI's `item.eligibility ?? Eligibility.eligible` fallback. Build the new card from the domain item, with nullable tag handled explicitly:

```dart
class EligibilityItemCard extends StatelessWidget {
  const EligibilityItemCard({super.key, required this.item,
    required this.onDetails, this.warningMessages = const []});
  final EligibilityItem item;
  final VoidCallback onDetails;
  final List<String> warningMessages;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final tag = item.eligibility?.tag(strings);
    return PortalCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(item.course.code)),
          Text(strings.creditsValue(item.credits))]),
        Text(item.course.name, style: Theme.of(context).textTheme.titleMedium),
        EligibilityChip(label: tag?.label ?? strings.portalUnknownEligibility,
          color: tag?.color ?? AppColors.stateNeutral),
        Text(strings.semesterNumber(item.plannedSemester)),
        if (item.reasons.isNotEmpty) Text(item.reasons.first),
        TextButton(onPressed: onDetails, child: Text(strings.portalConditions)),
      ]));
  }
}

class EligibilityDetailsSheet extends StatelessWidget {
  const EligibilityDetailsSheet({super.key, required this.item,
    this.warningMessages = const []});
  final EligibilityItem item;
  final List<String> warningMessages;
  @override
  Widget build(BuildContext context) => ListView(shrinkWrap: true,
    padding: const EdgeInsets.all(AppDimens.portalPageInset), children: [
      Text(item.course.name), Text(item.statusText),
      for (final reason in item.reasons) Text(reason),
      if (item.requiredConcurrentCourses.isNotEmpty)
        Text(AppLocalizations.of(context).mustStudyTogether(
          item.requiredConcurrentCourses.map((course) =>
            '${course.code} · ${course.name}').join(', '))),
      for (final warning in warningMessages) Text(warning),
    ]);
}
```

RegistrationScreen changes to StatefulWidget, retaining `const RegistrationScreen({super.key, required this.semesterCode})` for router compatibility. Its State owns a local `bool _showBlocked = false`; body is Column with advice-only note, PortalTabs, Expanded ListView for the selected allowed/blocked items and a separate unknown section when nonempty. PortalTabs selected index derives from the bool; no cubit tab state. Add `(count)` as a separate numeric widget or supported formatted label with semantics, never count completed items or call them offered classes. Screen title uses portalEligibilityTitle; existing route stays registration.

For each card match report.warnings by warning.course.id == item.course.id. Show catalogue inactive/cancelled and main material warning on card, not only after a tap. Conditional cards **must show requiredConcurrentCourses code/name immediately** because it changes a plan; full messages/remaining warnings in sheet. Blocked shows first reason, falling back to statusText. Eligible must not show a fictitious “successfully enrolled” phrase. Unknown gets neutral label and full details action, never included in allowed count. Completed rows remain in report but are hidden from candidates.

**Layout:** blue toolbar/shared pale context, short advice-only note, two equal tabs “Can consider”/“Blocked” using existing registrationAllowed/registrationBlocked, then grey course cards. From dDUT `20261102-223735.jpg`/`20261101-163303.jpg`; badge from `20261102-223809.jpg`; reason detail headings from `20261102-223814.jpg`. Unknown section and advice-only note **no dDUT reference**. No utility pills, real registration cap/total, class search or submit action.

**States:** empty selected category uses portalNoCandidates, other tab remains actionable. Nonempty report with every item completed uses portalAllCompleted, not approved-graduation language. A truly empty report uses noData (do not claim all completed vacuously). Initial error/incomplete snapshot uses PortalStatePanel with retry/context guidance; not empty allowed. Material warnings remain available even when all courses are completed or no matching visible card exists: show an expandable warnings section below the result explanation rather than silently dropping them. Unsupported contract remains explicit.

**Rationale:** fix root null-coercion in `RegistrationState.allowed` rather than merely hiding a green badge (`lib/features/portal/presentation/registration/registration_state.dart:18`; `lib/features/portal/presentation/registration/registration_screen.dart:88`). Keep server advice authoritative.

**Gotchas:** conditional is not blocked; unknown not eligible; completed null is legitimate and excluded. Ordinal planned term is not selected calendar semester or a promise of offering. Retain semesterCode field only for signature compatibility; no duplicate visible term heading. No full graph or threshold arithmetic.

**Test shape:** create the screen-test file now; add `class MockRegistrationCubit extends MockCubit<RegistrationState> implements RegistrationCubit {}` to the listed harness. Follow CR-13's localized WidgetTester pattern with real synthetic EligibilityItem states, not production records.

**Verify:** `flutter test test/features/portal/presentation/registration_screen_test.dart test/features/portal/presentation/registration_cubit_test.dart`. Extend existing state test “registrable and blocked lists split open items and drop completed ones” with unfinished null verdict and unknown assertions; “without a report both lists are empty” also checks unknown. Preserve load/contract tests. Widget cases owned here cover filled two tabs/counts/conditional obligation/unknown/material warnings/empty/all-completed/incomplete response. Device captures each tab plus detail and unknown case. **Depends on:** CR-10.

### CR-12 — Graduation answer and shortfalls, not accounting

**Files — MODIFY:** `lib/features/portal/presentation/graduation/graduation_screen.dart`; `lib/features/portal/presentation/components/conclusion_banner.dart`; `lib/features/portal/presentation/components/shortfall_group.dart`; `test/support/portal_widget_harness.dart`. **NEW:** `test/features/portal/presentation/graduation_screen_test.dart`. No new domain/state/API/localization fields; CR-05 already owns the API safety change.

**Shape:** preserve ConclusionBanner's label/color/lines constructor, but caller supplies only the existing limitation in lines. Replace its generic outlined card with PortalCard/PortalBadge. Keep ShortfallGroup's title and `(String title,String message)` items; render compact wrapping rows with internal separators, category heading once.

```dart
class GraduationScreen extends StatelessWidget {
  const GraduationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PortalPage(title: strings.graduation,
      body: BlocBuilder<GraduationCubit, GraduationState>(
        builder: (context, state) {
          if (state.isLoading) return const LoadingSkeleton();
          if (state.errorMessage case final message?) {
            return PortalStatePanel(message: message, isError: true,
              onRetry: context.read<GraduationCubit>().load);
          }
          return switch (state.outcome) {
            GraduationReviewed(:final result) => _reviewed(context, result),
            GraduationCannotAudit(:final message) => PortalStatePanel(
              message: message, onRetry: context.read<GraduationCubit>().load),
            GraduationUnsupported() => PortalStatePanel(
              message: strings.unsupportedResultVersion),
            null => PortalStatePanel(message: strings.noData),
          };
        }));
  }

  Widget _reviewed(BuildContext context, GraduationResult result) {
    final strings = AppLocalizations.of(context);
    final tag = result.conclusion.tag(strings);
    return ListView(padding: const EdgeInsets.all(AppDimens.portalPageInset),
      children: [
        ConclusionBanner(label: tag.label, color: tag.color,
          lines: [strings.graduationInfo]),
        for (final category in ShortfallCategory.values)
          if (result.shortfalls.any((item) => item.category == category))
            ShortfallGroup(title: category.label(strings), items: [
              for (final item in result.shortfalls)
                if (item.category == category)
                  (title: item.title, message: item.message)]),
        if (result.shortfalls.isEmpty) Text(strings.portalNoShortfalls),
        if (result.shortfalls.any((item) =>
            item.category == ShortfallCategory.totalCredits))
          Text(strings.requiredEarnedMissing(
            formatDecimal(result.credits.requiredTotal),
            formatDecimal(result.credits.recognizedTotal),
            formatDecimal(result.credits.missingTotal))),
        PortalDisclosure(title: strings.portalEvaluationBasis, children: [
          Text(strings.evaluatedAt(formatTimestamp(result.evaluatedAtMs))),
          Text(strings.fieldValue(strings.version, result.versionNumber)),
        ]),
        TextButton(onPressed: () => context.push(RoutePaths.progress),
          child: Text(strings.portalCreditBreakdown)),
      ]);
  }
}
```

Complete material warnings after shortfalls (respect backend messages; no raw code log). Keep authoritative conclusion even if its shortfall list is unexpectedly empty; no “eligible” inference. Put the compact totals Text immediately beside/below the totalCredits shortfall group (move it into that category branch during completion, not after unrelated warnings). Use caption/body styling, wrapping at large text, never CreditProgressCard, a chart or a second hero. The supplied required/recognized/missing decimal values are authoritative; do not subtract or sum them. No totalCredits shortfall means no totals line, even when other zero-credit/course/group shortfalls exist. Existing `requiredEarnedMissing` label (`lib/l10n/app_vi.arb:175`) needs no new strings. Progress link opens ordinary Progress page with one-tap breakdown; no new query/state machinery. Remove imports/calls to CreditProgressCard, ElectiveGroupRow and KnowledgeBlockRow, not those components still used by Progress. Remove cohort, duplicate programme/semester/version banner lines and heading-styled disclaimer. Basis displays timestamp/returned version only; T56 omits provenance display, NOT T63's API response-ID validation.

**Layout:** compact conclusion/limitation, grouped missing-condition cards with a compact totals line supporting a total-credit shortfall, relevant warnings, collapsed basis and Progress link. Shared blue toolbar/card grammar from dDUT `20261102-223814.jpg`; whole audit composition/conditional totals line **no dDUT reference**. No second credit KPI wall.

**States:** CANNOT_AUDIT is a neutral diagnostic, not ineligible/red, no stale result; retry/change-context/back remain. Unsupported data has no conclusion; update/contact guidance via existing message/context controls, not a new service. Error distinct from successful no-shortfall review. Zero-credit conditional-course shortfalls remain visible because backend criteria, not credit count, govern them.

**Rationale:** preserve existing outcome switch (`lib/features/portal/presentation/graduation/graduation_screen.dart:49`) and existing correct limitation key, while reversing the administrative-first hierarchy.

**Gotchas:** do not claim the limitation is absent today; it is present as SectionHeader. No formal graduation recognition/decision/status API is introduced. Keep exact criterion messages and distinction between unspecified and zero requirements.

**Test shape:** create the screen-test file and MockGraduationCubit in the listed harness now; concrete signatures/example are retained under CR-13 as the shared pattern, with ownership assigned here. Use synthetic domain samples and localized labels.

**Verify:** `flutter test test/features/portal/presentation/graduation_screen_test.dart test/features/portal/presentation/graduation_cubit_test.dart`. Cases: eligible/ineligible/empty-shortfalls/warnings/zero-credit condition/CANNOT_AUDIT/unsupported/error, mismatch error suppresses conclusion, limitation visible below answer, basis collapsed, compact required/recognized/missing decimals beside total-credit shortfall only, absent for no shortfalls/course-only shortfalls, wrapping at large text, no cohort/group/knowledge-block accounting hero. Device captures reviewed and diagnostic states. **Depends on:** CR-11 (and CR-05 safety via the sequence).

### CR-13 — Aggregate regression, documentation and final acceptance

**Files — MODIFY (all screen files already exist from CR-08–CR-12):**

- `test/features/portal/presentation/portal_overview_screen_test.dart`
- `test/features/portal/presentation/syllabus_screen_test.dart`
- `test/features/portal/presentation/plos_screen_test.dart`
- `test/features/portal/presentation/progress_screen_test.dart`
- `test/features/portal/presentation/registration_screen_test.dart`
- `test/features/portal/presentation/graduation_screen_test.dart`
- `test/features/portal/presentation/portal_context_widgets_test.dart`
- `test/support/portal_widget_harness.dart`
- `docs/architecture/features_architecture.md`
- `docs/progress/current_work.md`

Each screen deliverable creates its own tests and extends the harness with its typed mocks before running its verification. CR-13 reuses that support and adds only aggregate/cross-screen coverage: context change invalidates all academic answers, navigation among seven destinations shares one context, and errors in one read do not leak to another destination. No screenshot binaries, golden dependency or private fixtures are added. Device captures are review artifacts, not application assets.

**Shape — shared test pattern:** use existing flutter_test/bloc_test/mocktail, real localized widgets and actual domain sample objects. This concrete Graduation test belongs to CR-12 when its test file is created, and is rerun/extended here:

```dart
void main() {
  testWidgets('CANNOT_AUDIT never presents an eligibility conclusion',
    (WidgetTester tester) async {
      final strings = await loadStrings();
      final cubit = MockGraduationCubit();
      final diagnostic = GraduationState(isLoading: false,
        outcome: GraduationCannotAudit(strings.noData));
      whenListen(cubit, const Stream<GraduationState>.empty(),
        initialState: diagnostic);
      final contextCubit = MockPortalContextCubit();
      whenListen(contextCubit, const Stream<PortalContextState>.empty(),
        initialState: portalContextStateSample());
      await tester.pumpWidget(portalHarness(contextCubit: contextCubit,
        child: BlocProvider<GraduationCubit>.value(value: cubit,
          child: const GraduationScreen())));
      expect(find.byType(ConclusionBanner), findsNothing);
      expect(find.text(strings.noData), findsOneWidget);
    });
}
```

`MockGraduationCubit` is NEW in the harness during CR-12; `MockPortalContextCubit` and `portalContextStateSample()` are NEW during CR-07 (and reused by CR-08). They are test support, not existing production APIs. Their concrete shapes are:

```dart
class MockGraduationCubit extends MockCubit<GraduationState>
  implements GraduationCubit {}
class MockPortalContextCubit extends MockCubit<PortalContextState>
  implements PortalContextCubit {}

PortalContextState portalContextStateSample() {
  final overview = overviewSample();
  return PortalContextState(isLoading: false, semesters: semestersSample(),
    overview: overview, selectedProgramId: overview.programs.first.programId);
}
```

Other typed screen-cubit mocks use the same actual MockCubit pattern. Implement sample using only existing synthetic domain_samples objects; do not load real records or screenshot text. Use the actual positional `GraduationCannotAudit(String)` constructor (`lib/features/portal/domain/model/graduation_outcome.dart:19`).

**Shape — narrow documentation synchronization:** update only the Curriculum section of `docs/architecture/features_architecture.md:10`: record feature-local PortalTheme/components, one visible context summary/read-only version/sheet and unchanged reset semantics, API reviewed-context validation, lazy optional equivalent evidence, PLO preview/disclosure, local Progress/Results selection, eligibility unknown partition, compact graduation support and screen-test locations. Correct the existing inaccurate “started semesters” wording to dated semesters, including future dates, and obsolete pending-test language only to match checks actually run. Keep Auth/Shell sections unchanged. In `docs/progress/current_work.md:3` replace the prebuild instruction with actual CR-01–CR-13 completion/check status and artifact locations. Record original 177-case preservation plus actual current counts, command outcomes and any incomplete device validation. Explicitly say **owner visual approval pending** until the owner has reviewed the finished result; never invent a future pass. Documentation updates require no owner answer or new architecture decisions.

**Rationale:** mirror `test/common/routes/app_router_test.dart` and existing portal cubit tests for async setup/localizations; add missing screen-level coverage rather than replacing the 177-case baseline with screenshot-only confidence.

**Gotchas:** use typed finders for purpose/actions, not pixel-position assumptions or production values. No existing portal widget finders exist to update (see §7). Do not weaken/remove old tests to reach a count. An interrupted command is not a passing check. Device captures must use synthetic approved data; never commit private screenshots.

**Verify:** future `flutter analyze`; `flutter test test/features/portal`; full `flutter test` must keep all original 177 tests green and increase count with new cases. Perform §7 device/state matrix after automated checks. Read the two docs against implemented paths and actual outputs; neither may claim unperformed checks or owner approval. **Depends on:** CR-08, CR-09, CR-10, CR-11, CR-12; no owner-response dependency.

## 6. Sequencing and pause

```text
CR-01 -> CR-02 -> CR-03 -> CR-04 ---+
                                 +-> CR-07 -> CR-08 -> CR-09 -> CR-10
CR-05 -> CR-06 -------------------+                              |
                                                             CR-11
                                                               |
                                                             CR-12
                                                               |
                                                             CR-13
                                                               |
                                                OWNER FINISHED-RESULT REVIEW

CR-07 capture = nonblocking owner review checkpoint, not a build stop.
```

1. Add listed strings and generate localizations (CR-01/CR-02). Add isolated style/context (CR-03/CR-04); do not restyle other pages yet.
2. Add optional existing-wire equivalent projection, mandatory reviewed-context validation and their tests; regenerate the reason decoder (CR-05/CR-06). No requests added to ordinary load and no graduation DTO/domain expansion.
3. Build Curriculum and its focused tests (CR-07). Run focused checks/analyze, capture device view and both sheets.
4. **Pause point after CR-07, before CR-08 — owner review checkpoint ONLY, not a stop for the build.** Capture Curriculum at normal/large text and term/filter/empty/equivalent states; label artifacts with the checkpoint ID. Apply Q1 tokens as specified. Do not ask for a response or infer owner approval; immediately continue. The owner inspects this checkpoint and finished-screen captures after the run.
5. Migrate launcher, syllabus, PLO/progress, advice and graduation (CR-08–CR-12), creating/running each screen's tests in its owning deliverable. Retain compatibility signatures until each old caller is removed. Run aggregate regression/cross-screen matrix and synchronize docs in CR-13. Do not postpone basic screen tests until CR-13.
6. Inspect every changed path against Files lists, every deleted symbol against §4.4, and every added l10n key/token against CR-01/§4.2. Do not allow late “small” shell changes.

Both planning and implementation are noninteractive. There is no owner-response dependency between CR-01 and CR-13. Automated failures or unavailable device tooling must be reported truthfully; they are not resolved by claiming visual approval. Complete all feasible implementation/automated work and record unavailable captures rather than substituting private screenshots. Final visual acceptance is pending the owner's subsequent review, not a prerequisite to finishing the build.

## 7. Verification strategy

### 7.1 Build commands for the later implementation session

No Flutter/Dart/package commands were executed to write this plan. The following are required **future** gates, not recorded passes:

| When | Command / acceptance |
|---|---|
| CR-02 | `flutter gen-l10n`; only expected localization outputs |
| CR-06 | `dart run build_runner build --delete-conflicting-outputs`; checked nested DTO projection reproducible; then all three CR-05 DTO/API/validator test files |
| CR-07 | Focused command listed in CR-07, then `flutter analyze`; capture nonblocking checkpoint and continue |
| After each remaining screen | Its specific new `flutter test test/features/portal/presentation/<screen>_screen_test.dart` plus affected existing cubit/DTO tests |
| CR-13 | `flutter analyze`, `flutter test test/features/portal`, then full `flutter test` |

Baseline **177/177** is the last documented run (`docs/progress/current_work.md:3`). Preserve those original cases and add tests: the final count should be higher, not exactly 177. The plan cannot establish the current runtime baseline without executing the prohibited commands. A missing SDK/device or unrelated existing failure is reported separately, not described as passing or “fixed” by deleting cases.

### 7.2 Existing tests and finder disposition

There are currently **no portal-screen widget tests with finders to update**. Inventing a list of existing portal finder migrations would be inaccurate. Actual inspected tests and dispositions:

| Existing file / named cases | Finder or expectation action |
|---|---|
| `test/common/routes/app_router_test.dart`: “a deep link while signed out is redirected to login”; “a signed-in student leaves splash for the home page”; forced-password and unknown-placeholder cases | **No existing finder updates**; portal gate extraction must preserve these route/auth assertions. Add deep-link/context coverage in new portal_context_widgets_test instead. |
| `test/features/shell/home_screen_test.dart`: signed-in student/tile list; curriculum tile opens route; unavailable tile placeholder; no user/no tiles | **No updates**; shell out of scope. Home still opens existing curriculum entry route. |
| `test/features/auth/login_screen_test.dart`, `test/common/widgets/startup_error_app_test.dart` | **No updates**; common theme/widgets retained. |
| `test/features/portal/presentation/curriculum_cubit_test.dart`: load success/failure; passed includes equivalent; term expansion/filter tests | No finder tests; old expectations unchanged, new optional evidence cases added in CR-07. |
| `test/features/portal/presentation/portal_context_cubit_test.dart`: “changing semester refetches and resets the program to the first one” | Unchanged expectation (D3); no finder migration. |
| `test/features/portal/presentation/registration_cubit_test.dart`: “registrable and blocked lists split open items and drop completed ones”; “without a report both lists are empty” | No finders; extend assertions/data for unknown verdict without weakening existing checks. |
| `test/features/portal/presentation/progress_cubit_test.dart`: independent failures, paging append/retry/stale response | Unchanged; local tab UI does not alter state/load behavior. |
| `test/features/portal/presentation/syllabus_cubit_test.dart`, `plos_cubit_test.dart`, `graduation_cubit_test.dart` in the same directory | Unchanged; regression gates for existing reads/download/outcome behavior. |
| `test/features/portal/data/portal_dto_test.dart`: “eligibility retains reasons, concurrency and completed records” and contract gates | Extend optional evidence checks; preserve all reason/concurrent/completed guarantees. |

New screen tests should use localized action labels and explicit `byType(PortalContextBar)`, `byType(ConclusionBanner)`, `byType(AssessmentTable)`/absence of DataTable, plus itemId/result.id keys. Future reflow should not require brittle ancestor-depth or offscreen-position finder changes. A State class is not a second Widget declaration; keep new Widget classes in separate files.

### 7.3 Automated behavior matrix

| Area | Required cases |
|---|---|
| Shared context | Loading, error/retry, no linked student, no dated semester, no programme, single vs multiple, applied version/noVersion visible without opening sheet, decision in sheet only, known future option, two fast switches, late result ignored, sheet dismissal and no cubit disposal, syllabus switch exits old item, one visible summary |
| Curriculum | No attempts still full frame, compulsory labels not totals, electives grouped/unnamed handling, passed-equivalent filter, empty frame vs empty filter, source fetch only on demand, cached/missing/failing/retried evidence, stale enrichment after reload/close, score nulls, syllabus absent/present, no identity/block/repeat wall |
| Syllabus | Assessment-first; long component/form; no horizontal table; optional empty sections; assessment-method HTML only after tap; objectives/teaching/reference/size absent even when supplied; pinned revision; attachment progress/disable/error retains data; missing pinned syllabus; no invented pass threshold |
| PLO | First-seen group/order, empty/error, two-line preview initially, independent one-tap full description/collapse, same-context rebuild stable, duplicate-code isolation, changed-context reset, long text, no attainment data |
| Progress | Independent audit/history successes/failures; CANNOT_AUDIT/unsupported/mismatched reviewed context; zero denominator/N/A; over-required cap; named block not gate; null vs zero group targets; filled tabs/scroll; repeat result IDs; main-score scale labels; paging failure retains loaded attempts |
| Eligibility | Eligible vs conditional vs blocked; completed exclusion; unfinished null separate; two tabs/counts; concurrency names immediately visible; warning/catalogue restriction visible; empty category/all completed/empty report distinguished; incomplete/unsupported never green |
| Graduation | Authoritative conclusion, existing limitation visible, categorized exact shortfalls, compact totals only for total-credit shortfall, zero-credit conditions, empty shortfall list not inferred approval, material warnings, basis collapsed, Progress link, diagnostic/unsupported/error/mismatch has no conclusion |
| API context safety | Exact student/programme/semester IDs; each mismatch and missing/null/wrong-type ID; malformed context; concurrent differently keyed responses; diagnostics and future schema unaffected; no received IDs leaked in error copy |
| Accessibility/style | Normal and large text at narrow width, long programme/course/reason strings, min touch targets, filled blue/white selected tab vs white/muted unselected plus shared baseline, selected/expanded semantics, contrast/readable status text, no clipped credit/grade/conditions, no nested vertical unbounded lists |

### 7.4 Device screenshots and visual acceptance

Use an Android device/emulator matching the owner's target, capture its logical viewport and text scale in review notes. Use only approved synthetic fixtures or a test account whose data may be captured. Do not commit the reference student's data, copy values into golden files, or contact an unapproved live endpoint. Save review artifacts outside production assets; if persistent artifacts become desired, obtain an explicit allowed path at build time.

| Screen | Captures required | Reference check |
|---|---|---|
| Curriculum (nonblocking checkpoint) | First view/current+next expansion, elective section/filter, empty filter, state/equivalent sheet, context sheet; normal/large text | `20261102-223814.jpg` card order/type/spacing, `20261102-223809.jpg` pill |
| Entry | Five destinations, context expanded; missing-context state | `20261101-163250.jpg`/`20261101-163257.jpg` spacing only |
| Syllabus | Assessment-first, expanded learning, attachment downloading/error | `20261102-223814.jpg` shared primitives; no full syllabus reference |
| PLO | Initially collapsed previews, individual full descriptions, long text and empty state | No screen reference; shared primitives pending final owner review |
| Progress/results | Credit KPI, expanded breakdown, Results list and attempt sheet, one independent failure | `20261101-163309.jpg` horizontal number hierarchy; no unsupported charts |
| Eligibility | Both tabs, conditional course detail, unknown/incomplete and empty category | `20261102-223735.jpg`, `20261102-223809.jpg`, `20261102-223814.jpg` |
| Graduation | Positive/negative review, credit-shortfall compact totals, basis, CANNOT_AUDIT | No full screen reference; shared primitives pending final owner review |

At the checkpoint, self-check relative hierarchy/density, not private text or pixel-perfect physical screenshot dimensions, and save evidence without stopping for owner input. Correct objective contract failures (generic outlined course cards, course title not blue/prominent, wrong numbers, duplicate context/identity tables); do not invent an owner's aesthetic approval. Recheck login/Home/Profile visually for accidental global changes; do not redesign them. Complete all screens and retain both checkpoint/final artifacts for later owner review.

## 8. Risks, owner questions and backend boundary

### 8.1 Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Approximate screenshot-to-dp interpretation | Another unattractive but technically correct restyle | CR-07 checkpoint plus final screen evidence; use specified defaults throughout, final owner visual review afterwards. |
| Global theme/component bleed | Scope violation in liked login/shell | Append-only constants; PortalTheme below route; keep common files in §4.3. |
| Modal provider/context lifetime | Wrong-context data or disposed cubit | BlocProvider.value, route keys, dismiss before change, leave old syllabus, concurrency tests. |
| Evidence endpoint failure | Equivalent completion explanation unavailable | Curriculum authoritative; lazy independent enrichment/retry, no downgrade. |
| Null verdict/model drift | False recommendation | Tight allowed predicate, neutral unknown branch, DTO/contract tests. |
| Excessive details on phone | Original wrong-data/wrong-place problem returns | Triage exclusions and one-tap disclosures; no parity checklists. |
| Legacy overview between gate and migration | Temporary duplicated old controls/identity remain | Explicit transitional state only; do not treat partial build as final acceptance. |
| Recorded baseline or generated outputs have drifted | False confidence or unrelated edits | Run fresh build gates later; inspect generation output and stop on overlap. |

### 8.2 Owner review questions — defaults applied, none blocking

These five review topics need no answer during the build. Per the owner's uninterrupted-run instruction, their defaults below are applied directly to the named deliverables. A later different preference is a follow-up change, not permission still needed to start or finish this plan.

| ID | Question | Applied default and owner deliverable |
|---|---|---|
| Q1 | Accept the proposed grey/pale-blue surfaces and logical-pixel density? | CR-03 appends exactly two sampled surfaces and uses all §4.2 dimensions; brand/status constants unchanged. CR-07 captures evidence and continues, not a density-choice gate. |
| Q2 | Which main result grade should lead? | CR-10: letter if supplied, otherwise labelled /10 then /4; all supplied scales one tap away. |
| Q3 | Is reset-to-first programme on semester change acceptable? | CR-04: preserve current tested behavior; show settled context clearly. T04 remains DROP; no retain-if-valid implementation. |
| Q4 | Should unknown advice be hidden or separately visible? | CR-11: neutral separate section, never allowed/green and never silently dropped. |
| Q5 | Must optional result-semester filter, structured evidence panels or version-source provenance be added now? | CR-10 omits T39 filter; CR-11 omits T48 duplicate structured panels; CR-12 omits T56 provenance display. These are explicit scope reductions, not backend gaps. T63 validation is mandatory in CR-05 and not waived by this default. |

Owner review topics: **5**; unanswered choices blocking a full build: **0**. All defaults are applied; no new backend-dependent choice is smuggled into a deliverable. T04/T39/T48/T56 remain documented intentional departures from the content spec, not claims that the owner separately approved each earlier reduction. The latest instruction explicitly authorizes using defaults without waiting.

### 8.3 Escalations — stopped, not designed

| Spec escalation | Missing capability | Disposition |
|---|---|---|
| E1 (`docs/design/screen-content-spec.md:617`) | Structured assessment conditional components/pass thresholds | NEEDS BACKEND; excluded. Show supplied assessment and documents, no full-formula claim. |
| E2 (`docs/design/screen-content-spec.md:618`) | Real dDUT registration/class/window/limit and GPA/conduct/chart services | NEEDS BACKEND/integration confirmation; excluded. Layout may be borrowed, data/actions cannot. |
| E3 (`docs/design/screen-content-spec.md:619`) | Per-omitted-programme applicability diagnostics | NEEDS BACKEND; generic truthful context gate only. |
| E4 (`docs/design/screen-content-spec.md:620`) | Authoritative complete prerequisite/downstream graph | NEEDS BACKEND; returned explanations only, no inferred absent relationships. |

No endpoint, field, request contract or backend implementation is designed for these gaps. No new backend need was introduced by the chosen build. Equivalent identity and credit breakdown use existing called endpoints. Shell-related spec questions remain outside this plan, not silently answered by changing shell.

### 8.4 Planning-run limits

This review run modifies only this plan. The earlier spec correction about the existing graduation disclaimer is retained unchanged; no content-spec edit occurs now. No application, tests, generated files, assets, backend or web source are modified. No git, Flutter, Dart, pnpm or node commands are run. Source review and document validation are not runtime/UI proof. Future implementation, 177-test regression run, device captures and owner visual approval remain not done by design. The build must execute all deliverables with the applied defaults; owner visual review follows the finished result.

## Execution Status and Deviations

Execution date: November 3, 2026. All source/test edits followed the approved sequence through CR-13; caller-deferred generation and unavailable runtime/device work did not stop independent deliverables. No git, Flutter/Dart, package-manager, device or network command was run. All patches used the resolved codex.exe apply-patch entry point, one file per patch. No generated files, dependencies, backend fields or unlisted production cubit/state/domain/data surfaces were edited. No additional agent was delegated. Parent review was non-editing.

### Per-deliverable handoff

The complete owned NEW/MODIFY/DELETE paths remain in each CR Files list above. Paths in this table highlight the implementation/test artifacts rather than replacing that manifest. "Authored" does not mean compiled or runtime-verified; every prescribed Flutter Verify command remains owed.

| Deliverable | Status and files/artifacts | Verification and remaining work |
|---|---|---|
| CR-01 | Authored `lib/l10n/app_vi.arb`: 37 exact portal strings and String placeholder metadata; existing keys retained. | PowerShell JSON/key/value/metadata checks; localization generation is CR-02. |
| CR-02 | Caller-deferred only: `lib/l10n/app_localizations.dart`, `lib/l10n/app_localizations_vi.dart` untouched. | `flutter gen-l10n` NOT RUN. New source getters intentionally depend on this step. |
| CR-03 | Authored append-only `app_colors.dart`/`app_dimens.dart` and listed portal primitives including `portal_theme.dart`, `portal_card.dart`, `portal_tabs.dart`; `portal_components_test.dart`. | Palette/marker/token scans below; widget checks NOT RUN. Reserved bottom padding exposes the shared tab baseline. Optional numeric counts preserve existing Progress callers. |
| CR-04 | Authored `portal_page.dart`, context bar/sheet/route, `no_context_panel.dart`, narrow `lib/common/routes/app_router.dart` wrapper migration. | Six original context keys retained. Context/gate and real-router tests authored in `portal_context_widgets_test.dart`; NOT RUN. Missing dated options gate even with a complete selected reference. |
| CR-05 | Authored optional evidence in `eligibility_reason_dto.dart`, `eligibility_item_dto.dart`, domain `eligibility_item.dart`; `graduation_context_validator.dart` and `portal_api.dart`; extended `portal_dto_test.dart`, new validator/API tests. | Exact/missing/null/type/malformed IDs, safe mismatch text, concurrent keys and diagnostic/schema gates covered in authored tests; NOT RUN. |
| CR-06 | Caller-deferred generated DTO refresh; no `.g.dart` file edited. | `dart run build_runner build --delete-conflicting-outputs` NOT RUN. Existing generated reason decoder does not yet project new optional fields. |
| CR-07 | Authored curriculum screen/state/cubit, details sheet and listed course/filter/term/status components; deleted `program_summary_card.dart`; `curriculum_screen_test.dart`, extended `curriculum_cubit_test.dart`, shared harness. | On-demand/cache/retry/stale/close evidence and named/unnamed electives covered in authored tests; NOT RUN. Initial in-progress fixture stays expanded; explicit unavailable-syllabus synthetic case added. Device checkpoint NOT CAPTURED; continued through CR-13. |
| CR-08 | Authored overview and `portal_menu_list.dart`; deleted `student_summary_card.dart`, `program_switch.dart`, `semester_picker.dart`; `portal_overview_screen_test.dart`. | Five actual navigation targets, initial version, identity omission and Home back tests authored; NOT RUN. Deleted exact symbol references scan is zero. |
| CR-09 | Authored syllabus and listed assessment/header/HTML/CLO/week/attachment components; `syllabus_screen_test.dart`. | Assessment/disclosure/exclusion/empty/download-error/pending/long-form cases authored; NOT RUN. Existing PortalCard interface retained, no legacy padding arguments. |
| CR-10 | Authored PLO preview tile/screen, Progress local views/breakdown/attempt sheet and listed KPI/result/group/block components; `plos_screen_test.dart`, `progress_screen_test.dart`. | Independent panes while aggregate loading, preview identity/reset, numeric scales, repeat attempts, paging errors, null/zero targets, zero/capped KPI and large text covered; NOT RUN. Existing PLO/Progress cubit/state files unchanged. |
| CR-11 | Authored strict `registration_state.dart` partition, registration screen/details and eligibility card/chip; extended `registration_cubit_test.dart`, new `registration_screen_test.dart`. | Unknowns are neutral, counts separate numeric widgets, completed items excluded and conditions/warnings reachable; tests NOT RUN. |
| CR-12 | Authored graduation screen/conclusion/shortfall components; `graduation_screen_test.dart`. | Authoritative outcomes, categorized/zero-credit conditions, conditional compact totals, collapsed basis, ordinary Progress link, non-reviewed suppression and large text tests authored; NOT RUN. |
| CR-13 | Authored aggregate real-router context tests and screen accessibility/error coverage, reused `test/support/portal_widget_harness.dart`; synchronized only Curriculum architecture and current-work docs. | Static checks below executed. Analyzer, focused/portal/full suites, runtime counts, device captures and final owner review remain pending. No screenshot binaries added. |

### Actual static evidence

Executed both required PowerShell scans verbatim; neither emitted a match. Explicit counts:

```text
hex outside palette=0; plan markers in lib=0
unresolved color/dimension references=0
deleted-symbol references (exact names)=0
router keyed providers=6
missing local Dart imports/parts (directives only)=0
planned portal localization keys=37; missing=0
```

An initial broad symbol regex matched preserved `programSwitchCount`, and an unanchored import regex matched generated localization documentation. Rechecking exact symbol boundaries and actual import/part directives removed those false positives; no unrelated token or generated file was changed to silence them. Source/constructor/domain checks were read-only review, not a substitute for the analyzer.

Fourteen touched test files contain 105 source test declarations, including existing retained cases and before parameterized loops expand; this is NOT a test-run total. All seven screen suites plus component/context suites, DTO/API/validator coverage and existing curriculum/registration cubit tests are present. Historical 177/177 remains the prior recorded baseline, not a new pass. No existing failing test was observed or repaired because runtime commands were not permitted.

### Deviations and borderline calls

- Real credits/score fields remain decimal Strings and `formatDecimal(String)` preserves trailing zeros while replacing the decimal separator; result-details skeleton corrected above for consistent localized scales. The assessment fixture expectation is `100,00`, not `100`. Syllabus revision is the real int consumed by existing `revision(int)`; no string conversion or domain change.
- Semester options use `Semester` (including String academicYear), while `PortalOverview.semester` is `PortalSemesterRef`; aggregate test response construction uses the real reference type. No context/state contract was expanded. `PortalContextState.context` alone does not require dated options, so the gate additionally checks the existing semesters list.
- Progress aggregate `isLoading` stays true until both reads finish; pane rendering checks received success/error fields first. No Progress state/cubit modification or new request was introduced. Semantic result-ID keys distinguish repeated courses.
- `PortalTabs` adds optional `List<int>? counts` with matching-length assertion, separate numeric Text and merged button semantics, as permitted by CR-11; plain localized labels remain unchanged. Progress omits counts. Reserved baseline padding prevents opaque fills obscuring the border. No extra ARB key.
- Null/blank elective group names are not requirements: render separate elective rows without choose-within-group text; named groups retain first-seen identity/order. Legacy constructor arguments on compatible components are retained where needed; PortalCard keeps its planned child/color/elevation interface.
- Audit-reported test defects were corrected in newly authored tests, not by weakening existing baseline cases: initially expanded curriculum fixture, exact decimal weight, stream subscription established before widget pump, and actual duplicate-code PLO isolation.
- Removed components' callers were migrated before deletion: program summary to shared context, student summary omitted, program/semester switches to context sheet; no old exact symbols remain. The private router gate became PortalRoute with all six keys preserved; nonportal routing behavior remains outside scope. LoadingSkeleton import remains for the unchanged splash.
- The documentation-sync skill's broader git/extra-doc/marker instructions are overridden by this task's explicit no-git and three-document ownership fence. Only this plan, Curriculum architecture and current-work documentation were changed.

### Escalations and caller work

No unresolved product/signature/scope decision required new implementation. Existing backend exclusions E1–E4 remain stopped exactly as approved; no backend/dependency alternative was implemented. No unexpected overlapping parent edits were encountered.

The verification fence is an explicit handoff, not an implementation blocker: run CR-02 generation, then CR-06 generation, CR-05 tests, CR-07/screen/context focused checks, analyzer, portal suite and full suite using §7.1 commands. There is no output for those commands because they were NOT RUN. Run formatting in the caller environment if needed; no formatter command ran here. Review generated output scope before accepting it.

Device/runtime work is unfinished: normal/large-text narrow-device walkthrough, attachment opening, all §7.4 captures including the nonblocking CR-07 reference state/sheets, and final owner visual review. No personal screenshot values, private artifacts or screenshots were used as validation evidence. **Owner visual approval pending.**

## Review response

Verified against the read-only independent report, current source, unchanged content spec, and re-viewed `design/20261102-223735.jpg`, `20261101-163303.jpg`, `20261102-223814.jpg`, `20261101-163309.jpg`. Only layout/structure was used; no personal values were copied. Findings 1–9 preserve the report's numbering; 10 addresses its separate Escalations finding. Totals: **8 accepted / 1 rejected / 1 partly**. No finding remains undecided.

| # | Finding | Verdict (accepted / rejected / partly) | What changed or why not |
|---|---|---|---|
| 1 | Sampled surfaces violate the palette requirement | rejected | The owner's original plan brief explicitly permits a new named approximate colour when the dDUT palette lacks it, marked sampled from its image. Current `lib/common/theme/app_colors.dart:3` has neither surface; re-viewed course/KPI references support the two proposed surfaces. CR-03 preserves EVERY existing constant/value, adds only portalCourseSurface/portalSummarySurface, and does not change brand/status colours or global theme. No additional approval dependency is justified. D13 clarifies this boundary. |
| 2 | Underline tabs contradict the cited screenshots | accepted | Both tab images show blue filled selected tabs with white text, white/muted unselected tabs, top-only rounding and a common baseline. §4.2/CR-03 now specify and shape that treatment, remove the selected underline token, and test fill/foreground/shape as well as semantics. Applies to eligibility and Progress/Results. |
| 3 | T56 wrongly drops returned-context validation along with provenance display | accepted | Route keys at `lib/common/routes/app_router.dart:224` do not inspect response IDs. Existing backend context has IDs (`backend/features/graduation/graduation.dto.ts:39`); client outcome decoding is `lib/features/portal/data/remote/dto/graduation_outcome_dto.dart:28`. T56 now drops display only; T63/CR-05 require exact response/request ID equality at PortalApi before returning reviewed data, with validator/API mismatch tests and Progress/Graduation error states. No backend or domain-field expansion. |
| 4 | PLO descriptions remain all-expanded through CloList | accepted | `lib/features/portal/presentation/components/clo_list.dart:17` renders full descriptions; spec §2.6 requires preview/expand. CR-10 replaces only the PLO caller with a new per-outcome StatefulWidget: two-line preview, independent full-text expansion, complete-context/group/code/index identity, same-context stability and reset/isolation tests. Syllabus CLOs remain inside their own learning disclosure. |
| 5 | Syllabus restores excluded narrative/size content and expands assessment explanation | accepted | Verified spec §2.5 exclusions and available fields at `lib/features/portal/domain/model/syllabus.dart:30`; current byte-size display is `lib/features/portal/presentation/components/attachment_tile.dart:30`. T25/T26/T28 and CR-09 now exclude objectives/teaching/reference panels and size text entirely; assessmentMethods is explicitly collapsed in assessment until tapped. Added negative-content and disclosure cases. |
| 6 | Shared summary hides the applied version required at entry | accepted | `lib/features/portal/domain/model/portal_program.dart:18` already supplies nullable versionNumber; spec §2.3 requires immediate applicability. D4/§4.2/CR-04/CR-08 now show version or noVersion in the ONE shared summary, with wrapping and initial-view tests. Decision details remain in sheet; no second programme card. |
| 7 | Deferred screen-test files make per-screen verification impossible | accepted | Original CR-08–CR-12 Verify clauses referred to files created only in CR-13. Each screen deliverable now owns its NEW screen-test file(s), typed harness support and required cases before its check. CR-13 modifies already-created tests only for cross-screen/aggregate regression. §6/§7 follow the same ownership. |
| 8 | Graduation omits compact credit-shortfall support | accepted | Spec §2.9 retains compact totals; existing `lib/features/portal/domain/model/graduation_credits.dart:13` supplies them. T64/CR-12 show existing localized required/recognized/missing totals adjacent to totalCredits shortfalls only, with positive/negative/wrapping tests. No accounting hero or credit recomputation. |
| 9 | No deliverable synchronizes architecture/progress documentation | accepted | Current `docs/architecture/features_architecture.md:10` and `docs/progress/current_work.md:3` describe pre-redesign state. CR-13 now explicitly owns narrow updates recording implemented feature boundaries, context/evidence/safety/UI/test structure, real verification results and visual-approval-pending status. No unrelated docs are listed. |
| 10 | Separate escalation: T04/T39/T48 reductions lack evidenced owner acceptance | partly | Accept the need to label intentional reductions, not imply retrospective approval. Verified reset behavior at `lib/features/portal/presentation/context/portal_context_cubit.dart:93` and its test; page-only result calls at `lib/features/portal/domain/use_case/portal_use_cases.dart:40`; reason messages at `lib/features/portal/data/remote/dto/eligibility_reason_dto.dart:12`. Retain explicit phone-value reductions and apply Q3/Q5 defaults in CR-04/CR-10/CR-11/CR-12. Reject waiting for further permission: the owner's NEW instruction requires all deliverables in one run with defaults applied. §0/§6/§8 remove owner-response stops; final visual acceptance is still pending, never claimed. |
