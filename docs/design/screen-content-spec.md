# Student App Screen Content Specification

Date: November 2, 2026. Scope: content ownership and navigation for a later Flutter redesign, not an implementation plan or visual design. No application or backend changes are proposed as part of this document.

The governing rule is **one screen, one quick student question on a phone**. The student is checking something inside dDUT, not conducting a desktop portal session. **dDUT screenshots are the visual and structural reference; the web portal only establishes available data. Web parity is not a goal.** An API returning a field does not earn that field a place on a phone screen. Put the answer first, leave useful explanations one tap away, and leave desktop accounting out.

## Evidence and reading conventions

All app paths are relative to `E:/PBL6/dut_curriculum_app`. Backend and web filename citations below resolve through this source index; their line numbers refer to the inspected source, not generated API types. All nine JPGs in `design/` were individually viewed after the owner lifted the image restriction for that folder only. Their layouts, not personal contents, inform this specification. No screenshot name, email, student code, photo content, grade, or other personal value is reproduced; placeholders such as `<student name>` stand for identity. No credentials or prohibited private datasets were read.

| Citation filename | Canonical read-only source |
|---|---|
| `student-portal.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/student-portal/dto/student-portal.dto.ts` |
| `student-portal.controller.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/student-portal/student-portal.controller.ts` |
| `student-portal.service.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/student-portal/student-portal.service.ts` |
| `student-portal.errors.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/student-portal/student-portal.errors.ts` |
| `semester.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/shared/releases/semester.dto.ts` |
| `semesters.controller.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/semesters/semesters.controller.ts` |
| `me.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/auth/me.dto.ts` |
| `auth.controller.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/auth/auth.controller.ts` |
| `change-password.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/auth/change-password.dto.ts` |
| `login.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/auth/login.dto.ts` |
| `password-policy.ts` | `E:/PBL6/curriculum-management/source/backend/src/shared/password/password-policy.ts` |
| `academic-result.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/students/dto/academic-result.dto.ts` |
| `student-query.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/students/dto/student-query.dto.ts` |
| `students-read.service.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/students/students-read.service.ts` |
| `students.controller.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/students/students.controller.ts` |
| `registration-eligibility.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/registration-eligibility/dto/registration-eligibility.dto.ts` |
| `registration-eligibility.controller.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/registration-eligibility/registration-eligibility.controller.ts` |
| `eligibility-evaluator.ts` | `E:/PBL6/curriculum-management/source/backend/src/shared/registration-eligibility/eligibility-evaluator.ts` |
| `eligibility.errors.ts` | `E:/PBL6/curriculum-management/source/backend/src/shared/registration-eligibility/eligibility.errors.ts` |
| `graduation.dto.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/graduation/graduation.dto.ts` |
| `graduation.controller.ts` | `E:/PBL6/curriculum-management/source/backend/src/features/graduation/graduation.controller.ts` |
| `graduation.errors.ts` | `E:/PBL6/curriculum-management/source/backend/src/shared/graduation/graduation.errors.ts` |
| `applied-version.errors.ts` | `E:/PBL6/curriculum-management/source/backend/src/shared/releases/applied-version.errors.ts` |
| Portal page filenames ending in `.tsx` | `E:/PBL6/curriculum-management/source/frontend/src/features/student-portal/pages/` followed by the cited filename |
| `PortalContextBar.tsx`, `StudentLayout.tsx` | `E:/PBL6/curriculum-management/source/frontend/src/features/student-portal/components/` followed by the cited filename |
| `usePortal.ts` | `E:/PBL6/curriculum-management/source/frontend/src/features/student-portal/hooks/usePortal.ts` |
| `AcademicResultsTable.tsx` | `E:/PBL6/curriculum-management/source/frontend/src/features/students/components/AcademicResultsTable.tsx` |
| `GraduationResultView.tsx` | `E:/PBL6/curriculum-management/source/frontend/src/features/graduation/components/GraduationResultView.tsx` |

Requirements baseline: sister-repository `docs/design/screen-inventory.md:146` defines MH-55 through MH-59; `:489` defines the PLO destination and `:490` the syllabus destination. `docs/planning/user-stories.md:1126` through US-097 covers correct assigned version, equivalent-course evidence, progress, registration advice, pinned syllabus, and phone access. Student requirements are `docs/requirement/REQUIREMENTS.md:574` (FR-88 onward), with registration/graduation rules at `:565`. The dDUT shell baseline is this app's `docs/implementation/f-28-ddut-replica-curriculum-app-implementation-plan.md:607` through S-05. This specification deliberately changes content placement where that replica plan or the web conflicts with the owner's complaint.

“Primary” means necessary for the quick answer on first view. “Secondary” means a purposeful explanation reachable in one tap through an expander, sheet, or existing destination, not another full table on the landing view. Every table's grouping column explains why the data earns phone space. “Left out (web only)” means deliberately omitted from this phone flow, even if available; it does not imply every such field is actually rendered by the inspected web. IDs remain internal. A dash means unavailable, never zero. Static copy, navigation labels, device time, and entered inputs are not API response fields. Layout annotations distinguish direct/borrowed dDUT patterns from screens with no matching screenshot; borrowed patterns never authorize copying unsupported functionality.

## dDUT reference screens

These are observations of nine screenshots, not measurements of logical pixels or claims about interactions outside the captures. Spacing is described relationally. No personal numbers or records are transcribed.

### `20261101-163230.jpg` — Sign-in landing

- **Top to bottom:** full-height blue gradient; large centred institutional wordmark in the upper area; generous open space; bold white welcome heading; smaller centred explanatory copy; wide white rounded sign-in button; faint technical linework toward the bottom. No cards, tabs, app bar, or bottom navigation.
- **Components/density:** single hero/CTA composition, broad side insets, large vertical gaps, one action rather than a form-heavy first view.
- **Typography:** wordmark first, large heavy welcome text second, lighter multiline explanation third, strong uppercase button label. Text contrasts against the blue field.
- **Status/numbers:** no student identity, grades, counters, or academic status. Authentication-provider copy describes the real app, not a backend capability to assume here.
- **Maps to:** app Sign-in landing. Copy the composition, not the screenshot's institutional SSO claim; the app uses its existing local-account form.

### `20261101-163250.jpg` — Home, upper feature grid

- **Top to bottom:** pale-blue page; blue rounded identity header with circular avatar slot, `<student name>`, `<student email>`, and right bell; white rounded date/schedule card split vertically into a narrow date column and larger illustration/message column; two-column feature-tile grid; floating white pill bottom navigation with Home and Profile icons and a short blue active indicator above the selected icon.
- **Components/density:** ample outer gutters; large rounded, softly shadowed white tiles; centred icon above centred label; substantial vertical breathing room. The date panel's sides are simultaneous columns, not stacked sections.
- **Typography:** identity name heavier/larger than subtitle; numeric day is the dominant date element; weekday is bold; tile labels are bold blue and can wrap.
- **Status/numbers:** date is a large numeral plus smaller calendar labels; schedule state is a sentence, not a numeric badge. No course or account-statistics dump.
- **Maps to:** app Home and shell bottom navigation. The added Curriculum tile is a deliberate product addition; no screenshot schedule assertion or real avatar is reusable data.

### `20261101-163257.jpg` — Home, lower feature grid

- **Top to bottom:** the same identity header and split date card remain visible; the grid shows later feature categories, including support/community/service entries; the same two-icon floating bottom pill remains at the bottom.
- **Components/density:** consistent equal-width two-column cards, large corner rounding/shadows, centred icon-over-label arrangement, generous gaps; labels wrap rather than creating smaller secondary controls.
- **Typography:** blue, bold, centrally aligned feature names; quieter calendar message and identity subtitle. Lower tiles retain the same hierarchy as upper tiles.
- **Status/numbers:** no feature badge counts are visible; selected navigation is communicated by colour/line, not text totals.
- **Maps to:** Home's lower tiles and their placeholder entry points. It is a second view of Home, not a distinct student screen; do not duplicate the header inside every destination.

### `20261101-163303.jpg` — Course registration, registered tab

- **Top to bottom:** solid-blue toolbar with white back arrow and centred title; pale-blue rounded semester/registration-state panel; row of pill utility actions; two large tabs with filled-blue active tab; pale-blue registered-credit summary and smaller explanatory/legend copy; section heading; vertically stacked light-grey rounded class cards with status pill and a small outlined detail action.
- **Components/density:** more information-dense than Home, but separated into cards with broad margins and clear gaps. No shell bottom navigation is visible in this capture.
- **Typography:** blue semester heading; red closed-state emphasis; bold credit summary; blue course names; muted metadata; bold subsection title. Card details remain smaller than course identity.
- **Status/numbers:** registration state uses text plus colour; selected tab contains a count; summary emphasizes credits; each class card shows a green state pill and compact numeric metadata. No captured values are copied.
- **Maps to:** Credit registration placeholder as the actual feature reference; its toolbar/tab/card grammar can be adapted to Registration eligibility, with different labels and no fabricated enrolled classes, limits, or registration status.

### `20261101-163309.jpg` — Academic affairs summary

- **Top to bottom:** solid-blue toolbar with back/title/bell; pale-blue rounded summary with a large leading academic metric separated by a vertical divider from stacked facts; a simple outcome-related card; rounded panels containing titled line charts for trends. No bottom tabs are visible.
- **Components/density:** generous outer gutters and gaps; concise summary first, then vertically stacked analytic cards. Summary is a horizontal KPI block, not six equal label/value rows.
- **Typography:** one very large blue metric; smaller bold labels and emphasized values to its right; black bold chart titles; muted chart furniture.
- **Status/numbers:** summary numbers get typographic emphasis; charts use blue lines/point markers and dashed grids. No personal metric, grade, conduct score, study-year value, or axis values are transcribed.
- **Maps to:** the visual hierarchy of Progress & results, and the Academic affairs placeholder for the full real feature. Use recognized credits as the supported leading metric; GPA/conduct/trend/PLO-attainment content is not available in the app's current contracts and is not specified for implementation.

### `20261102-223735.jpg` — Course registration, available-courses tab / closed state

- **Top to bottom:** blue back/title toolbar; pale-blue semester/state panel; three pill utility actions; the available-courses tab selected in blue beside the registered tab; bordered rounded information row; otherwise open white space.
- **Components/density:** compact controls at top, then a single honest empty/state message; no placeholder class cards and no artificial long list.
- **Typography:** blue heading, red state phrase, subdued explanatory copy; active tab has white bold text; information row uses a neutral icon and body text.
- **Status/numbers:** semester/state and tab count have dedicated locations; closure is described explicitly, not inferred from a blank list. No captured count/limit is reused.
- **Maps to:** Credit registration placeholder; Registration eligibility borrows the two-tab and contextual-message arrangement only. “Advice unavailable” must not become “School registration is closed” without such API data.

### `20261102-223809.jpg` — Course registration, registered list confirmation

- **Top to bottom:** same blue toolbar, semester/state summary, utility pills, and tab pair; registered tab active; credit-summary card; legend; registered-class heading; stacked light-grey course cards with right-side status and detail action.
- **Components/density:** repeated capture confirms the registered-tab structure observed in `20261101-163303.jpg`; broad card insets with compact stacked metadata within each card. No bottom navigation visible.
- **Typography:** large summary/section hierarchy, blue course title, darker identifier, muted supporting rows, small outlined action.
- **Status/numbers:** badge, tab count, registered-credit summary, and per-card numeric metadata are distinct UI roles; do not collapse them into an unlabeled number or reuse their values.
- **Maps to:** Credit registration placeholder, with reusable course-card structure for the supported Eligibility flow. It is not evidence that the app backend can return registered sections.

### `20261102-223814.jpg` — Course constraints

- **Top to bottom:** blue back/title toolbar; blue planned-term section heading; vertically stacked pale-grey rounded course cards; each starts with muted code/credits, then bold blue course name, bold prerequisite/prior-study subsection and bullet explanations, followed by a downstream-impact subsection and an italic empty-state line when applicable.
- **Components/density:** full-width cards with generous internal padding and gaps; short data header, readable relation text below; no table, chips-as-entire-explanation, utility toolbar, or bottom nav.
- **Typography:** course names and planned-term heading in blue; subsection labels bold black; explanatory lines regular; absence of relationships muted/italic.
- **Status/numbers:** credits sit beside the course code; relation evidence includes results inline, but no personal value is transcribed. Meaning is primarily expressed in readable text, not a lone traffic-light badge.
- **Maps to:** Curriculum course-card hierarchy and the expanded Registration eligibility reason/concurrent-course detail. Only returned eligibility reasons are displayed; full downstream graphs and a complete requisite catalogue are not assumed available.

### `20261102-223821.jpg` — Community activities list

- **Top to bottom:** blue back/title/bell toolbar; pale-blue body; wide rounded search field with trailing filter icon; stacked white rounded activity cards; each has a left thumbnail/status column and a right title/organizer/metadata column, with a right-side reward indicator and action where available; bottom pagination and floating round menu action.
- **Components/density:** large gutters and soft card shadows; medium-to-dense card interiors using icon-led metadata rows, with clear inter-card separation. A bottom page strip is not the Home/Profile navigation pill.
- **Typography:** bold multiline activity title, italic organizer, muted description/metadata, coloured status labels, strong pill action. Long text truncates locally rather than widening the page.
- **Status/numbers:** status is a labelled tinted rectangle; capacity, date range, location, and reward count use different icon/label treatments; active pagination is filled blue. None of the screenshot values or event records is reproduced.
- **Maps to:** Community activities placeholder only. Its future list structure is documented, not populated with fake activities, filters, paging totals, reward points, or a functioning enrolment action.

## 1. Navigation and ownership

```text
Authentication gate -> forced change password when required -> app shell
  Home tab
    Home header -> Profile; notification bell -> Notifications placeholder
    Curriculum tile -> Curriculum area entry / overview
      Shared academic context control
      Curriculum -> pinned Syllabus detail -> attachment open/download
      PLOs
      Progress & results
      Registration eligibility (advice only)
      Graduation review (live, read-only)
    Academic results tile -> existing Progress & results through context gate
    Other dDUT tiles -> named placeholders
      Credit registration placeholder -> optional existing eligibility-advice link
  Profile tab -> Change password; confirmed sign out
```

**Layout decisions — from dDUT 20261101-163250.jpg and from dDUT 20261101-163257.jpg:** Home and Profile are the two shell tabs, rendered as the floating pill pattern, not a portal tab bar. **Layout decision — from dDUT 20261102-223814.jpg:** academic child screens use a back/title toolbar rather than repeating the identity header. **Layout decision — no dDUT reference:** the new curriculum-area navigation and shared academic context have no direct screenshot; keep them compact and compatible with that toolbar/card grammar. The bell is not a third data-backed tab. Preserve a return to Home and access to academic siblings in at most two taps within the area. The results shortcut reuses an existing screen. Other placeholders identify their unavailable feature honestly.

Existing mobile route identities are in `lib/common/routes/route_paths.dart:5`. Web correspondence is `../curriculum-management/source/frontend/src/routes.ts:64`: `/student` = academic entry, `/student/curriculum` = curriculum plus embedded web PLOs, `/student/curriculum/:itemId` = syllabus, `/student/progress`, `/student/registration`, and `/student/graduation` = their corresponding mobile destinations. There is no separate web PLO route in this route group; the phone may give the existing PLO endpoint its own destination.

### 1.1 Programme, semester, and version context: one owner

**Layout decision — no dDUT reference:** place one **academic context control owned by the curriculum-area shell**, introduced on entry and available from each academic destination. One compact summary and one edit sheet are enough; do not put independent selector forms or full programme cards in each screen body. Returning to entry must not be necessary merely to discover the current programme or semester. This control is justified to avoid showing the wrong curriculum, not because the web has selectors.

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Available programmes: code, name, primary/second-major label | `programs[].programCode`, `.programName`, `.enrollmentType` — `student-portal.dto.ts:39`, `student-portal.dto.ts:40`, `student-portal.dto.ts:42` | primary | Programme choice first; primary first; use code/name as well as enrollment label to distinguish multiple second majors. |
| Selected academic semester and choices | `semester.semesterCode` — `student-portal.dto.ts:50`; options `semesterCode` — `semester.dto.ts:7`; known-start-date eligibility — `semester.dto.ts:11` | primary | Semester choice second; show a semester code, not a raw ID. |
| Applied curriculum version | `programs[].versionNumber`; request identity `versionId` — `student-portal.dto.ts:44`, `student-portal.dto.ts:43` | secondary | Derived label under the programme; never a freely editable version selector. |
| Resolution/link availability | Nullable `student`, `semester`, and `programs` — `student-portal.dto.ts:55`, `student-portal.dto.ts:57`, `student-portal.dto.ts:58` | primary | A gate before any context-dependent body. No guessed programme or version. |

The context tuple is the signed-in student's ID plus `programId` and `semesterId` (`student-portal.dto.ts:23`, `student-portal.dto.ts:24`; `lib/features/portal/domain/model/portal_context.dart:10`). The backend resolves the applicable version. Programme/version choices must not be inferred from cohort strings or exposed as a global catalogue. The default semester is the backend's latest started semester, falling back to the earliest known dated semester (`student-portal.service.ts:60`); options with unknown start dates cannot establish a reliable context. Known future semesters can be selectable; a known date does not mean the semester has started (`lib/features/portal/data/portal_repository_impl.dart:23`).

When the semester changes, reload available programmes and the derived version, retain the selected programme only if returned as valid, otherwise use the first valid programme. Keep this settled selection throughout navigation in the area; clear student-dependent content on sign out/account change. On a deep link, resolve the same shared context before requesting the page; an old syllabus item must not silently open another item's syllabus. During a switch, hide or clearly suspend the previous context's answer until the new answer settles. The web already keys requests by programme/semester (`usePortal.ts:23`) and clears the URL programme choice on a semester switch (`usePortal.ts:65`).

**Three meanings must stay separate:** the selected academic semester determines the applicable version and results cutoff; `plannedSemester` is the curriculum's ordinal term; `resultSemesterId` filters recorded attempts without changing the selected programme/version (`student-query.dto.ts:84`, `student-query.dto.ts:89`, `student-query.dto.ts:94`). The optional results filter is not a second global context selector. Do not label the selected context “next semester” automatically.

### 1.2 Student identity: Home header and Profile only

Home may identify the signed-in person briefly; Profile owns student code, cohort, major, study status, and account/contact details. Academic entry, curriculum, PLOs, syllabus, results, eligibility, and graduation do not need a student identity card. All these views are already “mine”; no student picker is permitted. The web's `PortalHomePage.tsx:19` mixes identity and programme metadata because it is the portal home, not because identity is curriculum content.

There are **no student-identity exceptions** in the proposed academic screens. In particular, remove cohort from the graduation banner even though the shared web component shows it (`GraduationResultView.tsx:48`). Evaluation time and applied-version source are legitimate **audit provenance**, not personal identity; the graduation section explains their placement. Programme code/name is academic context, not a substitute identity card.

### 1.3 Existing endpoint boundary

Use only existing student-authorized reads: `GET /portal/me`, `/portal/curriculum`, `/portal/plos`, `/portal/curriculum-items/:itemId/syllabus`, and the attachment file route (`student-portal.controller.ts:32`, `student-portal.controller.ts:43`, `student-portal.controller.ts:54`, `student-portal.controller.ts:65`, `student-portal.controller.ts:77`); `GET /semesters` (`semesters.controller.ts:19`); `GET /students/:studentId/results` (`students.controller.ts:87`); `GET /students/:studentId/registration-eligibility` (`registration-eligibility.controller.ts:14`); and live `GET /students/:studentId/graduation` (`graduation.controller.ts:57`). Auth uses `GET /auth/me` and `POST /auth/change-password` (`auth.controller.ts:75`, `auth.controller.ts:88`). The app already calls the academic endpoints (`lib/features/portal/data/remote/portal_api.dart:38`). No save-audit, enrolment, registration, or staff editing action belongs here.

### 1.4 State rules applying to every academic screen

- **Loading:** show the page purpose and shared context, with placeholders for the requested content; no invented zero counts, “eligible” badges, or earlier context's results.
- **Missing link:** “This account is not linked to a student record. Contact Academic Affairs.” Home/Profile still work. No academic request requiring a student ID is made (`student-portal.dto.ts:55`).
- **Missing context:** distinguish no dated semester from “No applicable programme could be determined for this semester”; offer the single context control, retry, and contact guidance. Do not assert “not enrolled”: the backend omits programmes whose resolver fails (`student-portal.service.ts:166`). Specific per-programme diagnostics are an escalation, not inferred content.
- **Request error:** keep the context and screen title, give a comprehensible explanation plus retry/back/change-context. Expired authentication returns to the existing sign-in gate. A forbidden/missing resource is not a successful empty result.
- **Partial:** preserve independent successful sections and retry only failed content where practical. Label unknown content as unavailable, never as an empty successful calculation. Incomplete snapshots are configuration/data problems (`applied-version.errors.ts:10`, `eligibility.errors.ts:4`, `graduation.errors.ts:10`). `CANNOT_AUDIT` is a successful diagnostic outcome with no result, not “not eligible” and not zero credits (`graduation.dto.ts:265`).
- **Unsupported contract:** show an unsupported-result explanation and contact/update guidance, not a conclusion. `schemaVersion` and `ruleVersion` are validation inputs, not prominent student data (`graduation.dto.ts:207`).

## 2. Screen specifications

### 2.1 Home

**Job:** “Where can I go to do the student task I need?”

**Layout decisions — from dDUT 20261101-163250.jpg and from dDUT 20261101-163257.jpg:** blue identity strip with circular initials slot and bell; split date/message card; spacious two-column white tiles with icon above label; floating two-icon navigation pill. Keep the screenshot's top-to-bottom sequence. **Layout decisions — no dDUT reference:** add Curriculum first, mark unavailable tiles, and substitute “Timetable not connected” for a schedule claim; these content changes are intentional, not visual fidelity failures.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Brief signed-in identity: name, with student code when linked | `fullName` — `me.dto.ts:24`; `student.studentCode` — `student-portal.dto.ts:29` | primary | Home header only; initials derived from name, not a fabricated photo. |
| Account fallback when student identity is unavailable | `username` — `me.dto.ts:22` | secondary | Header subtitle fallback; never relabel account `userCode` as student code. |
| Curriculum first, followed by the established dDUT feature names and availability | No response field; local navigation model `lib/features/shell/domain/model/home_tile.dart:1` and labels `lib/features/shell/presentation/components/home_tile_presentation.dart:8` | primary | Preserve the eleven-tile sequence; identify unavailable features before opening them. Academic results can reuse the existing results destination. |
| Profile and Notifications entry points | No response field; local shell destinations `lib/common/routes/route_paths.dart:6`, `lib/common/routes/route_paths.dart:10` | secondary | Header/shell actions; no unread badge without data. |
| Today's date and honest connection notice | No response field; device-clock presentation `lib/features/shell/presentation/components/today_card.dart:24`; existing schedule-copy location `lib/features/shell/presentation/components/today_card.dart:62` | secondary | Split card after header, before tiles: date left, neutral calendar icon and “Timetable not connected” right. Preserve the dDUT composition without claiming schedule knowledge. |

**Must NOT show:** detailed cohort/major/status/account rows (Profile); full programme/decision cards (academic entry); credit totals or course lists (Progress/Curriculum); “no classes today” without timetable data. Email does not need to occupy the Home subtitle when a useful student code is available.

**Context needed:** authentication only. Student-code enrichment may reuse `GET /portal/me` but must not gate navigation or require the student to choose an academic context on Home. The academic context control belongs inside the curriculum area.

**States:** loading identity leaves static navigation visible; unlinked student shows account identity and allows entry to the explanatory academic gate; identity error offers retry without suggesting a timetable result; partial portal-identity failure falls back to account identity. There is no data-backed Home timetable-empty state.

**Left out (web only)**
- Programme/version/decision and cohort/status block (`PortalHomePage.tsx:26`): not needed to pick a task; academic context is inside the curriculum area and identity detail is in Profile.
- Academic-only web navigation bar (`StudentLayout.tsx:11`): not the dDUT shell; retain the Home/Profile pattern and phone feature tiles instead.

### 2.2 Profile

**Job:** “Which student/account am I signed in as, and how do I manage access?”

**Layout decisions — no dDUT reference:** no Profile screenshot was supplied. Use one identity card, a compact expandable details card, and separated security actions. **Layout decision — from dDUT 20261101-163250.jpg:** reuse the blue header/initials geometry and floating shell pill, not its real photo or personal subtitle; avoid duplicating the name directly below the header.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Student name and student code when linked | `student.fullName`, `.studentCode` — `student-portal.dto.ts:30`, `student-portal.dto.ts:29` | primary | One student identity group; do not repeat the full name in two adjacent cards. |
| Cohort, major, study status | `student.cohortCode`, `.major`, `.status` — `student-portal.dto.ts:31`, `student-portal.dto.ts:32`, `student-portal.dto.ts:34` | secondary | Academic identity below name/code; translated status, not enum spelling. |
| Login name and email, with account-name fallback when unlinked | `username`, `email`, `fullName` — `me.dto.ts:22`, `me.dto.ts:25`, `me.dto.ts:24` | secondary | One-tap account details: helps identify the correct login/contact without taking over the first view. Missing email is “Not provided”; do not add an account-code row. |
| Required password-change notice and password action | `mustChangePassword` — `me.dto.ts:26`; existing action `auth.controller.ts:88` | primary | Security actions after identity; mandatory gate also applies outside Profile. |
| Sign out with confirmation | No response field; existing UI flow `lib/features/shell/presentation/profile/profile_screen.dart:20` | primary | Account action, not mixed with academic facts. |

**Must NOT show:** curriculum course/status lists, credits, PLOs, audit conclusions, or programme/semester selectors (their academic screens); permissions, scope assignments, approver flags, or internal role chips. `roles[].roleName` exists (`me.dto.ts:13`) but adds little to an explicitly student-only profile; do not show authorization plumbing as personal information. Do not invent editable phone, address, photo, or academic-profile fields.

**Context needed:** signed-in account plus nullable student identity, independent of the selected programme/semester. Student identity remains available even when academic version resolution fails; no user-selected academic context is required.

**States:** load account and student identity independently; an unlinked account still shows account/security details and linking guidance; account/session error retries or reauthenticates; partial student lookup failure leaves password/sign-out actions usable and labels academic identity unavailable rather than blank. Null email is a normal field state.

**Left out (web only)**
- Programme/decision metadata from the portal home (`PortalHomePage.tsx:42`): belongs to academic context, not account management.
- Role/scope/permission information available in `me.dto.ts:29` and `me.dto.ts:35`, and account code `me.dto.ts:23`: no useful quick student action depends on these identifiers. The current mobile role chips are also removed.
- A second full-name row: the header already identifies the person. No dedicated web student-profile page is present in the supplied route group; do not invent profile-editing parity.

### 2.3 Curriculum area entry / overview

**Job:** “Which programme version applies to me, and where is the academic information I need?”

**Layout decisions — no dDUT reference:** no curriculum-entry screenshot exists. Use a blue back/title toolbar, one compact context/assigned-version summary, then five short icon-and-label destination rows. **Layout decision — from dDUT 20261101-163250.jpg:** borrow the shell's rounded card spacing, not its identity card or a second eleven-tile dashboard. Put no transcript or KPI wall above navigation.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Applied programme/type, semester, and derived version | `programs[].programCode`, `.programName`, `.enrollmentType`, `.versionNumber`, `semester.semesterCode` — `student-portal.dto.ts:39`, `student-portal.dto.ts:40`, `student-portal.dto.ts:42`, `student-portal.dto.ts:44`, `student-portal.dto.ts:50` | primary | One shared context summary answers “Am I looking at my right curriculum?”; edit in one sheet, not four metadata cards. |
| Issuing decision number when the student checks applicability | `programs[].decisionNumber` — `student-portal.dto.ts:45` | secondary | One-tap “Applied curriculum details,” not a visible administrative row on every visit. |
| Five academic destinations: Curriculum, PLOs, Progress & results, Registration eligibility, Graduation review | No response field; existing destination list `lib/features/portal/presentation/overview/portal_overview_screen.dart:106`; route identities `lib/common/routes/route_paths.dart:12` | primary | Context first, then these purpose-labelled destinations. Descriptions explain what each answers; no speculative summary counts. |

**Must NOT show:** student name/code/cohort/major/status (Profile/Home header); account details or role labels (Profile); a transcript, entire curriculum, or graduation shortfalls (their own destinations). No arbitrary backend IDs, schema versions, or debug diagnostics as overview content.

**Context needed:** owns the introduction to the one shared programme/semester selection; version follows backend resolution. Entry does not create a second context. A single valid programme is a label, not a redundant switch.

**States:** load context before academic links become actionable; missing student/semester/programme follows section 1.4; empty programmes is unresolved applicability, not proof of no enrolment; error offers context retry; partial missing decision/version labels say “Not supplied” without inventing values. A programme omitted by the resolver cannot be listed or explained individually with today's response: escalation E3.

**Left out (web only)**
- Name/student code/cohort/study-status panel (`PortalHomePage.tsx:19`): this is an academic task launcher, not a second account home; identity belongs in Profile/Home header.
- Fully expanded decision/metadata description table (`PortalHomePage.tsx:46`): applicability can be checked in one tap; it should not precede every academic task.

### 2.4 Curriculum

**Job:** “What courses does my applied curriculum require, and which have I completed?”

**Layout decisions — from dDUT 20261102-223814.jpg:** blue back/title toolbar, blue planned-term headings, full-width pale-grey rounded course cards; muted code/credits first, bold blue course name next, readable details below. Add a small textual completion chip without replacing the course identity. **Layout decisions — no dDUT reference:** shared context, completion filter, and collapsible term grouping are curriculum adaptations; default to a scannable term/card list, not a metadata form. Scores and equivalent-course explanation sit one tap away; the syllabus has its own explicit action.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Total required curriculum credits | `totalCredits` — `student-portal.dto.ts:89` | primary | Short summary below the shared context, before term groups; not the sum of elective alternatives. |
| Planned term and compulsory credits for that term | `terms[].plannedSemester`, `.credits` — `student-portal.dto.ts:80`, `student-portal.dto.ts:81`; compulsory-only calculation `student-portal.service.ts:287` | primary | Ascending planned term; label “Compulsory credits,” not “Term total.” Keep ordinal term separate from calendar semester. |
| Course code, name, credits | `terms[].courses[].courseCode`, `.courseName`, `.credits` — `student-portal.dto.ts:64`, `student-portal.dto.ts:65`, `student-portal.dto.ts:66` | primary | Each course row within its planned term; preserve backend order. |
| Required/elective distinction, elective group | `isElective`, `groupName` — `student-portal.dto.ts:67`, `student-portal.dto.ts:68` | primary | Under course identity; group elective alternatives together within each term, with “choose within group” wording, not “take every option.” |
| Completion state, including passed through equivalence | `state` — `student-portal.dto.ts:71`; allowed states `student-portal.dto.ts:9` | primary | Beside each course; text plus visual distinction. Filters may derive from these states; passed includes passed-equivalent. |
| Best recorded score and equivalent-course explanation when the student checks a state | `score10`, `score4`, `letterGrade` — `student-portal.dto.ts:73`, `student-portal.dto.ts:74`, `student-portal.dto.ts:75`; equivalent evidence from existing advice `items[].reasons[].code`, `.evidenceCourse` — `registration-eligibility.dto.ts:33`, `registration-eligibility.dto.ts:47`; evidence code/name `registration-eligibility.dto.ts:20`, `registration-eligibility.dto.ts:21` | secondary | One tap on completion detail explains why the course is marked complete. Join advice by `itemId` (`registration-eligibility.dto.ts:72`) and use `EQUIVALENT_COMPLETED` evidence (`eligibility-evaluator.ts:160`); null score is unknown, not zero. |
| Pinned syllabus availability and course action | `hasSyllabus`, request key `itemId` — `student-portal.dto.ts:76`, `student-portal.dto.ts:62` | primary | “View syllabus” only when available; otherwise explicit “No issued syllabus linked.” |

**Must NOT show:** student identity (Profile/Home); full programme/version/decision card (entry/shared context); every historical attempt (Progress & results); audit conclusion/shortfalls (Graduation); registration conditions/requisites (Eligibility); staff editing, draft versions, or approvers. PLOs are reachable as a sibling destination rather than appended below a long phone curriculum list.

**Context needed:** shared programme/semester, derived version; term and completion filters are local view state. Syllabus navigation carries the curriculum `itemId` and the same shared context. `PASSED_EQUIVALENT` is not a separate requirement to complete again.

**States:** loading preserves context and placeholders for terms; no terms says “No curriculum courses are available for this version”; filter with no matches says “No courses match this filter” with Clear filter. A new student with no attempts still sees the complete frame, not an empty screen. Curriculum error retries that request. Partial equivalence-evidence failure preserves course/state and says the source course is temporarily unavailable; it does not downgrade passed-equivalent to failed. Incomplete snapshot must not be replaced by the newest catalogue curriculum.

**Left out (web only)**
- Full programme/version/decision heading (`PortalCurriculumPage.tsx:92`): the one shared context already establishes applicability; only total required credits add a useful curriculum answer.
- All score scales and repeat counts on every collapsed course row (`PortalCurriculumPage.tsx:21`): completion state is the quick answer; scores can be checked in one tap and full attempts in Progress & results. `attemptCount` is not a headline metric.
- PLO footer (`PortalCurriculumPage.tsx:129`): separate phone destination, not content after a long course list.
- Unexplained `blockSymbol` tags (`student-portal.dto.ts:69`, currently added by the app): not needed to decide what remains; named block breakdown is available from Progress details.

Equivalent-course identity still has student value and is required by US-093, so it remains in the one-tap state explanation. Existing API evidence suffices; the Flutter reason DTO currently drops it (`lib/features/portal/data/remote/dto/eligibility_reason_dto.dart:7`). That is a client-model gap, not a new-backend request.

### 2.5 Syllabus detail

**Job:** “What will this course teach, and how is my work assessed under my curriculum's syllabus?”

**Layout decisions — no dDUT reference:** no syllabus screenshot exists. Use a compact course header and a small number of clearly named disclosure cards, with assessment first, followed by learning content and documents. **Layout decision — from dDUT 20261102-223814.jpg:** borrow the blue toolbar/course-title and readable subsection hierarchy; do not reuse its prerequisite content or make the syllabus a long desktop document on first view.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Course code, name, credits | `courseCode`, `courseName`, `credits` — `student-portal.dto.ts:127`, `student-portal.dto.ts:128`, `student-portal.dto.ts:129` | primary | Course header; no student/programme biography. |
| Pinned revision | `revisionNumber` — `student-portal.dto.ts:130` | secondary | Small “Applied syllabus” label; confirms the right version without a publication-history panel. |
| Course description | `courseDescription` — `student-portal.dto.ts:132` | secondary | Short “About this course” preview; full supplied description one tap away. The first view prioritizes assessment and learning-plan entry points. |
| Learning outcomes and teaching plan | `clos`, `weeks` — `student-portal.dto.ts:140`, `student-portal.dto.ts:141`; `cloCode`, `description`, `weekLabel`, `content` — `student-portal.dto.ts:101`, `student-portal.dto.ts:102`, `student-portal.dto.ts:106`, `student-portal.dto.ts:107` | secondary | One-tap “Learning outcomes” and “Weekly plan” disclosures answer what to prepare; do not expand every week by default. |
| Assessment components, names, percentage weights, assessment forms | `assessments` — `student-portal.dto.ts:143`; `componentCode`, `componentName`, `weight`, `assessmentForm` — `student-portal.dto.ts:111`, `student-portal.dto.ts:112`, `student-portal.dto.ts:113`, `student-portal.dto.ts:114` | primary | First content card after the course header: “How you are assessed.” Stack component/weight rows, not a wide table. These weights alone are not the complete pass-condition formula. |
| Assessment-method explanation | `assessmentMethods` — `student-portal.dto.ts:137` | secondary | One-tap explanation in the assessment card for rules the weights cannot explain; do not manufacture structured thresholds. |
| Documents: filenames/types and open/download action | `attachments` — `student-portal.dto.ts:145`; `fileName`, `materialKind`, internal `id` — `student-portal.dto.ts:119`, `student-portal.dto.ts:121`, `student-portal.dto.ts:118` | secondary | One-tap “Documents”; lets the student open the authoritative issued material. Size need not occupy every row; download through `student-portal.controller.ts:77`. |

**Must NOT show:** student identity, transcript grades, programme administration fields, syllabus drafts/reviewer comments/uploader identity, or edit/approve actions. The student response is deliberately allowlisted (`student-portal.dto.ts:125`). Do not infer a personal assessment score from syllabus weights. Structured conditional components and pass thresholds are not provided in this projection: see escalation E1; stop rather than design an API extension.

**Context needed:** curriculum item plus shared programme/semester and derived version; no revision dropdown. The backend pins the syllabus by curriculum item in the applicable version (`student-portal.service.ts:329`). Changing context must revalidate the item, not substitute a new syllabus silently.

**States:** loading header/sections; no pinned issued syllabus shows the specific unavailable state and Back to curriculum (`student-portal.errors.ts:16`); wrong-context item shows unavailable-in-this-curriculum, not a catalogue fallback (`student-portal.errors.ts:11`). Empty/null sections say “Not supplied” or are omitted without implying a fetch error; no attachments says “No attachments supplied.” Partial failed download keeps the syllabus visible with per-file retry; partial missing assessment data explicitly says the assessment information is incomplete, not “assessment not required.” Network failure offers retry; snapshot/context problems follow section 1.4.

**Left out (web only)**
- Objectives/teaching-methods/reference narrative panels (`PortalSyllabusPage.tsx:23`): too much document-reading for the quick assessment/preparation question; the issued attachment remains available. Do not recreate every rich-text section just because it exists.
- Publication timestamp and per-file byte-size rows (`student-portal.dto.ts:131`, `student-portal.dto.ts:122`, currently shown in the app): revision identity and document action suffice; these details do not change the student's next action.
- All CLOs/weeks expanded simultaneously (`PortalSyllabusPage.tsx:69`, `PortalSyllabusPage.tsx:114`): the data remains in one-tap learning-plan disclosures, not a long default scroll.
- Complete conditional/pass-threshold formula: not available in the student projection despite US-096; escalation E1, not an invented phone feature.

### 2.6 Programme learning outcomes (PLOs)

**Job:** “What knowledge and capabilities should I have on completing this programme?”

**Layout decisions — no dDUT reference:** none of the images shows a PLO-description page; the outcome-related box in the Academic affairs screenshot is not evidence of personal attainment data. Use compact competency headings and outcome cards, with code/short preview first and full description in one tap. **Layout decision — from dDUT 20261102-223814.jpg:** borrow the blue section/title hierarchy and neutral rounded text-card grammar, not a grade dashboard.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| PLO code and description preview, with full description reachable in one tap | `ploCode`, `description` — `student-portal.dto.ts:94`, `student-portal.dto.ts:95` | primary | Lets the student find the capability quickly; expand to the full text, never discard the description or show an unsupported attainment score. |
| Competency-group headings where supplied | `competencyGroup` — `student-portal.dto.ts:96` | secondary | Group related outcomes; null group becomes “Other outcomes”; preserve response order within a group. |

**Must NOT show:** student identity, personal attainment percentages/scores, CLO achievement, PLO-CLO matrices, curriculum course rows, or programme editing controls. These PLO descriptions are programme expectations, not a measured personal outcome report; no attainment metric exists in the cited response.

**Context needed:** shared programme/semester and derived version. PLOs have no separate version or semester picker.

**States:** loading list; successful empty list says “No programme outcomes are supplied for this version”; error is a distinct retryable failure, never that empty message; partial null competency group does not hide its PLOs. If context/snapshot resolution fails, stop at the shared gate without showing another version's outcomes.

**Left out (web only)**
- PLO list appended to Curriculum (`PortalCurriculumPage.tsx:129`): separate task/destination on a phone, not a footer students must scroll through courses to find.
- All full descriptions open at once: preview/expand suits a quick check; full text remains reachable in one tap. Matrix/attainment data is outside this response and outside this screen's job.

### 2.7 Progress & results

**Job:** “How far have I progressed, and what recorded results explain that progress?”

**Layout decisions — from dDUT 20261101-163309.jpg:** blue back/title/bell toolbar, one pale-blue horizontal summary with a large leading number and compact supporting facts, then separate rounded content cards. Lead with recognized credits, not an unsupported GPA. **Layout decisions — no dDUT reference:** a compact “Progress / Results” content switch keeps the credit answer and recent-result list from becoming one long audit page; curriculum-area navigation defaults to Progress, while the Home Academic results shortcut selects Results. Breakdown and an attempt's full scores expand in one tap. No GPA/conduct charts are drawn from course grades.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Recognized credits, required credits, missing credits | Reviewed `result.credits.recognizedTotal`, `.requiredTotal`, `.missingTotal` — `graduation.dto.ts:190`, `graduation.dto.ts:189`, `graduation.dto.ts:191` | primary | First summary; use backend recognition totals, not sum of attempts or curriculum options. |
| Completion percentage | Derived only from recognized/required totals — `graduation.dto.ts:190`, `graduation.dto.ts:189` | secondary | Small supporting figure in the same summary, not another chart/card; cap at 100%. Zero denominator means “Not applicable.” |
| Purposeful credit breakdown: compulsory/elective totals, elective-group progress, earned credits by named block | `credits.compulsory`, `.elective` — `graduation.dto.ts:192`, `graduation.dto.ts:193`; group label and required/earned/missing credit/course values — `graduation.dto.ts:155`, `graduation.dto.ts:156`, `graduation.dto.ts:157`, `graduation.dto.ts:159`, `graduation.dto.ts:160`, `graduation.dto.ts:161`, `graduation.dto.ts:163`, `graduation.dto.ts:164`; block label/earned credits — `graduation.dto.ts:168`, `graduation.dto.ts:169`, `graduation.dto.ts:170` | secondary | One-tap “Credit breakdown” answers where the credit gap lies and covers MH-57 without desktop tables on the landing view. Null group requirement means unspecified, not zero. Blocks are descriptive, not new graduation gates. |
| Material calculation warning when it changes interpretation | `result.warnings[].code`, `.message` — `graduation.dto.ts:180`, `graduation.dto.ts:185` | secondary | Show the relevant explanation beside the affected summary, not a diagnostic log. No permanent timestamp panel. |
| Recorded attempts: course code/name and actual result semester | `items[].course.courseCode`, `.courseName`, `items[].semester` — `academic-result.dto.ts:10`, `academic-result.dto.ts:11`, `academic-result.dto.ts:19`; semester label `semester.dto.ts:7` | primary | Results view: newest semester first, compact course cards, with older pages loaded on request. This answers “What was my result?” without a second audit list. |
| Main available grade and recorded result status; alternate scales one tap away | `score10`, `score4`, `letterGrade`, `status` — `academic-result.dto.ts:20`, `academic-result.dto.ts:21`, `academic-result.dto.ts:22`, `academic-result.dto.ts:24` | primary | Letter grade when available, otherwise a labelled numeric score; full /10, /4, letter values in attempt disclosure. Never infer pass/recognition from colour or a numeric threshold. |
| Result-semester filter and paginated completion status | Request `resultSemesterId` — `student-query.dto.ts:94`; `total`, `page`, `pageSize` — `academic-result.dto.ts:33`, `academic-result.dto.ts:34`, `academic-result.dto.ts:35` | secondary | Optional “Recorded in semester” filter above attempts; loaded/total or Load more below. This filter does not recalculate programme progress. |

**Must NOT show:** personal identity; graduation verdict as the screen's hero (Graduation review); course-registration advice (Eligibility); sum of all attempt credits, invented GPA/ranking/conduct trend, or personalized PLO attainment. Internal source revisions (`academic-result.dto.ts:27`) are not progress. Do not represent historical attempts as separately earned credits. Zero-credit condition-course completion remains visible in curriculum course states and graduation condition shortfalls; it must not inflate credit totals or force an additional dashboard counter.

**Context needed:** shared programme/semester/derived version for recognized progress and authorization. The transcript endpoint returns the student's attempts through the selected semester's start-date cutoff, not only courses in this programme (`students-read.service.ts:193`, `students-read.service.ts:195`). Explain that the attempt history can therefore contain courses not credited to this programme. The optional result-semester filter narrows history only; reset its pagination when it changes.

**States:** calculation and history are independent; a failure in one does not prevent switching to the other. A reviewed zero-credit result plus no attempts is a real empty-history state: show “No recorded results,” supplied requirements, and genuinely computed zeros. `CANNOT_AUDIT` shows “Progress cannot be calculated yet,” the diagnostic (`graduation.dto.ts:255`), retry/contact guidance, and access to Results; no percentage/zero totals. History errors retain valid progress; pagination errors retain loaded attempts. Partial warnings stay beside usable results. Unsupported calculation version suppresses that calculation, not independent history.

**Left out (web only)**
- Single page containing summary plus the complete attempt table (`PortalProgressPage.tsx:77`): use two compact content views and on-demand history; the student can reach the other answer in one tap.
- Three equally prominent score columns and data-source column (`AcademicResultsTable.tsx:79`, `AcademicResultsTable.tsx:96`): show one main grade; alternate scales are attempt detail, import provenance is not needed for quick checking.
- Detailed free-credit allocation/recognition ledgers and advisory block gaps (`graduation.dto.ts:194`, `graduation.dto.ts:248`, `graduation.dto.ts:175`): leave desktop accounting out; overall recognized/missing totals and a short breakdown answer the phone job.
- Separate completed-condition counter and evaluator timestamps: these add summary clutter; course completion and missing conditions are already reachable in Curriculum/Graduation.
- GPA, conduct/study-year summaries, personal PLO scores, and trend charts visible in the dDUT reference: unavailable in inspected app contracts; escalation E2. Copy the summary hierarchy, not the metrics.

### 2.8 Registration eligibility

**Job:** “Which unfinished courses can I consider registering for, and what must I complete or take alongside them?”

**Layout decisions — from dDUT 20261102-223735.jpg:** blue toolbar, compact pale-blue context/message area, two large tabs and a clear single message for empty/unavailable content. Adapt the tabs to “Can consider / Blocked,” not “Courses / Registered.” **Layout decisions — from dDUT 20261102-223814.jpg:** light-grey rounded course cards with muted code/credits, blue course title, and bold readable dependency subheadings in one-tap detail. **Layout decision — from dDUT 20261102-223809.jpg:** use a small textual status pill, not real enrolment-success copy. **Layout decisions — no dDUT reference:** shared context and advice-only limitation; omit unsupported utility pills, credit limits, registered totals, class search, and registration actions.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Advice-only limitation | No response field; safety copy matching `PortalRegistrationPage.tsx:107` and US-095 | primary | Before the lists: checks prerequisites/prior study/corequisites; does not enrol the student, guarantee an open class, or confirm an offered section. |
| Separate eligible, conditional, and ineligible states; section counts | `items[].completed`, `.eligibility`, `.statusText` — `registration-eligibility.dto.ts:79`, `registration-eligibility.dto.ts:81`, `registration-eligibility.dto.ts:82` | primary | Exclude completed courses. Default list: eligible and conditional, with distinct labels; alternate list: blocked. Counts derived from returned items, not offered classes. |
| Course code/name, credits, planned curriculum term | `items[].course.courseCode`, `.courseName`, `.credits`, `.plannedSemester` — `registration-eligibility.dto.ts:20`, `registration-eligibility.dto.ts:21`, `registration-eligibility.dto.ts:75`, `registration-eligibility.dto.ts:78` | primary | Per-course header; planned term described as ordinal in the curriculum, not the selected registration semester. |
| Main reason or concurrent-course obligation | `items[].reasons[].code`, `.message`, `items[].requiredConcurrentCourses` — `registration-eligibility.dto.ts:33`, `registration-eligibility.dto.ts:36`, `registration-eligibility.dto.ts:86`; course labels `registration-eligibility.dto.ts:20`, `registration-eligibility.dto.ts:21` | primary | One short reason on a blocked card; conditional card names courses to take together. This changes the student's plan, unlike another metadata row. |
| Exact reason evidence when checking a blocked/conditional course | `requiredCourse`, `relationType`, `requiredScore4`, `actualScore4`, `actualStatus` — `registration-eligibility.dto.ts:43`, `registration-eligibility.dto.ts:41`, `registration-eligibility.dto.ts:50`, `registration-eligibility.dto.ts:51`, `registration-eligibility.dto.ts:57` | secondary | One tap reveals the full explanation/minimum/actual evidence when supplied. Display server facts, not a recomputed prerequisite engine. |
| Affected-course warning or catalogue restriction | `warnings[].course`, `.message`, `items[].catalogStatus` — `registration-eligibility.dto.ts:69`, `registration-eligibility.dto.ts:67`, `registration-eligibility.dto.ts:77`; course labels `registration-eligibility.dto.ts:20`, `registration-eligibility.dto.ts:21` | secondary | Only show when it changes interpretation of that course; do not precede candidates with an unrelated warning log. |

**Must NOT show:** student identity, completed courses as candidates, full transcript, graduation shortfalls, live class seats/timetable/offering assertions, a course-registration button, or arbitrary next-semester promises. `eligibility = null` is not automatically eligible; completed items legitimately carry null (`eligibility-evaluator.ts:160`), and an unfinished item with no verdict is unknown/incomplete, not green.

**Context needed:** shared programme/semester and derived version, with advice explicitly scoped to the selected semester. The response's `plannedSemester` does not identify next term's actual course offerings. Do not silently increment the selected semester; future-term planning and historic review use the same visible context control.

**States:** loading advice list; successful no candidates means “No unfinished courses in this category,” with the other category still reachable. If all items are completed, say “All returned curriculum courses are completed,” not “Graduation approved.” Error retries advice; incomplete eligibility snapshot (`eligibility.errors.ts:4`) blocks advice, with contact/change-context guidance, not an empty allowed list. Partial warnings remain visible; an unfinished unknown-verdict item is shown separately as unavailable advice and never counted as eligible. Preserve the distinction between conditional and ineligible.

**Left out (web only)**
- All dependency explanations fully expanded on every course (`PortalRegistrationPage.tsx:43`): one useful reason is enough to scan; full evidence is one tap away.
- Full warning log, evaluated timestamp, repeated status text and active-catalogue label (`registration-eligibility.dto.ts:105`, `registration-eligibility.dto.ts:108`, currently added by the app): show only a warning/restriction relevant to the student's choice, not diagnostic decoration.
- Completed-course candidates: deliberately excluded because this is planning, not history (`PortalRegistrationPage.tsx:68`).
- dDUT registration utilities, registered-class tab, availability/seat counts, registered-credit totals and credit cap: unsupported for this app and outside advice-only scope; escalation E2. A course may satisfy prerequisites without any class being open.

### 2.9 Graduation review

**Job:** “Do I currently meet the computable graduation requirements, and exactly what remains missing?”

**Layout decisions — no dDUT reference:** none of the screenshots shows a graduation review. Answer with one conclusion card, a short non-official limitation, and grouped missing-item cards; show no accounting tables by default. **Layout decision — from dDUT 20261101-163309.jpg:** borrow the pale-blue summary and separated card hierarchy, not its GPA/chart content. Evaluation basis is one-tap supporting detail, not a second context form.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Reviewed conclusion or cannot-audit explanation | `status`, reviewed `result.conclusion`, diagnostic `error.message` — `graduation.dto.ts:274`, `graduation.dto.ts:212`, `graduation.dto.ts:255` | primary | First content after shared context; eligible, not eligible, and cannot conclude are distinct. Never render a verdict when result is null. |
| Live-calculation, not official approval limitation | No response field; safety copy matching `PortalGraduationPage.tsx:41` | primary | Beside the conclusion: calculated at viewing time, not an official graduation-recognition decision. No Save/Approve button. |
| Missing compulsory and conditional courses, and why missing | `shortfalls` — `graduation.dto.ts:239`; category/code `graduation.dto.ts:71`, `graduation.dto.ts:72`, `graduation.dto.ts:77`, `graduation.dto.ts:79`; `course`, `reason`, `message` — `graduation.dto.ts:62`, `graduation.dto.ts:64`, `graduation.dto.ts:66`; course labels `graduation.dto.ts:34`, `graduation.dto.ts:35` | primary | Actionable shortfalls immediately below conclusion: compulsory, elective-group, conditional-course, total-credit groups. Distinguish not taken, failed, and still in progress. |
| Missing elective-group requirements in credits and/or course counts | `groupCode`, `groupName`, `message` — `graduation.dto.ts:85`, `graduation.dto.ts:86`, `graduation.dto.ts:87`; `requiredCredits`, `earnedCredits`, `missingCredits` — `graduation.dto.ts:93`, `graduation.dto.ts:94`, `graduation.dto.ts:95`; `requiredCourses`, `earnedCourses`, `missingCourses` — `graduation.dto.ts:101`, `graduation.dto.ts:102`, `graduation.dto.ts:103` | primary | Elective shortfalls name the exact group and missing amount; do not reduce every failure to total credits. |
| Missing overall credits | Shortfall `requiredCredits`, `earnedCredits`, `missingCredits`, `message` — `graduation.dto.ts:110`, `graduation.dto.ts:111`, `graduation.dto.ts:112`, `graduation.dto.ts:113` | primary | Total-credit shortfall after course/group-specific obligations. |
| Recognized/required/missing credit totals | `credits.requiredTotal`, `.recognizedTotal`, `.missingTotal` — `graduation.dto.ts:189`, `graduation.dto.ts:190`, `graduation.dto.ts:191` | secondary | One compact line supporting a credit shortfall, not another progress dashboard. Link to Progress for breakdown. |
| Calculation warnings and relevant credit gap | `warnings[].code`, `.message`, `.creditGap` — `graduation.dto.ts:180`, `graduation.dto.ts:185`, `graduation.dto.ts:184` | primary | Adjacent to affected conclusion/requirements; label advisory vs blocking clearly. |
| Evaluation time and version basis | `evaluatedAt`, returned `context.versionNumber`, `.versionSource` — `graduation.dto.ts:209`, `graduation.dto.ts:50`, `graduation.dto.ts:53` | secondary | One-tap “Evaluation basis” explains freshness and assignment/exception basis; shared context already names programme/semester. Validate returned context (`graduation.dto.ts:210`) without displaying a duplicate metadata table. |

**Must NOT show:** student name/code/cohort/major/status; staff audit actions or saved-audit history; official approval or clearance promises; invented GPA, language/certificate/debt criteria; advisory block gaps as mandatory shortfalls. Detailed attempt scores belong in Progress & results. The shared web component's student-name card is inappropriate in this single-student app even though its audit evidence is useful.

**Context needed:** shared programme/semester/derived version; returned evaluation context is used only to validate and explain the answer. The evaluation-basis exception is justified because an audit conclusion depends on its version/source and time; it does not justify displaying personal identity or another editable context.

**States:** loading conclusion and shortfall placeholders; reviewed eligible with empty shortfalls says “No missing items under this review” plus the non-official disclaimer. Reviewed not-eligible lists supplied shortfalls. `CANNOT_AUDIT` shows “Cannot determine eligibility yet,” diagnostic and retry/contact/change-context options; do not display zero totals or treat it as a failed student. Policy-unconfirmed, ambiguous equivalence, and incomplete-snapshot diagnostics are data/policy limitations (`graduation.errors.ts:10`, `graduation.errors.ts:22`, `graduation.errors.ts:28`, `graduation.errors.ts:34`). Transport error offers retry. Partial reviewed results with warnings retain both; a missing optional field is unavailable, not a new deficiency. An unsupported schema or mismatched context suppresses the verdict.

**Left out (web only)**
- Student-name/code/cohort card (`GraduationResultView.tsx:31`, `GraduationResultView.tsx:48`): redundant for a signed-in student's own review and explicitly misplaced on the phone academic screens.
- Full elective-group and block accounting tables (`GraduationResultView.tsx:87`, `GraduationResultView.tsx:111`): the missing groups/courses already answer what remains; routine breakdown is one tap away in Progress.
- Recognized-course/free-credit ledgers and credit-basis columns (`GraduationResultView.tsx:146`, `GraduationResultView.tsx:183`): useful desktop investigation tools, not prerequisites to a quick verdict. Equivalent-course explanation is available on the relevant Curriculum card instead. Their omission from Flutter is not, by itself, a redesign violation.
- Compulsory/elective/free allocation rows and another progress bar (`GraduationResultView.tsx:69`): duplicate Progress; keep only supporting total-credit figures here.

### 2.10 Change password

**Job:** “How do I secure my account and complete any required password change?”

**Layout decisions — no dDUT reference:** no password form screenshot exists. Use a blue back/title toolbar, a concise security explanation, one vertical form, and one primary submit action. A forced change replaces Back with an explicit sign-out exit rather than allowing access to academic screens. This is a security form, not a profile-information card stack.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Current and new password inputs | Request fields `currentPassword`, `newPassword` — `change-password.dto.ts:20`, `change-password.dto.ts:30` | primary | Masked vertical inputs; transient user input, never response data, prefilled values, or logs. |
| Confirm new password | No API field; local input `lib/features/auth/presentation/components/change_password_form.dart:73` | primary | After new password; match validation is local, not a third request property. |
| Password rule and field validation | Constants `password-policy.ts:1`, `password-policy.ts:2`, `password-policy.ts:3` | secondary | Next to new-password entry: 8–128 characters, at least a letter and a digit; useful before submission, not a long security-policy page. |
| Required-change reason, submit state, result/error feedback | `mustChangePassword` — `me.dto.ts:26`; no-content success `auth.controller.ts:89`; existing form state `lib/features/auth/presentation/change_password/change_password_screen.dart:20` | primary | Explain mandatory change before the form; show progress on submit and clear success/error feedback. |

**Must NOT show:** academic context/identity, password values from storage, administrative reset controls, role/permission rows, or unsupported recovery/SSO features. Profile owns the account identity; this screen owns a security action.

**Context needed:** authenticated account and required-change flag only. No programme, semester, version, or student link is needed.

**States:** idle empty inputs invite entry rather than “no data”; submission disables duplicate actions; invalid input stays inline; rejected current password/server error allows correction/retry without echoing entered passwords; success returns to Profile when voluntary or Home when mandatory. Expired session returns to sign-in. Partial success must not be guessed after an interrupted response; recheck session/required-change state. Forced change cannot be bypassed using Back (`lib/features/auth/presentation/change_password/change_password_screen.dart:46`).

**Left out (web only)**
- Full account-information and programme panels: neither helps choose a secure replacement password. The supplied web student pages do not contain a password form to replicate; this uses the existing auth contract, not web parity.

### 2.11 Notifications placeholder

**Job:** “Can I see my student notifications here?”

**Layout decisions — no dDUT reference:** no notification-feed screenshot exists. **Layout decision — from dDUT 20261102-223735.jpg:** use the blue back/title toolbar and one compact rounded informational state, then leave honest open space rather than inventing feed cards or a zero unread count. The source screenshot's registration-closed message is not reused.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Notifications title and unavailable-in-this-app explanation | No response field; local route `lib/common/routes/route_paths.dart:10`, placeholder branch `lib/common/routes/app_router.dart:130` | primary | Title followed by “Notifications are not connected in this app”; distinguishes missing integration from an empty inbox. |
| Back/Home navigation | No response field; local shell destinations `lib/common/routes/route_paths.dart:5`, `lib/common/routes/route_paths.dart:6` | primary | Return to the task the student left; do not force Curriculum as the sole exit. |

**Must NOT show:** student identity, fabricated notifications/unread badges/read state, or a claim that the inbox is empty. No feed/mark-read action is backed by the current app call surface.

**Context needed:** authenticated shell only, not academic context.

**States:** this is an unavailable integration, not loading/empty/error data. No endless spinner or retry that pretends to load a feed. Invalid route uses the route-error state; auth expiry uses sign-in. Partial feed state is not applicable until an actual integration is approved.

**Left out (web only)**
- Notifications from other web modules are not part of the supplied student-page data contract; no inferred inbox parity. The bell's presence in dDUT screenshots proves navigation structure, not API availability.

### 2.12 dDUT feature placeholders

**Job:** “Is this named dDUT feature available in this app, and where can I go instead?” Each variant retains its own feature identity:

| Variant / individual screen question | Source of screen identity | Reference mapping |
|---|---|---|
| Timetable — “What classes do I have?” | `lib/features/shell/domain/model/home_tile.dart:3` | Home tile only; no timetable-body screenshot. |
| Academic results, legacy placeholder — “What were my results?” | `lib/features/shell/domain/model/home_tile.dart:4` | Route to existing Progress & results, not a permanent empty substitute. |
| Academic affairs — “Where is my broader academic standing?” | `lib/features/shell/domain/model/home_tile.dart:5` | `20261101-163309.jpg`; full GPA/conduct/trend feature remains unavailable. |
| Homeroom class — “Where is my class information?” | `lib/features/shell/domain/model/home_tile.dart:6` | Home tile only; no body reference. |
| Tuition — “What fees do I owe?” | `lib/features/shell/domain/model/home_tile.dart:7` | Home tile only; no body reference. |
| Credit registration — “Can I enrol in classes here?” | `lib/features/shell/domain/model/home_tile.dart:8` | `20261101-163303.jpg`, `20261102-223735.jpg`, `20261102-223809.jpg`; not the eligibility service. |
| Community activities — “Which activities can I join?” | `lib/features/shell/domain/model/home_tile.dart:9` | `20261102-223821.jpg`; actual feed unavailable. |
| Assistant — “Can I get student assistance here?” | `lib/features/shell/domain/model/home_tile.dart:10` | Lower Home tile only; no body reference. |
| Feedback — “Can I send feedback here?” | `lib/features/shell/domain/model/home_tile.dart:11` | Lower Home tile only; no body reference. |
| Service queue — “Can I take a service queue ticket here?” | `lib/features/shell/domain/model/home_tile.dart:12` | Lower Home tile only; no body reference. |

**Layout decisions — from dDUT 20261101-163250.jpg and from dDUT 20261101-163257.jpg:** preserve recognizable tile names/icon-over-label composition at Home. **Layout decisions — from dDUT 20261102-223735.jpg:** each unsupported destination uses a blue back/title toolbar and a restrained information card, not a fake populated screen. **Layout decisions — no dDUT reference:** for missing body references, no more detailed layout is asserted. Credit registration, Academic affairs, and Community activities retain the mapped screenshot's header/card language but intentionally omit live tabs/charts/search/feed controls that have no connected data.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Correct feature name and explicit availability | No response field; named local model `lib/features/shell/domain/model/home_tile.dart:1`, label mapping `lib/features/shell/presentation/components/home_tile_presentation.dart:8` | primary | Feature-specific title plus “Not connected in this app”; do not present a generic demonstration blurb as if it were feature data. |
| Return action, and only a genuinely related working alternative | No response field; Home route `lib/common/routes/route_paths.dart:5`; supported alternatives `lib/common/routes/route_paths.dart:16`, `lib/common/routes/route_paths.dart:17` | primary | Back/Home for all; Credit registration may link explicitly to “Check registration eligibility (advice only).” Results goes to the existing results flow. Do not send every unrelated feature to Curriculum. |

**Must NOT show:** invented timetable/classes/fees/activities/support tickets/queue numbers, borrowed screenshot counts/statuses, inactive controls masquerading as functional search/tabs/actions, or student profile information. No new backend fields/endpoints are designed to fill these views.

**Context needed:** authenticated shell only. A related academic alternative resolves the shared context on entry, not on the placeholder.

**States:** available static explanation is not an empty service result. Loading/error/partial service-data states are not applicable while unconnected; say unavailable directly. Unknown feature names use the route-error screen. Authentication expiry returns to sign-in. Academic-results deep links use normal Progress/Results loading and partial states instead of the placeholder.

**Left out (web only)**
- Unrelated curriculum data on every placeholder: it does not answer that feature's question; returning Home is the honest default.
- dDUT live registered classes, GPA/conduct charts, activity list metadata/search/pagination/rewards, tuition and queue content: no corresponding calls exist in the app's inspected API surface; escalation E2. Document the reference pattern without fabricating a service.

### 2.13 Sign-in landing and form

**Job:** “How do I sign into my student account?”

**Layout decisions — from dDUT 20261101-163230.jpg:** full-screen blue hero, institutional mark, strong welcome hierarchy, restrained explanatory copy, one wide white sign-in CTA, no bottom nav. **Layout decisions — no dDUT reference:** the CTA opens the existing local-account form sheet; the screenshot does not show this form. Do not copy an institutional SSO promise into a local-password app.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Sign-in action and truthful local-account explanation | No response field; existing landing/form entry `lib/features/auth/presentation/login/login_screen.dart:21` | primary | One initial CTA; no academic data or production account examples. |
| Username and masked password inputs | Request `username`, `password` — `login.dto.ts:18`, `login.dto.ts:24` | primary | Form sheet only after CTA; values come from the user, never from screenshots or fixture credentials. |
| Submission feedback and next gate | Authenticated response `mustChangePassword` — `me.dto.ts:26`; current routing `lib/common/routes/app_router.dart:49` | primary | Inline validation/error and disabled duplicate submit; successful sign-in enters required password change or Home. |

**Must NOT show:** stored/prefilled secrets, screenshot identity/photo, academic context, local demo credentials, or fake SSO integration. No unsupported “forgot password” workflow is implied.

**Context needed:** no student/programme/semester context; authentication creates the account context.

**States:** empty inputs invite sign-in; submitting shows progress without replacing the whole landing; validation/auth/network errors allow correction/retry and never disclose another account's existence; success routes through password-change gate. Partial authentication does not display student content before session resolution.

**Left out (web only)**
- Portal academic data and desktop navigation: not relevant before authentication. The dDUT provider-specific sign-in copy also stays out unless its integration is separately approved.

### 2.14 Session bootstrap and unknown destination

**Job:** “Is the app ready, or how do I return from an unavailable destination?”

**Layout decisions — no dDUT reference:** these are system states, not separate screenshot-backed dashboards. Bootstrap uses a small neutral loader; unknown destination uses a clear title/message and Home action, without stack traces.

**Must show**

| Data | API field (file:line) | Priority (primary/secondary) | Grouping/order |
|---|---|---|---|
| Session-resolution status | No display field; existing session gate `lib/common/routes/app_router.dart:49`, bootstrap `lib/common/routes/app_router.dart:79` | primary | Loading only while session is genuinely unresolved; then Home, sign-in, or required password change. |
| Unavailable-destination message and return Home | No response field; existing route error `lib/common/routes/app_router.dart:65` | primary | Plain explanation and one working exit; raw exception strings are not student content. |

**Must NOT show:** last account's identity/results, unresolved academic context, debug routes, or error stack details.

**Context needed:** session resolution only; academic requests wait for a settled authenticated context.

**States:** bootstrap loading resolves to the correct gate; session/network error gives retry/sign-in rather than an endless skeleton. Unknown destination is not a successful empty academic screen. No partial personal data is shown during account transitions.

**Left out (web only)**
- Any academic dashboard content before resolution: prevents both distraction and another context's data flashing on screen.

## 3. Current app violations

Ordered by risk to correct understanding, then by dDUT structural fidelity. These are source-backed observations, not claims that the Flutter app was launched or visually tested. Deliberate omissions of unsupported screenshot services are identified as boundaries, not demands to build them.

| Screen | File:line | Problem | Fix direction |
|---|---|---|---|
| Curriculum area entry | `lib/features/portal/presentation/overview/portal_overview_screen.dart:70` | The first content is name/student code/cohort/major/status, although this screen's job is curriculum applicability and academic navigation. It is neither a dDUT child-screen header nor useful curriculum content. | Move detailed student identity to Profile, keep brief identity on Home only, and lead academic entry with one context summary and purpose-labelled destinations. |
| Home / timetable state | `lib/features/shell/presentation/components/today_card.dart:62` | Unconditionally says there is no schedule, without a timetable response. Copying the reference's state sentence would copy an unsupported factual claim. | Keep the split date-card layout from `20261101-163250.jpg`, but explicitly say the timetable is not connected. Never infer “no classes.” |
| Registration eligibility | `lib/features/portal/presentation/registration/registration_screen.dart:53` | Semester/timestamp/warnings lead into advice, but there is no advice-only/no-enrolment limitation; dDUT's real registration structure could make the student misread advice as an enrolment service. | Place a short scope limitation before candidate/blocked tabs; do not imitate registered-class totals, registration status, caps, or seat availability. |
| Graduation review | `lib/features/portal/presentation/graduation/graduation_screen.dart:80` | The live-review/not-official-decision limitation is already shown through `graduationInfo` (`lib/l10n/app_vi.arb:70`), but styled as a section heading. Programme/cohort/semester/version metadata in the conclusion banner still dilutes the quick answer. | Lead with conclusion, present the existing limitation as supporting copy, then missing items; remove cohort and put evaluation basis one tap away. |
| Academic context duplication / visibility | `lib/features/portal/presentation/overview/portal_overview_screen.dart:89`; `lib/features/portal/presentation/curriculum/curriculum_screen.dart:53` | Full programme/version/decision metadata appears on entry and again in Curriculum. The selectors themselves are only on entry, while child screens lack one consistent visible context control. This is duplicated context presentation, not multiple independent cubits. | One curriculum-shell context summary/edit surface; decision in entry detail only. Remove repeated programme cards and give every academic destination the same context access. |
| Progress & results | `lib/features/portal/presentation/progress/progress_screen.dart:64`; `lib/features/portal/presentation/graduation/graduation_screen.dart:124` | Progress has overall credits and attempts, but no elective-group/named-block breakdown; those figures are stranded on Graduation. The student cannot explain a credit gap from the progress task. | Add one-tap Credit breakdown using existing response fields; do not copy all web audit tables onto the landing view. |
| Home / results destination | `lib/features/shell/presentation/components/home_tile_presentation.dart:36` | Every non-Curriculum tile, including Academic results, goes to a placeholder despite an existing results screen. | Reuse the context-gated Results view for that tile; do not create a second transcript implementation. |
| Curriculum / term credits | `lib/features/portal/presentation/curriculum/curriculum_screen.dart:77` | The term's returned credit subtotal is presented generically, although the backend sums compulsory courses only (`student-portal.service.ts:287`). | Label it “Compulsory credits,” not total credits for all courses or all elective alternatives. |
| Curriculum / equivalent completion | `lib/features/portal/presentation/curriculum/curriculum_screen.dart:105`; `lib/features/portal/data/remote/dto/eligibility_reason_dto.dart:7` | Completion chip and score strings cannot identify the actual course used for equivalent recognition; the client reason model keeps only message text. | Make equivalent-course evidence available in one-tap completion detail from the already-called eligibility response; no new endpoint. |
| Profile | `lib/features/shell/presentation/profile/profile_screen.dart:55`; `lib/features/shell/presentation/profile/profile_screen.dart:61` | Account name is repeated in header/info card, role/account-code rows are prominent, and student cohort/major/study status remain on the wrong academic-entry screen. | One identity header; student academic identity and login/email in purposeful expandable details; remove low-value authorization/account-code display. |
| Curriculum / information density | `lib/features/portal/presentation/components/course_row.dart:31`; `lib/features/portal/presentation/curriculum/curriculum_screen.dart:105` | Generic ListTile/divider rows show course name before code/credits and spread grades, elective metadata, block symbol and repeats into a default wrap. The result departs from the clear card/subheading hierarchy of `20261102-223814.jpg`. | Rounded light-grey course cards: muted code/credits, blue name, concise completion state, one-tap score/equivalence explanation. Remove repeat/block clutter from first view. |
| Syllabus | `lib/features/portal/presentation/syllabus/syllabus_screen.dart:77`; `lib/features/portal/presentation/syllabus/syllabus_screen.dart:95` | Long rich-text sections/CLOs/weeks are laid out serially before or around assessment, turning a quick phone check into document reading. | Put assessment after the compact course header; make learning content/documents one-tap disclosures and omit low-value narrative panels. No direct dDUT syllabus reference exists. |
| Progress summary / dDUT hierarchy | `lib/features/portal/presentation/components/credit_progress_card.dart:32` | Six equally structured label/value rows plus a bar, instead of the clear leading KPI and compact companion facts in `20261101-163309.jpg`; free-credit allocation adds landing-view noise. | Use recognized credits as the large supported metric; required/missing beside it; move targeted breakdown to one tap. Do not invent GPA or conduct metrics. |
| Registration / dDUT tabs and density | `lib/features/portal/presentation/registration/registration_screen.dart:71`; `lib/features/portal/presentation/components/eligibility_item_card.dart:78` | Allowed and blocked lists are stacked and all reasons expanded, instead of the distinct tab/list and short card hierarchy in `20261102-223735.jpg` / `20261102-223814.jpg`. | Candidate/blocked tabs, concise reason preview, conditional-course obligation visible, full evidence in one tap. Do not reuse the screenshot's enrolled-class semantics. |
| Registration / concurrent-course identity | `lib/features/portal/presentation/registration/registration_screen.dart:103` | Concurrent courses are reduced to codes even though code/name are available; this weakens the action the student must plan. | Include code plus readable name in conditional-course summary/detail, without copying screenshot course data. |
| Registration / defensive unknown state | `lib/features/portal/presentation/registration/registration_screen.dart:88`; `lib/features/portal/presentation/registration/registration_state.dart:18` | A null verdict can fall through to an eligible chip/candidate; valid backend nulls accompany completed items, but malformed unfinished/null content must not become a green answer. This is a latent fallback risk, not evidence of bad live data. | Keep completed items excluded and render unfinished/unknown verdict as unavailable advice, never eligible. |
| Graduation / over-expansion | `lib/features/portal/presentation/graduation/graduation_screen.dart:93`; `lib/features/portal/presentation/graduation/graduation_screen.dart:124` | Full credit card, every elective group and knowledge block create a long secondary accounting page. Block advisory values may look like separate required thresholds (`lib/features/portal/presentation/components/knowledge_block_row.dart:38`). | Keep missing items primary, link routine breakdown to Progress, and omit advisory accounting tables from the phone audit. Missing web recognition/free-credit ledgers are intentionally not “fixed” by adding more tables. |
| Home identity header / dDUT | `lib/features/shell/presentation/components/profile_header_card.dart:22` | Neutral AppCard with dark text/bell rather than the blue identity strip with white hierarchy in `20261101-163250.jpg` / `20261101-163257.jpg`. | Restore blue rounded header, light name/subtitle/bell, circular initials fallback. A real student photo is not required or available. |
| Home calendar card / dDUT | `lib/features/shell/presentation/components/today_card.dart:18`; `lib/features/shell/presentation/components/today_card.dart:50` | Date and icon/message occupy vertically stacked sections separated by a horizontal divider; the reference uses narrow date-left, larger message-right columns with a vertical divider. | Recreate that split composition and numeric-day hierarchy, with truthful disconnected-state copy. |
| Home tiles / dDUT | `lib/features/shell/presentation/components/feature_tile.dart:33` | Current tile is a horizontal icon/text row with a border; both Home screenshots show spacious vertically centred icon-above-label cards with soft shadows. | Keep two columns but restore vertical centred tile composition, generous insets, rounded corners and gentle elevation. Curriculum-first is an intentional added tile, not a fidelity defect. |
| Shell bottom navigation / dDUT | `lib/features/shell/presentation/components/bottom_nav_bar.dart:32`; `lib/features/shell/presentation/components/bottom_nav_bar.dart:71` | Edge-style Material bar/top border and text labels rather than the floating rounded white two-icon pill and short selected-item line visible in both Home references. | Use the floating pill geometry with accessible icon semantics and selected indicator. Do not add web portal tabs to this bar. |
| Academic toolbars / dDUT | `lib/common/theme/app_theme.dart:38`; `lib/common/theme/app_theme.dart:224` | Light page-background app bars with brand foreground differ from the solid-blue, white-title/back-arrow toolbar across the child-screen screenshots. | Adopt the dDUT child toolbar language for mapped academic destinations; keep identity off those toolbars. |
| Card separation / dDUT | `lib/common/widgets/app_card.dart:22` | The non-legacy branch is flat/bordered, unlike the soft-shadow Home/activity cards. One flat treatment also blurs the distinction between shell cards and pale-grey course-detail cards. | Match treatment by reference role: soft-elevated white shell cards, restrained pale-grey course cards. This is not a mandate to elevate every panel. |
| Placeholders / wrong exit | `lib/features/shell/presentation/placeholder/placeholder_screen.dart:35` | Every unrelated feature shows generic demo text and directs the student to Curriculum; there is no feature-specific answer about availability. | Feature-named unavailable message and Back/Home; only genuinely related alternatives. Results reuses its implemented screen. |
| Community activities / reference boundary | `lib/features/shell/presentation/placeholder/placeholder_screen.dart:21`; `lib/common/routes/app_router.dart:136` | The generic placeholder does not resemble the community-list hierarchy in `20261102-223821.jpg`; however, activity records/search/rewards are not connected and must not be invented. | Match the blue title/header and restrained information-state language now. Defer live list/search/pagination/actions to E2; absence of fabricated feed cards is intentional. |
| Credit registration / reference boundary | `lib/features/shell/presentation/placeholder/placeholder_screen.dart:21`; `lib/features/shell/domain/model/home_tile.dart:8` | A generic Curriculum CTA neither identifies unavailable enrolment nor reflects the registration reference's contextual state arrangement. Actual registered-class tabs/totals cannot be copied honestly. | Use the reference toolbar/contextual information card with an explicit unavailable-enrolment explanation and optional eligibility-advice link; defer enrolment data to E2. |

## 4. Open questions for the owner

These are not runtime blockers for writing this specification. There was nobody to ask mid-run; the recommended defaults define this document's phone-first position, and material alternatives remain for owner approval before implementation.

| ID | Question | Recommended default |
|---|---|---|
| Q1 | Should the Academic results tile stay a replica placeholder or open the existing results flow? | Open the existing context-gated Results view. It answers the tile's job without a new screen or endpoint. |
| Q2 | Keep all eleven feature tiles or hide features not connected in this app? | Keep the established dDUT structure, Curriculum first, but visibly identify unconnected features and give them honest named placeholders. |
| Q3 | Should the Home subtitle exactly imitate the screenshot's email slot, or identify the student more directly? | Keep the same subtitle position but use `<student code>` when linked, login name otherwise; email remains one tap away in Profile. This is an intentional content difference, not a new field request. |
| Q4 | Should Registration eligibility automatically jump to a presumed next semester? | No. Use the one explicit academic-semester control; do not infer next-term offerings or registration windows from planned term numbers. |
| Q5 | Should Academic affairs redirect to Progress, even though the real dDUT page contains broader metrics? | Keep it explicitly unavailable for the broader feature, with an optional labelled Progress alternative. Do not pretend credit progress is GPA/conduct/trend parity. |
| Q6 | Must the next redesign include the complete structured assessment pass-condition formula requested by US-096? | Show only supplied components/weights/narrative now, explicitly avoid a completeness claim, and track E1 as a separate backend/product follow-up. Do not invent thresholds during UI work. |

Open questions count: **6**.

## 5. Escalations and backend boundary

Stop at these boundaries: this document neither designs new endpoints/fields nor invents their values. Existing supported phone screens can be redesigned independently; the following cannot be promised from the inspected contracts.

| ID | Missing capability / decision requiring escalation | Evidence and consequence | Stopped work / safe default |
|---|---|---|---|
| E1 | Structured assessment conditional-component flags and pass thresholds for complete US-096 formula coverage | Sister `docs/planning/user-stories.md:1176` requires condition components/thresholds; the student assessment projection contains only component code/name/weight/form (`student-portal.dto.ts:110`) and narrative (`student-portal.dto.ts:137`). No structured condition/threshold fields are exposed. | Do not specify a new contract. Show the available assessment data and issued documents; flag full formula coverage as unresolved backend work. |
| E2 | Real dDUT services/metrics outside the app's called API surface | Screenshots show actual registered classes/windows/caps/sections, GPA/conduct/study-year/trends, community feeds/capacity/rewards, and institutional sign-in. The app's portal call surface is the academic reads at `lib/features/portal/data/remote/portal_api.dart:38`; auth form uses `login.dto.ts:18`. Timetable/fees/notification feed/queue services are likewise not connected by those calls. This is not a claim that no endpoint exists anywhere else in the sister system. | Do not invent API routes, integrate external services, calculate unsupported aggregate grades, or copy screenshot data. Keep those feature bodies unavailable. Activating them needs separately confirmed student-safe contracts/integration and owner scope. |
| E3 | Specific explanation of each programme omitted by applicability resolution | `student-portal.service.ts:166` drops an enrollment's resolver exception and omits that programme; `student-portal.dto.ts:53` supplies no per-programme resolution diagnostic. The UI cannot distinguish “not enrolled” from every omitted-programme data/configuration issue. | Use the truthful generic “No applicable programme could be determined” gate. A precise per-programme explanation would need additional backend information; no field design is supplied here. |
| E4 | Complete prerequisite/downstream-impact graph matching the course-constraints screenshot | `20261102-223814.jpg` has sections for prerequisites and downstream effects. Existing eligibility DTOs return evaluated reasons/path/evidence (`registration-eligibility.dto.ts:28`, `registration-eligibility.dto.ts:59`), not an asserted complete course-relationship graph. Absence of a reason is not proof that no relationship exists. | Show only returned reason/concurrent-course evidence. Do not label a full graph or show “No downstream effects” without authoritative graph data. Any exact feature parity requires a separately confirmed backend read/field, not a UI-only inference. |

Not backend escalations: equivalent-course identity can reuse the eligibility response; Progress breakdown can reuse live graduation fields; full-score attempt detail can use existing result fields; the Home results shortcut can reuse the existing route. Missing client DTO/domain mappings are future Flutter work, not permission to request new backend data. Conversely, omitted desktop recognition/free-credit ledgers are an intentional content decision, not a missing-primary-data defect.

## 6. Redesign handoff and limits

- Implement only after this content specification is accepted; it is not code or a build-ready implementation plan.
- Keep the three anchors: **dDUT layout**, **phone task relevance**, **existing API truth**. A screenshot establishes presentation, not data entitlement or backend capability.
- All primary content has an identified source; secondary content is on demand, and intentionally excluded desktop content stays excluded unless the phone job changes.
- No Flutter/Dart/package commands, git commands, live API requests, or external-system changes were used. Source review and the nine permitted image views do not establish runtime visual fidelity or live-data correctness.
- Only this Markdown document is in scope. No application code, assets, screenshot files, sister-repository files, or other documentation may change in this task.
