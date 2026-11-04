# F-28 dDUT Replica with Curriculum Block — Flutter App Implementation Plan

Builds a standalone Flutter app (Android + iOS, tested on Android) that copies the look of the school's dDUT app shell — login landing, home tab with profile card, date card and feature tiles, profile tab — and adds one new tile, **Chương trình đào tạo**, that opens a real Curriculum block with feature parity to the web student portal (F-20): overview, my curriculum, syllabus + attachments, PLOs, progress + results, registration eligibility, live graduation check. Every other dDUT tile opens one shared placeholder page. The app talks to the existing PBL6 backend with the same cookie session as the web. Excludes: Microsoft/Office 365 login, timetable/fees/class data (no backend for them), push notifications, offline storage, any staff feature, any backend change other than the demo student seed.

> **Companion documents**
> - Backend side (demo account): `E:\PBL6\curriculum-management\docs\implementation\f-28-demo-student-account-implementation-plan.md`
> - Web sibling: `E:\PBL6\curriculum-management\docs\implementation\f-20-student-portal-implementation-plan.md`; code `source/frontend/src/features/student-portal/`
> - Stack rules: `E:\claude-code-templates\stacks\flutter\rules\flutter-rules.md` (copied into this repo by E-01) + `~/.claude/rules/ai-rules.md`
> - Visual reference: `design/20261101-163230.jpg` (login), `design/20261101-163250.jpg` (home); other three screenshots become placeholders
> - Requirement source: no epic exists; the requirements are the user's decisions of 2026-11-01, listed as R-01..R-12 in §1

**Status**: Complete — not yet verified on a device

## 0. Plan at a glance

Everything below in one table. Read this; the rest is detail for whoever builds it.

| What | Why | How and where |
|---|---|---|
| **A dDUT look-alike app shell** — blue gradient login with a "dDUT" text wordmark, home with profile card, today card, tile grid, bottom nav Home/Profile | Demo of how the curriculum system would sit inside dDUT; the user asked for the dDUT theme | Theme tokens from the screenshots in `lib/common/theme/`; screens in `lib/features/shell/` and `lib/features/auth/` |
| **Login with username and password** | Real dDUT uses Office 365; the backend only has password login | "ĐĂNG NHẬP" button opens a form sheet → `POST /api/auth/login`; cookie session persisted on device |
| **Session handled like the web** — cookie + `x-requested-with` header, 60-minute idle expiry | Backend is cookie-session only; CSRF guard requires the header | Dio + persisted cookie jar + interceptors; a 401 sends the user back to login with a message |
| **Change password, forced when the account requires it** | Imported student accounts start with `mustChangePassword = true` | `POST /api/auth/change-password`; router redirect when `mustChangePassword` |
| **New tile "Chương trình đào tạo"** opening the Curriculum block | The one real feature in the demo | First tile in the grid; route `/curriculum` |
| **Curriculum block = web student portal parity** | User asked for full parity with F-20 | Seven screens under `lib/features/portal/` reading `/api/portal/*`, `/api/students/:id/{results,registration-eligibility,graduation}`, `/api/semesters` |
| **Every other dDUT tile → one placeholder page** | Timetable, fees, etc. have no backend | One `PlaceholderScreen` with a button "Mở Chương trình đào tạo" |
| **Built by the flutter rules template** | User asked to follow the rules already in place | Clean Architecture per feature, Cubit + Equatable, get_it + injectable, Flutter `gen-l10n` strings, no silent failures |
| **Demo account `demo.sinhvien`** | Real students must not be shown | Backend seed script (companion plan); the app needs nothing special |

**Key behaviours worth knowing**

| Behaviour | Why it is this way |
|---|---|
| Changing the semester refetches `/portal/me` and resets the program to the first one | Same as the web; a program list depends on the semester |
| Progress and graduation can show a diagnostic instead of numbers | Graduation returns `CANNOT_AUDIT` when Faculty input (C4) is missing; the app shows `error.message`, like the web |
| A staff account can log in, but the Curriculum block shows "Tài khoản chưa được liên kết với hồ sơ sinh viên…" | `/portal/me` returns `student: null` for unlinked users |
| Attachments open in the phone's viewer after download | Mobile has no browser download; file goes to the app cache |
| Syllabus sections are rendered HTML | The backend stores sanitized HTML (`schema.prisma:728`) |
| The home "today" card always says "Hôm nay không có lịch nào!" | No timetable source; it is part of the replica |

**Not included**

| Excluded | Why |
|---|---|
| Office 365 / Microsoft login | No backend support; needs an identity-provider integration |
| Timetable, fees, class, community, assistant, feedback, queue tiles | No data source; placeholders only |
| Real DUT logo / student photo | No licensed assets; personal data in the screenshots must not be copied |
| iOS device testing | No Mac; iOS project config is written but unverified |
| Offline cache (sqflite) | Every screen is live data; the template's sqflite rules do not apply |

**Open questions**

| Question | Resolved when | Default if unanswered |
|---|---|---|
| Should "Chương trình đào tạo" be the first tile? | User says otherwise | First tile |

## 1. Scope

| In scope | Why |
|---|---|
| R-01 Login landing replica + username/password form | User decision |
| R-02 Session persistence, logout, idle-expiry handling | Backend session contract |
| R-03 Change password (voluntary + forced) | `mustChangePassword` accounts |
| R-04 Home tab replica (profile card, today card, tile grid) | dDUT theme |
| R-05 Profile tab (identity, change password, logout) | dDUT shell |
| R-06 Placeholder page for all non-curriculum tiles | User decision |
| R-07 Curriculum overview: student, program/version/cohort, semester picker, PRIMARY/SECOND_MAJOR switch | Web parity |
| R-08 My curriculum by planned semester with course states and scores | Web parity |
| R-09 Syllabus detail + attachment download | Web parity |
| R-10 PLO list | Web parity |
| R-11 Progress (recognised credits) + results list; registration eligibility with reasons | Web parity |
| R-12 Live graduation check | Web parity |

| Out of scope | Deferred until |
|---|---|
| Office 365 login | dDUT integration |
| Merge into the real dDUT codebase | After the demo |
| Localisation other than Vietnamese | Not planned |

| Requirement | Covered by |
|---|---|
| R-01 | E-02, C-01, C-02, A-01..A-05 |
| R-02 | C-03..C-06, A-03, A-04 |
| R-03 | A-06 |
| R-04 | S-01..S-03 |
| R-05 | S-04 |
| R-06 | S-05 |
| R-07 | P-01..P-05 |
| R-08 | P-06 |
| R-09 | P-07 |
| R-10 | P-08 |
| R-11 | P-09, P-10 |
| R-12 | P-11 |

## 2. Contract verification

All paths below are relative to `E:\PBL6\curriculum-management\source\backend\`. Global prefix `api` (`src/app.setup.ts:23,44`).

### 2a. Endpoints

| Endpoint | Verified at | Request | Response | Notes |
|---|---|---|---|---|
| `POST /api/auth/login` | `src/features/auth/auth.controller.ts:48-59` | `{username, password}` (`login.dto.ts`; username ≤ 64, normalized) | 200 `MeDto` | Public; starts session; sets cookie `ctdt.sid` (`src/shared/session/session.constants.ts:1`). 401 `INVALID_CREDENTIALS`, 403 `ACCOUNT_DISABLED` (`auth.errors.ts`) |
| `POST /api/auth/logout` | `auth.controller.ts` | — | 204 | Public; clears cookie |
| `GET /api/auth/me` | `auth.controller.ts:75` | — | `MeDto` | Allowed while password change pending |
| `POST /api/auth/change-password` | `auth.controller.ts:86-99` | `{currentPassword, newPassword}` | **204, no body** | `newPassword` 8–128 chars, ≥ 1 letter + ≥ 1 digit (`src/shared/password/password-policy.ts:1-3`); 400 `CURRENT_PASSWORD_WRONG`, `PASSWORD_UNCHANGED` |
| `GET /api/semesters` | `src/features/semesters/semesters.controller.ts:19` | — | `SemesterDto[]` | Any authenticated user |
| `GET /api/portal/me` | `src/features/student-portal/student-portal.controller.ts:32` | `?semesterId` optional | `PortalMeDto` | **Never 404s**: unlinked user → `{student:null, semester:null, programs:[]}` (`student-portal.service.ts:106`); default semester = latest started; programs PRIMARY first |
| `GET /api/portal/curriculum` | `student-portal.controller.ts:43` | `?programId&semesterId` | `PortalCurriculumDto` | `Cache-Control: no-store` |
| `GET /api/portal/plos` | `student-portal.controller.ts:54` | `?programId&semesterId` | `PortalPloDto[]` | |
| `GET /api/portal/curriculum-items/:itemId/syllabus` | `student-portal.controller.ts:65` | `?programId&semesterId` | `PortalSyllabusDto` | 404 `PORTAL_ITEM_NOT_FOUND`, `PORTAL_SYLLABUS_NOT_ISSUED` (`student-portal.errors.ts`) |
| `GET /api/portal/curriculum-items/:itemId/syllabus/attachments/:attachmentId/file` | `student-portal.controller.ts:77` | `?programId&semesterId` | binary stream | 404 `PORTAL_ATTACHMENT_NOT_FOUND` |
| `GET /api/students/:studentId/results` | `src/features/students/students.controller.ts:87` | `?programId&semesterId&page&pageSize` (+ optional `resultSemesterId`, `courseId`) — `dto/student-query.dto.ts:79` | `AcademicResultPageDto` | `pageSize` max 100, default 20 (`src/shared/pagination/page-query.dto.ts:7-8`) |
| `GET /api/students/:studentId/registration-eligibility` | `src/features/registration-eligibility/registration-eligibility.controller.ts` | `?programId&semesterId` | `RegistrationEligibilityDto` | R6 holds the permission (`prisma/seed-data/permission-catalog.ts:331`) |
| `GET /api/students/:studentId/graduation` | `src/features/graduation/graduation.controller.ts:57` | `?programId&semesterId` (`graduation.dto.ts:14`) | `GraduationOutcomeDto` (discriminated on `status`, `graduation.dto.ts:282`) | Computed live, nothing saved; R6 holds `graduation.view` (`permission-catalog.ts:338`) |

Cross-cutting facts:

| Fact | Source |
|---|---|
| Every request must carry `x-requested-with: XMLHttpRequest`, else 403 `CSRF_HEADER_MISSING` | `src/shared/auth/csrf.guard.ts:10-23` |
| Session cookie: httpOnly, `secure` only in production, rolling, 60-minute idle | `src/shared/session/session-store.service.ts:20-45` |
| No session → 401 `SESSION_REQUIRED`; password change pending → 403 `PASSWORD_CHANGE_REQUIRED` | `src/shared/exception/error-codes.ts:17,23` |
| Error body `{statusCode, code, message, details?}` | `src/shared/dtos/error-response.dto.ts:11-22` |
| Student scope: R6 reads only the student whose `userId` is the caller | `src/shared/students/student-access.ts:197-222` |
| Decimal fields (credits, scores, weights) are **strings** on the wire | each DTO below |

### 2b. DTO field tables

Domain rule (flutter-rules §9): dates become epoch-ms `int`; fixed sets become Dart enums. Decimal strings stay `String` and are formatted at the UI edge (`.` → `,`).

**`MeDto`** — `src/features/auth/me.dto.ts:20-38`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `id` | string | no | `:20` | `SessionUser.id` | |
| `username` | string | no | `me.dto.ts` | `SessionUser.username` | |
| `userCode` | string | no | `me.dto.ts` | `SessionUser.userCode` | |
| `fullName` | string | no | `me.dto.ts` | `SessionUser.fullName` | header card |
| `email` | string | **yes** | `me.dto.ts` | `String?` | header shows `email ?? username` |
| `mustChangePassword` | boolean | no | `me.dto.ts` | `bool` | router redirect |
| `orgUnit` | `OrgUnitRefDto` | **yes** | `me.dto.ts` | **not modeled** | no student use |
| `roles` | `MeRoleDto[]` | no | `me.dto.ts` | `List<String> roleNames` (from `roleName`) | profile tab only; `roleCode`, `scopeType`, `scopeUnit`, `derived` not modeled |
| `permissions` | `PermissionCode[]` | no | `me.dto.ts` | **not modeled** | server enforces |
| `canApprove` | boolean | no | `:38` | **not modeled** | staff only |

**`SemesterDto`** — `src/shared/releases/semester.dto.ts:5`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `id` | string | no | `:5` | `Semester.id` | |
| `semesterCode` | string | no | | `Semester.code` | label |
| `academicYear` | string | no | | `Semester.academicYear` | |
| `termInYear` | number | no | | `int` | |
| `startDate` | `YYYY-MM-DD` | **yes** | | `int? startDateMs` | picker keeps only non-null (web rule) |
| `startDateEstimated` | boolean | no | | **not modeled** | |

**`PortalMeDto`** and children — `src/features/student-portal/dto/student-portal.dto.ts`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `student` | `PortalStudentDto` | **yes** | `:55` | `PortalStudent?` | null → "chưa liên kết" message |
| `student.id` | string | no | `:28` | `id` | used as `:studentId` |
| `student.studentCode` | string | no | `:29` | `studentCode` | |
| `student.fullName` | string | no | `:30` | `fullName` | |
| `student.cohortCode` | string | no | `:31` | `cohortCode` | |
| `student.major` | string | no | `:32` | `major` | |
| `student.status` | `'STUDYING' \| 'ON_LEAVE' \| 'WITHDRAWN' \| 'GRADUATED'` | no | `:34`, `prisma/schema.prisma:1149` | `StudentStatus` | |
| `semester` | `PortalSemesterDto` | **yes** | `:57` | `PortalSemesterRef?` | `{id :49, semesterCode :50}` |
| `programs` | `PortalProgramDto[]` | no | `:58` | `List<PortalProgram>` | empty → `NO_PROGRAM_MESSAGE` |
| `programs[].programId` | string | no | `:38` | `programId` | |
| `programs[].programCode` | string | no | `:39` | `programCode` | |
| `programs[].programName` | string | no | `:40` | `programName` | |
| `programs[].enrollmentType` | `'PRIMARY' \| 'SECOND_MAJOR'` | no | `:42`, `schema.prisma:1161` | `EnrollmentType` | |
| `programs[].versionId` | string | no | `:43` | **not modeled** | server resolves |
| `programs[].versionNumber` | string | **yes** | `:44` | `String?` | |
| `programs[].decisionNumber` | string | **yes** | `:45` | `String?` | NULL in `ctdt_real` |

**`PortalCurriculumDto`** — `student-portal.dto.ts:61-90`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `programName` | string | no | `:86` | `programName` | |
| `versionNumber` | string | **yes** | `:87` | `String?` | |
| `decisionNumber` | string | **yes** | `:88` | `String?` | |
| `totalCredits` | decimal string | no | `:89` | `String` | |
| `terms[].plannedSemester` | number | no | `:80` | `int` | "Học kỳ {n}" |
| `terms[].credits` | decimal string | no | `:81` | `String` | |
| `courses[].itemId` | string | no | `:62` | `itemId` | syllabus route param |
| `courses[].courseId` | string | no | `:63` | **not modeled** | |
| `courses[].courseCode` | string | no | `:64` | `courseCode` | |
| `courses[].courseName` | string | no | `:65` | `courseName` | |
| `courses[].credits` | decimal string | no | `:66` | `String` | |
| `courses[].isElective` | boolean | no | `:67` | `bool` | "Tự chọn" badge |
| `courses[].groupName` | string | **yes** | `:68` | `String?` | |
| `courses[].blockSymbol` | string | **yes** | `:69` | `String?` | |
| `courses[].state` | `'PASSED' \| 'PASSED_EQUIVALENT' \| 'IN_PROGRESS' \| 'FAILED' \| 'NOT_TAKEN'` | no | `:71`, `:9` | `CourseState` | label + colour, never colour alone |
| `courses[].attemptCount` | number | no | `:72` | `int` | shown when > 1 |
| `courses[].score10` | decimal string | **yes** | `:73` | `String?` | |
| `courses[].score4` | decimal string | **yes** | `:74` | `String?` | |
| `courses[].letterGrade` | string | **yes** | `:75` | `String?` | |
| `courses[].hasSyllabus` | boolean | no | `:76` | `bool` | tap disabled when false |

**`PortalPloDto`** — `:93-96`: `ploCode` string → `code`; `description` string → `description`; `competencyGroup` string **nullable** → `String?`.

**`PortalSyllabusDto`** — `:100-140`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `courseCode`, `courseName` | string | no | `:127-128` | same | |
| `credits` | decimal string | no | `:129` | `String` | |
| `revisionNumber` | number | no | `:130` | `int` | "Lần sửa {n}" |
| `publishedAt` | date-time string | **yes** | `:131` | `int? publishedAtMs` | |
| `courseDescription`, `objectives`, `teachingMethods`, `assessmentMethods`, `references` | sanitized HTML string | **yes** | `:132-140` | `String?` each | rendered as HTML; null → section hidden |
| `clos[]` | `{cloCode, description}` | no | `:100-102` | `List<SyllabusClo>` | |
| `weeks[]` | `{weekLabel, content}` | no | `:105-107` | `List<SyllabusWeek>` | |
| `assessments[]` | `{componentCode, componentName, weight (decimal string), assessmentForm (nullable)}` | no | `:110-114` | `List<SyllabusAssessment>` | |
| `attachments[].id` | string | no | `:118` | `id` | |
| `attachments[].fileName` | string | no | `:119` | `fileName` | |
| `attachments[].materialKind` | `'SIGNED_SYLLABUS' \| 'TEXTBOOK' \| 'LECTURE_SLIDES' \| 'OTHER'` | no | `:121`, `schema.prisma:721` | `MaterialKind` | |
| `attachments[].sizeBytes` | number | no | `:122` | `int` | shown as KB/MB |

**`AcademicResultPageDto`** — `src/features/students/dto/academic-result.dto.ts:8-35`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `items[].id` | string | no | `:15` | `id` | list key |
| `items[].studentId` | string | no | `:16` | **not modeled** | |
| `items[].course` | `{id, courseCode, courseName}` | no | `:8-11,18` | `CourseRef` | |
| `items[].semester` | `SemesterDto` | no | `:19` | `Semester` | same mapper as `/semesters` |
| `items[].score10`, `score4`, `letterGrade` | string | **yes** | `:20-22` | `String?` | |
| `items[].status` | `'PASSED' \| 'FAILED' \| 'IN_PROGRESS' \| 'EXEMPT'` | no | `:24`, `schema.prisma:1172` | `ResultStatus` | |
| `items[].dataSource` | `'EXCEL' \| 'SCHOOL_DB'` | no | `:26`, `schema.prisma:1156` | **not modeled** | staff concern |
| `items[].revision` | number | no | `:27` | **not modeled** | |
| `items[].updatedAt` | string | no | `:28` | **not modeled** | |
| `total`, `page`, `pageSize` | number | no | `:33-35` | `ResultPage` | infinite scroll |

**`RegistrationEligibilityDto`** — `src/features/registration-eligibility/dto/registration-eligibility.dto.ts:18-108`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `contractVersion` | `1` | no | `:103` | checked | ≠ 1 → "Chưa hỗ trợ phiên bản kết quả này" |
| `context` | `{studentId, enrollmentId, programId, semesterId, programVersionId, source 'COHORT'\|'EXCEPTION', cohortAssignmentId?}` | no | `:88-99` | **not modeled** | screen already knows the context |
| `evaluatedAt` | date-time | no | `:105` | `int evaluatedAtMs` | |
| `items[].itemId` | string | no | `:72` | `itemId` | |
| `items[].course` | `{id, courseCode, courseName, nameSource 'SNAPSHOT'\|'CATALOG'}` | no | `:18-26` | `CourseRef` | `nameSource` not modeled |
| `items[].credits` | decimal string | no | `:75` | `String` | |
| `items[].catalogStatus` | `'ACTIVE' \| 'DISCONTINUED' \| 'CANCELLED'` | no | `:77`, `schema.prisma:62` | `CatalogStatus` | non-ACTIVE shown as tag |
| `items[].plannedSemester` | number | no | `:78` | `int` | |
| `items[].completed` | boolean | no | `:79` | `bool` | completed items hidden (web rule) |
| `items[].eligibility` | `'ELIGIBLE' \| 'CONDITIONAL' \| 'INELIGIBLE'` | **yes** | `:81` | `Eligibility?` | null only when completed |
| `items[].statusText` | string | no | `:82` | `String` | server sentence shown verbatim |
| `items[].reasons[].code` | `COURSE_COMPLETED \| EQUIVALENT_COMPLETED \| PREREQUISITE_NOT_PASSED \| PREREQUISITE_SCORE_MISSING \| PREREQUISITE_SCORE_TOO_LOW \| PRIOR_RESULT_MISSING \| COREQUISITE_REQUIRED \| COREQUISITE_INELIGIBLE \| COREQUISITE_RULES_UNAVAILABLE \| COREQUISITE_DEPTH_LIMIT` | no | `:33`, `src/shared/registration-eligibility/eligibility.constants.ts:17` | **not modeled** | `message` carries the text; code not branched on |
| `items[].reasons[].message` | string | no | `:36` | `String` | shown as bullet |
| `items[].reasons[].causeCode`, `relationType`, `requiredCourse`, `viaCourse`, `evidenceCourse`, `evidenceResultId`, `requiredScore4`, `actualScore4`, `actualStatus`, `path` | various, nullable | mixed | `:35-59` | **not modeled** | `message` is already composed server-side |
| `items[].requiredConcurrentCourses[]` | `EligibilityCourseRefDto[]` | no | `:86` | `List<CourseRef>` | "Phải học cùng: …" |
| `warnings[]` | `{code, message, course}` codes `REPLACEMENT_UNAVAILABLE \| EXTERNAL_REQUISITE \| EXTERNAL_COREQUISITE_RULES_UNAVAILABLE \| COURSE_NOT_ACTIVE` | no | `:61-69`, `eligibility.constants.ts` | `List<EligibilityWarning{message, course}>` | code not modeled |

**`GraduationOutcomeDto`** — `src/features/graduation/graduation.dto.ts`

| Field | Wire type | Nullable | Source | Modeled as | Note |
|---|---|---|---|---|---|
| `status` | `'REVIEWED' \| 'CANNOT_AUDIT'` | no | `:260,266,274` | sealed `GraduationOutcome` (`Reviewed` / `CannotAudit`) | discriminator `:282-293` |
| `error` | `{code, message, enrollmentId?}` | **yes** (null when REVIEWED) | `:253-256` | `CannotAudit.message` | code not branched on |
| `result.schemaVersion` | `1` | no | `:207` | checked | ≠ 1 → unsupported message (web `GraduationResultView.tsx:23`) |
| `result.ruleVersion` | `'graduation-v1'` | no | `:208` | **not modeled** | |
| `result.evaluatedAt` | date-time | no | `:209` | `int` | |
| `result.context` | 17 fields | no | `:38-55` | `programCode`, `programName`, `cohortCode`, `versionNumber`, `semesterCode` modeled; rest **not modeled** | header lines |
| `result.conclusion` | `'ELIGIBLE' \| 'NOT_ELIGIBLE'` | no | `:211` | `GraduationConclusion` | "Đủ điều kiện" / "Chưa đủ điều kiện" |
| `result.shortfalls[]` | union by `code`: `MANDATORY_COURSE_MISSING`, `CONDITIONAL_COURSE_MISSING` (course + `reason 'NOT_TAKEN'\|'FAILED'\|'IN_PROGRESS'` + `blockSymbol?` + `message`), `ELECTIVE_CREDITS_MISSING`, `ELECTIVE_COURSES_MISSING` (group + required/earned/missing), `TOTAL_CREDITS_MISSING` (required/earned/missing credits) | no | `:60-113,213-239` | `GraduationShortfall{category, code, title, message}` | grouped by `category` (4 groups, web `GraduationShortfalls.tsx:11-14`); every variant has `message` |
| `result.warnings[]` | `{code 'EQUIVALENT_CREDIT_GAP'\|'CURRENT_CATALOG_CREDIT_BASIS'\|'UNKNOWN_KNOWLEDGE_BLOCK', curriculumItemId?, courseId?, creditGap?, message}` | no | `:178-185`, `src/shared/graduation/graduation.constants.ts:29` | `GraduationWarning{code, message}` | |
| `result.credits` | `{requiredTotal, recognizedTotal, missingTotal, compulsory, elective, free}` decimal strings | no | `:188-194` | `GraduationCredits` | progress bar = recognized / required |
| `result.electiveGroups[]` | `{groupId, groupCode, groupName, requiredCredits?, earnedCredits, missingCredits?, requiredCourses?, earnedCourses, missingCourses?}` | no | `:153-164` | `ElectiveGroupProgress` (groupId not modeled) | null required → "Không quy định" |
| `result.knowledgeBlocks[]` | `{blockSymbol?, blockName?, earnedCredits, compulsoryCredits, electiveCredits, catalogRequiredCredits?, advisoryGap?}` | no | `:167-175` | `KnowledgeBlockProgress` | "Tham khảo, không phải điều kiện xét riêng" |
| `result.recognitions[]` | `GraduationRecognitionDto[]` | no | `:116-139` | **not modeled** | staff detail; web portal does not show it either |
| `result.freeCredits[]` | `GraduationFreeCreditDto[]` | no | `:142-150` | **not modeled** | totals already in `credits.free` |

### 2c. Mismatch log

| Deliverable | What the plan said | What the source does | Found at |
|---|---|---|---|

## 3. Decisions

- **D1 — Follow the template flutter rules as-is.** Clean Architecture (domain/data/presentation per feature), Cubit + Equatable state, get_it + injectable with constructor injection, every user-visible string in an ARB file, no silent failures, pure presentational widgets. Why: user instruction. Rejected: Riverpod/Provider. One deviation, D16.
- **D2 — Theme taken from the dDUT screenshots.** Tokens in `lib/common/theme/app_colors.dart`: login gradient `#0A17A6` → `#1D44F0` → `#0A17A6`; page background `#E7EEF7`; header card and tile text `#3F72B8`; cards white, radius 24, soft shadow; wordmark "d"+"D" white, "U" `#F2E52C`, "T" `#C0261D`; body font = platform default (Roboto on Android). Why: user asked for the dDUT theme; the web `DESIGN.md` applies to `source/frontend` only. Rejected: reusing the web's `#0071a6` palette.
- **D3 — No image assets.** Wordmark is styled text; avatar is an initials circle; today card uses a Material icon instead of the illustration; tile icons are Material outlined icons. Why: no licensed assets; real photo is personal data. Rejected: tracing the logo.
- **D4 — Cookie session over Dio.** `dio` + `cookie_jar` (`PersistCookieJar` in app support dir) + `dio_cookie_manager`; an interceptor adds `x-requested-with: XMLHttpRequest`. Why: the backend is cookie-only (§2a); persisting the cookie keeps the 60-minute session across app restarts. Rejected: `flutter_secure_storage` + manual header (the cookie jar already handles expiry and domain).
- **D5 — Session expiry is an event, not a locator call.** `SessionEvents` singleton (a broadcast stream) is injected into the 401 interceptor and into `SessionCubit`; the router listens to `SessionCubit`. Why: rule §5 forbids `getIt` inside classes.
- **D6 — Backend address in a `.env` file at the repo root, read with `--dart-define-from-file=.env`.** One key, `API_BASE_URL`, holding the full API root including `/api`: `https://ctdt.oguri-lab.io.vn/api` for the deployed backend, `http://10.0.2.2:3000/api` for a local backend from the Android emulator. Switching backend = editing that one line. `.env` is gitignored; `.env.example` is committed. No default in code: a missing value stops the app at startup with a clear message. Cleartext allowed only for `10.0.2.2` and `localhost` via `network_security_config.xml`. Why: user decision 2026-11-01; Flutter 3.38.7 accepts `.env` files in `--dart-define-from-file` (checked with `flutter run -h`), so no package is needed. Rejected: `flutter_dotenv` (bundles the file as an asset and adds a runtime load step); a hard-coded default (would silently hit the wrong backend).
- **D15 — Application ID stays `com.example.dut_curriculum_app`.** Why: user decision 2026-11-01; the demo is not published.
- **D7 — Routing with `go_router`.** `StatefulShellRoute.indexedStack` for Home/Profile tabs; `ShellRoute` around `/curriculum/*` provides one `PortalContextCubit` to all curriculum screens. Redirect: unknown session → splash; none → `/login`; `mustChangePassword` → `/change-password`.
- **D8 — One `portal` feature, not seven.** Mirrors the web `features/student-portal/`; all screens share the context and the same API client. Domain models one per file.
- **D9 — Enum parsing.** Closed sets (course state, eligibility, statuses, material kind, conclusion, enrollment type) parse strictly and throw `ContractException` → shown as an error. Open-ended code lists (eligibility reason/warning codes, graduation warning codes) are not modeled as enums; the server `message` is displayed. Why: no silent fallbacks, and new warning codes do not break the screen.
- **D10 — Code generation.** `json_serializable` for DTOs, `injectable_generator` for DI, `flutter gen-l10n` for strings (D16). No `freezed` (Equatable is enough; fewer generated files).
- **D11 — HTML sections.** `flutter_widget_from_html_core` renders syllabus HTML without a WebView. Rejected: stripping tags (loses lists/tables).
- **D12 — Attachments.** Download with Dio to `getTemporaryDirectory()/<attachmentId>-<fileName>`, then `open_filex`. Rejected: `url_launcher` (the browser has no session cookie).
- **D13 — Packages added with `flutter pub add`.** Versions are whatever is current stable at build time; the executor records the resolved versions in the implement report. Runtime: `flutter_bloc`, `equatable`, `get_it`, `injectable`, `go_router`, `dio`, `cookie_jar`, `dio_cookie_manager`, `path_provider`, `open_filex`, `json_annotation`, `intl`, `flutter_widget_from_html_core`, `flutter_localizations` (sdk). Dev: `build_runner`, `json_serializable`, `injectable_generator`, `bloc_test`, `mocktail`.
- **D16 — Strings through Flutter's built-in `gen-l10n`, not `intl_utils`.** `flutter pub add intl_utils` on 2026-11-01 reported the package as discontinued (`flutter pub outdated`: `intl_utils *2.8.14 (discontinued)`). `gen-l10n` reads the same ARB format and ships with the SDK. Deviation from flutter-rules (which names `intl_utils`); the rule's intent, no hard-coded user text, is unchanged. Rejected: keeping a discontinued generator in a new project.
- **D14 — "Chương trình đào tạo" is the first tile**, before the ten dDUT tiles. Why: it is the demo's subject.

## 4. Deliberate divergences from the web student portal

| Web (`source/frontend/src/features/student-portal/`) | App | Why |
|---|---|---|
| Plain login form | dDUT landing + form sheet | Replica of dDUT |
| Context (program, semester) in the URL | Held in `PortalContextCubit` for the life of the `/curriculum` shell | No URLs on mobile; leaving the block resets it |
| Attachment = browser download | Download to cache + open in system viewer | D12 |
| Results in a paged table | Infinite-scroll list, 50 per page | Phone layout; `MAX_PAGE_SIZE` 100 |
| Course states as AntD tags | Chip with text + colour | Same rule: never colour alone |
| Recognitions table on graduation page (staff view) | Not shown | Web portal page does not show it either; noted for parity |
| Home page cards | Overview screen with a list of the six sub-screens | Mobile navigation |

## 5. Deliverables

Layer groups: **E** enablers, **C** core, **A** auth, **S** shell, **P** portal, **T** tests/docs. Paths are relative to `E:\PBL6\dut_curriculum_app\`.

### E-01 — Project rules and docs skeleton

What/Why: put the template's flutter rules, agents and hooks in the repo so every later step is checked against them.

**Files**
- `.claude/rules/flutter-rules.md` NEW (copy of `E:\claude-code-templates\stacks\flutter\rules\flutter-rules.md`)
- `.claude/agents/{build-verifier,debugger,architecture-reviewer}.md` NEW (copies from `stacks/flutter/agents/`)
- `.claude/hooks/{check-dart-analyze,check-error-handling,check-widget-purity}.sh` NEW (copies; `check-sqflite-migration.sh` skipped — no sqflite)
- `.claude/settings.json` NEW (from `stacks/flutter/settings.addon.json`, sqflite hook entry removed)
- `CLAUDE.md` NEW — stack, rules in effect, "talks to `E:\PBL6\curriculum-management` backend", run commands
- `docs/architecture/{general_architecture,features_architecture}.md`, `docs/technical/technical_reference.md`, `docs/progress/{current_work,todo,progress_log}.md`, `docs/troubleshooting/error_log.md`, `docs/implement-report/` NEW (skeletons)
- `README.md` MODIFY — what the app is, how to run against local/demo backend

**Shape**: copies are byte-for-byte; `CLAUDE.md` ≤ 40 lines.
**Rationale**: mirrors how `E:\PBL6\curriculum-management\.claude\` was set up from the template.
**Gotchas**: hooks are POSIX scripts run by Git Bash; keep LF endings. No git commands (ai-rules Rule 7).
**Verify**: files exist; `.claude/settings.json` parses as JSON.
**Depends on**: —

### E-02 — Dependencies, platform config, codegen config

**Files**
- `pubspec.yaml` MODIFY — description; packages per D13 (already added 2026-11-01, `intl_utils` removed again per D16); `flutter: generate: true`
- `l10n.yaml` NEW — `arb-dir: lib/l10n`, `template-arb-file: app_vi.arb`, `output-localization-file: app_localizations.dart`, `output-class: AppLocalizations`, `nullable-getter: false`
- `analysis_options.yaml` MODIFY — exclude `**/*.g.dart`, `**/*.config.dart`, `lib/generated/**`; enable `prefer_const_constructors`, `avoid_print`
- `build.yaml` NEW — `json_serializable: {options: {field_rename: none, explicit_to_json: true, checked: true}}`
- `android/app/src/main/AndroidManifest.xml` MODIFY — `<uses-permission android:name="android.permission.INTERNET"/>`; `android:label="dDUT CTĐT"`; `android:networkSecurityConfig="@xml/network_security_config"`; `<queries>` intent for `ACTION_VIEW` (open_filex)
- `android/app/src/main/res/xml/network_security_config.xml` NEW — cleartext for `10.0.2.2`, `localhost` and `192.168.1.146` (the user's PC on the LAN, for a real phone) only
- `.env.example` NEW — `API_BASE_URL=https://ctdt.oguri-lab.io.vn/api` plus a commented local line `# API_BASE_URL=http://10.0.2.2:3000/api`
- `.env` NEW (gitignored; a copy of `.env.example`)
- `.gitignore` MODIFY — add `.env`
- `.vscode/launch.json` NEW — `"args": ["--dart-define-from-file=.env"]` so F5 picks up the file
- `lib/main.dart` MODIFY — before `runApp`, if `ApiConfig.baseUrl.isEmpty` throw `StateError('Thiếu API_BASE_URL: chạy với --dart-define-from-file=.env')`
- `ios/Runner/Info.plist` MODIFY — `CFBundleDisplayName` "dDUT CTĐT"; `NSAppTransportSecurity.NSAllowsLocalNetworking = true`

**Shape** (`network_security_config.xml`):
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <domain-config cleartextTrafficPermitted="true">
    <domain includeSubdomains="false">10.0.2.2</domain>
    <domain includeSubdomains="false">localhost</domain>
    <domain includeSubdomains="false">192.168.1.146</domain>
  </domain-config>
</network-security-config>
```
**Gotchas**: the current main manifest has no INTERNET permission (`AndroidManifest.xml:1-45`) — release builds would fail silently without it. Application ID unchanged (D15). Editing `.env` needs a full `flutter run` again, not hot reload: defines are compiled in. Claude's sensitive-file hook blocks shell commands naming `.env`; create `.env` with a file tool or ask the user.
**Verify**: `flutter pub get` succeeds; `flutter analyze` 0 issues; `git status` does not list `.env`.
**Depends on**: —

### C-01 — Theme and design tokens

**Files**: `lib/common/theme/app_colors.dart`, `lib/common/theme/app_dimens.dart`, `lib/common/theme/app_theme.dart` NEW

**Shape**
```dart
abstract final class AppColors {
  static const loginGradientEdge = Color(0xFF0A17A6);
  static const loginGradientCenter = Color(0xFF1D44F0);
  static const pageBackground = Color(0xFFE7EEF7);
  static const brand = Color(0xFF3F72B8);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1F2933);
  static const textSecondary = Color(0xFF6B7280);
  static const wordmarkYellow = Color(0xFFF2E52C);
  static const wordmarkRed = Color(0xFFC0261D);
  static const statePassed = Color(0xFF2E7D32);
  static const stateInProgress = Color(0xFF1565C0);
  static const stateFailed = Color(0xFFC62828);
  static const stateNeutral = Color(0xFF6B7280);
  static const stateWarning = Color(0xFFB26A00);
}
abstract final class AppDimens {
  static const cardRadius = 24.0;
  static const tileRadius = 24.0;
  static const pagePadding = 20.0;
  static const gap = 12.0;
  static const tileAspectRatio = 1.15;
}
ThemeData buildAppTheme(); // ColorScheme.fromSeed(seedColor: AppColors.brand), scaffoldBackgroundColor: pageBackground, card/filled-button/input shapes from AppDimens
```
**Rationale**: values sampled from `design/20261101-163230.jpg` and `design/20261101-163250.jpg` (D2).
**Verify**: `flutter analyze` clean.
**Depends on**: E-02

### C-02 — Localised strings

**Files**: `lib/l10n/app_vi.arb` NEW; `AppLocalizations` generated by `flutter gen-l10n` (D16)

**Shape**: every user-visible string as a key, e.g. `"loginWelcome": "Welcome to digital DUT"`, `"loginButton": "ĐĂNG NHẬP"`, `"loginSubtitle": "Đăng nhập bằng tài khoản hệ thống Quản lý chương trình đào tạo"`, tile labels, `"todayNoSchedule": "Hôm nay không có lịch nào!"`, `"placeholderBody": "Đây là bản mô phỏng ứng dụng dDUT, dùng để trình diễn hệ thống Quản lý CTĐT."`, `"placeholderOpenCurriculum": "Mở Chương trình đào tạo"`, course-state/eligibility/material/conclusion/shortfall labels copied from web `portalLabels.ts` and `graduation/constants/graduationLabels.ts:9-80`, weekday names (`Chủ Nhật`, `Thứ Hai` … `Thứ Bảy`), `"monthLabel": "Tháng {month}"`, `"sessionExpired": "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại."`, `"noStudentLinked": "Tài khoản chưa được liên kết với hồ sơ sinh viên. Liên hệ Phòng Đào tạo."`, `"noProgram": "Chưa xác định được chương trình, liên hệ Phòng Đào tạo."`, `"graduationInfo": "Kết quả tính tại thời điểm xem, chưa phải quyết định công nhận tốt nghiệp."`, `"unsupportedResultVersion": "Chưa hỗ trợ phiên bản kết quả này"`.
**Gotchas**: `MaterialApp` needs `AppLocalizations.localizationsDelegates`, `supportedLocales: AppLocalizations.supportedLocales` and `locale: Locale('vi')`. Placeholders (`{month}`) need an `@key` entry with `placeholders`.
**Verify**: `flutter gen-l10n` succeeds; `AppLocalizations.of(context).loginButton` compiles.
**Depends on**: E-02

### C-03 — API configuration and errors

**Files**: `lib/core/network/api_config.dart`, `lib/core/network/api_paths.dart`, `lib/core/network/api_exception.dart`, `lib/core/network/contract_exception.dart` NEW

**Shape**
```dart
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment('API_BASE_URL'); // full API root, ends in /api (D6)
  static const csrfHeader = 'x-requested-with';
  static const csrfValue = 'XMLHttpRequest';
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);
  static const resultsPageSize = 50;
}
abstract final class ApiPaths {
  static const login = '/auth/login';
  static const logout = '/auth/logout';
  static const me = '/auth/me';
  static const changePassword = '/auth/change-password';
  static const semesters = '/semesters';
  static const portalMe = '/portal/me';
  static const portalCurriculum = '/portal/curriculum';
  static const portalPlos = '/portal/plos';
  static String portalSyllabus(String itemId) => '/portal/curriculum-items/${Uri.encodeComponent(itemId)}/syllabus';
  static String portalAttachment(String itemId, String attachmentId) => '${portalSyllabus(itemId)}/attachments/${Uri.encodeComponent(attachmentId)}/file';
  static String studentResults(String id) => '/students/${Uri.encodeComponent(id)}/results';
  static String studentEligibility(String id) => '/students/${Uri.encodeComponent(id)}/registration-eligibility';
  static String studentGraduation(String id) => '/students/${Uri.encodeComponent(id)}/graduation';
}
class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.code, required this.message});
  final int? statusCode; final String code; final String message;
  bool get isSessionRequired => statusCode == 401;
  bool get isPasswordChangeRequired => code == 'PASSWORD_CHANGE_REQUIRED';
  @override String toString() => message;
}
class ContractException implements Exception { const ContractException(this.message); final String message; @override String toString() => message; }
```
`ApiException.fromDio(DioException)` maps the error body `{statusCode, code, message}` (§2a); network failure → code `NETWORK`, message "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại."
**Verify**: unit test T-01.
**Depends on**: E-02

### C-04 — HTTP client, cookie jar, interceptors

**Files**: `lib/core/network/dio_module.dart` (`@module`), `lib/core/network/csrf_interceptor.dart`, `lib/core/network/session_expiry_interceptor.dart`, `lib/core/session/session_events.dart` NEW

**Shape**
```dart
@module
abstract class NetworkModule {
  @preResolve @singleton
  Future<PersistCookieJar> cookieJar() async {
    final dir = await getApplicationSupportDirectory();
    return PersistCookieJar(storage: FileStorage('${dir.path}/cookies'));
  }
  @singleton
  Dio dio(PersistCookieJar jar, CsrfInterceptor csrf, SessionExpiryInterceptor expiry) =>
      Dio(BaseOptions(baseUrl: ApiConfig.baseUrl, connectTimeout: ApiConfig.connectTimeout, receiveTimeout: ApiConfig.receiveTimeout))
        ..interceptors.addAll([CookieManager(jar), csrf, expiry]);
}
@singleton class SessionEvents { final _expired = StreamController<void>.broadcast(); Stream<void> get expired => _expired.stream; void notifyExpired() => _expired.add(null); }
@injectable class SessionExpiryInterceptor extends Interceptor {
  SessionExpiryInterceptor(this._events); final SessionEvents _events;
  @override void onError(DioException err, ErrorInterceptorHandler handler) {
    final isLogin = err.requestOptions.path == ApiPaths.login;
    if (err.response?.statusCode == 401 && !isLogin) _events.notifyExpired();
    handler.next(err);
  }
}
```
**Gotchas**: a 401 on `/auth/login` is wrong credentials, not expiry — excluded above. `CookieManager` must come before other interceptors. The base URL carries a path (`/api`) and `ApiPaths` start with `/`: T-01 asserts the composed `requestOptions.uri` is `<root>/api/auth/login`, so a join that drops `/api` fails a test instead of returning 404s at runtime.
**Verify**: T-01 interceptor tests.
**Depends on**: C-03

### C-05 — DI entry point

**Files**: `lib/core/di/getit_utils.dart` NEW; `lib/core/di/getit_utils.config.dart` generated

**Shape**
```dart
final getIt = GetIt.instance;
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```
**Rationale**: flutter-rules §5 single registration entry point.
**Verify**: `dart run build_runner build --force-jit` succeeds.
**Depends on**: C-04

### C-06 — Shared widgets and formatting

**Files**: `lib/common/widgets/{app_card,error_panel,loading_skeleton,status_chip,section_header,empty_panel}.dart`, `lib/common/utils/{decimal_format,date_format,file_size_format}.dart`, `lib/common/extensions/date_parsing.dart` NEW

**Shape**
```dart
class StatusChip extends StatelessWidget { const StatusChip({super.key, required this.label, required this.color}); final String label; final Color color; /* tinted background, coloured text, label always visible */ }
class ErrorPanel extends StatelessWidget { const ErrorPanel({super.key, required this.message, this.onRetry}); final String message; final VoidCallback? onRetry; }
class LoadingSkeleton extends StatelessWidget { const LoadingSkeleton({super.key, this.lines = 4}); final int lines; }
String formatDecimal(String value) => value.replaceAll('.', ',');
int parseDateOnly(String iso) => DateTime.parse('${iso}T00:00:00Z').millisecondsSinceEpoch; // edge helper
```
**Gotchas**: `DateTime` only inside helpers (rule §9).
**Verify**: analyze clean; widget test in T-03 uses `StatusChip`.
**Depends on**: C-01, C-02

### A-01 — Auth domain

**Files**: `lib/features/auth/domain/model/session_user.dart`, `lib/features/auth/domain/repository/auth_repository.dart`, `lib/features/auth/domain/use_case/auth_use_cases.dart` NEW

**Shape**
```dart
class SessionUser extends Equatable {
  const SessionUser({required this.id, required this.username, required this.userCode, required this.fullName, required this.email, required this.mustChangePassword, required this.roleNames});
  final String id, username, userCode, fullName; final String? email; final bool mustChangePassword; final List<String> roleNames;
  @override List<Object?> get props => [id, username, userCode, fullName, email, mustChangePassword, roleNames];
}
abstract class AuthRepository {
  Future<SessionUser> login(String username, String password);
  Future<SessionUser?> currentUser(); // null on 401
  Future<void> logout();
  Future<void> changePassword(String currentPassword, String newPassword);
}
@injectable class AuthUseCases { AuthUseCases(this._repo); final AuthRepository _repo; /* login, currentUser, logout, changePassword pass-throughs */ }
```
**Verify**: analyze clean.
**Depends on**: C-05

### A-02 — Auth data

**Files**: `lib/features/auth/data/remote/auth_api.dart`, `lib/features/auth/data/remote/dto/{me_dto,me_role_dto,login_request_dto,change_password_request_dto}.dart`, `lib/features/auth/data/auth_repository_impl.dart` NEW

**Shape**: `@JsonSerializable()` DTOs per §2b `MeDto` (unmodeled fields omitted from the DTO); `MeDto.toDomain()`. `@Singleton(as: AuthRepository) class AuthRepositoryImpl` with `AuthApi` + `PersistCookieJar`; `logout()` calls the endpoint then `jar.deleteAll()` even if the call fails (error still rethrown). `currentUser()` returns null only for `ApiException.isSessionRequired`.
**Gotchas**: `change-password` returns 204 with no body — do not parse. `/auth/me` is allowed while password change is pending, so it is the bootstrap call.
**Verify**: T-01 DTO tests with synthetic JSON.
**Depends on**: A-01

### A-03 — Session cubit

**Files**: `lib/features/auth/presentation/session/{session_cubit,session_state}.dart` NEW

**Shape**
```dart
enum SessionStatus { unknown, unauthenticated, authenticated }
class SessionState extends Equatable { const SessionState({this.status = SessionStatus.unknown, this.user, this.notice}); final SessionStatus status; final SessionUser? user; final String? notice; /* copyWith, props */ }
@singleton class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._auth, this._events) : super(const SessionState()) { _sub = _events.expired.listen((_) => _expire()); }
  Future<void> restore();            // currentUser → authenticated / unauthenticated; error → unauthenticated + notice=e.toString()
  void signedIn(SessionUser user);
  void passwordChanged();            // user.copy(mustChangePassword: false)
  Future<void> logout();             // errors surface in notice, state still unauthenticated
  void _expire();                    // unauthenticated + notice = `sessionExpired` ARB key
}
```
**Gotchas**: `notice` carries a string key resolved in the UI, not a localized string (no `BuildContext` in cubits). Singleton because the router listens to it.
**Verify**: T-02 bloc tests.
**Depends on**: A-02, C-04

### A-04 — Router

**Files**: `lib/common/routes/route_paths.dart`, `lib/common/routes/app_router.dart`, `lib/common/routes/go_router_refresh_stream.dart` NEW

**Shape**
```dart
abstract final class RoutePaths {
  static const splash = '/'; static const login = '/login'; static const changePassword = '/change-password';
  static const home = '/home'; static const profile = '/profile'; static const placeholder = '/placeholder/:tile';
  static const curriculum = '/curriculum'; static const curriculumProgram = '/curriculum/program';
  static const syllabus = '/curriculum/program/syllabus/:itemId'; static const plos = '/curriculum/plos';
  static const progress = '/curriculum/progress'; static const registration = '/curriculum/registration';
  static const graduation = '/curriculum/graduation';
}
GoRouter buildRouter(SessionCubit session); // refreshListenable: GoRouterRefreshStream(session.stream); redirect per D7
```
Routes: `StatefulShellRoute.indexedStack` (branches `home`, `profile`) built by `MainShell`; `ShellRoute` for `/curriculum/**` whose builder wraps child in `BlocProvider(create: (_) => getIt<PortalContextCubit>()..load())`.
**Gotchas**: `getIt` allowed here (composition root, rule §5). Redirect must not loop: `unknown` → splash only.
**Verify**: T-03 widget test: unauthenticated lands on login; authenticated on home.
**Depends on**: A-03

### A-05 — Login landing and form

**Files**: `lib/features/auth/presentation/login/{login_cubit,login_state,login_screen}.dart`, `lib/features/auth/presentation/components/{ddut_wordmark,login_form_sheet,login_background}.dart` NEW

**Shape**: `LoginScreen` = full-bleed `LoginBackground` (vertical gradient per D2 + `CustomPaint` faint hexagon/node lines in the lower third, white 8 % opacity), `DdutWordmark` (Text spans d/D white, U yellow, T red, bold rounded font weight 900, size 96), title `loginWelcome`, subtitle, white rounded button `loginButton` → `showModalBottomSheet(LoginFormSheet)`. `LoginFormSheet` (pure): username + password fields, show/hide toggle, submit button, error text from state; callbacks `onSubmit(String, String)`. `LoginCubit` (`@injectable`): `submit` → `isSubmitting`, success → `SessionCubit.signedIn` via `BlocListener` in screen (cubit emits `user`), failure → `errorMessage = e.toString()` (server message, e.g. "Tên đăng nhập hoặc mật khẩu không đúng.").
**Rationale**: `design/20261101-163230.jpg`.
**Gotchas**: client-side only checks non-empty; the server owns the rules. `notice` from `SessionCubit` (expiry) shown as SnackBar on landing.
**Verify**: manual — login with `demo.sinhvien`/`demo` reaches Home; wrong password shows the server message.
**Depends on**: A-04, C-06

### A-06 — Change password

**Files**: `lib/features/auth/presentation/change_password/{change_password_cubit,change_password_state,change_password_screen}.dart`, `lib/features/auth/domain/model/password_policy.dart` NEW

**Shape**: three fields (current, new, confirm). `PasswordPolicy` constants `minLength = 8`, `maxLength = 128`, `RegExp(r'^(?=.*\p{L})(?=.*\d).+$', unicode: true)` mirror `password-policy.ts:1-3`. Success → `SessionCubit.passwordChanged()` and pop / go home. Forced mode (from redirect) hides the back button and shows "Bạn cần đổi mật khẩu trước khi tiếp tục."
**Verify**: T-02 cubit test (mismatch confirm → error, server 400 → message).
**Depends on**: A-05

### S-01 — Shell, bottom navigation

**Files**: `lib/features/shell/presentation/main_shell.dart`, `lib/features/shell/presentation/components/bottom_nav_bar.dart` NEW

**Shape**: floating white rounded bar (radius 32, margin 20) with two icons (`Icons.home_outlined`, `Icons.person_outline`), active indicator line above the icon in `AppColors.brand` — matches `20261101-163250.jpg`. Pure widget: `currentIndex`, `onTap`.
**Verify**: switching tabs keeps scroll position (indexedStack).
**Depends on**: A-04

### S-02 — Home tiles model

**Files**: `lib/features/shell/domain/model/home_tile.dart` NEW

**Shape**
```dart
enum HomeTile { curriculum, timetable, academicResults, academicAffairs, homeroomClass, tuition, creditRegistration, communityActivities, assistant, feedback, serviceQueue }
// label key, IconData and destination are resolved in presentation via an extension in
// lib/features/shell/presentation/components/home_tile_presentation.dart (Material outlined icons)
```
Order per D14: curriculum first, then the dDUT order: Thời khóa biểu, Kết quả học tập, Học vụ, Lớp sinh hoạt, Học phí, Đăng ký tín chỉ, Hoạt động cộng đồng, Trợ lý dDUT, Góp ý, Lấy số tổ 1 cửa.
**Gotchas**: domain stays Flutter-free (no `IconData` in domain).
**Depends on**: —

### S-03 — Home screen

**Files**: `lib/features/shell/presentation/home/home_screen.dart`, `lib/features/shell/presentation/components/{profile_header_card,today_card,feature_tile,feature_tile_grid,initials_avatar,home_tile_presentation}.dart` NEW

**Shape**: `HomeScreen` reads `SessionCubit` user. `ProfileHeaderCard(fullName, subtitle: email ?? username, onBellTap)` blue card radius 24, initials avatar with white ring, bell icon → placeholder. `TodayCard(nowMs)` left column weekday (bold), "Tháng {m}", day two-digit large in brand blue, divider, right side `Icons.event_note_outlined` size 96 in brand + `todayNoSchedule`. `FeatureTileGrid` 2 columns, `FeatureTile(icon, label, onTap)` white card radius 24, icon 40 brand, label brand 18 semibold centered.
**Rationale**: `design/20261101-163250.jpg`.
**Gotchas**: `TodayCard` takes the epoch-ms value from the screen (clock read at the edge), formatting via `date_format.dart`. No real photo.
**Verify**: T-03 golden-free widget test: 11 tiles, first is "Chương trình đào tạo".
**Depends on**: S-01, S-02, C-06

### S-04 — Profile tab

**Files**: `lib/features/shell/presentation/profile/profile_screen.dart`, `lib/features/shell/presentation/components/profile_info_card.dart` NEW

**Shape**: header card (same as home), info card rows: Họ tên, Tên đăng nhập, Mã, Email, Vai trò (joined `roleNames`); buttons "Đổi mật khẩu" → `/change-password`, "Đăng xuất" (outlined, confirm dialog) → `SessionCubit.logout()`.
**Verify**: manual — logout returns to landing; relaunch stays logged out.
**Depends on**: S-03, A-06

### S-05 — Placeholder page

**Files**: `lib/features/shell/presentation/placeholder/placeholder_screen.dart` NEW

**Shape**: `PlaceholderScreen(tile: HomeTile)` AppBar title = tile label; centred card: `Icons.construction_outlined`, `placeholderBody`, filled button `placeholderOpenCurriculum` → `context.go(RoutePaths.curriculum)`. Route param `tile` = `HomeTile.name`; unknown name → `ErrorPanel`.
**Verify**: each non-curriculum tile and the bell open it.
**Depends on**: S-03

### P-01 — Portal domain models

**Files** (one class per file) `lib/features/portal/domain/model/`: `semester.dart`, `portal_student.dart`, `student_status.dart`, `portal_program.dart`, `enrollment_type.dart`, `portal_overview.dart` (student?, semester?, programs), `portal_context.dart` (studentId, programId, semesterId), `curriculum.dart`, `curriculum_term.dart`, `curriculum_course.dart`, `course_state.dart`, `plo.dart`, `syllabus.dart`, `syllabus_clo.dart`, `syllabus_week.dart`, `syllabus_assessment.dart`, `syllabus_attachment.dart`, `material_kind.dart`, `course_ref.dart`, `academic_result.dart`, `result_status.dart`, `result_page.dart`, `eligibility_report.dart`, `eligibility_item.dart`, `eligibility.dart`, `catalog_status.dart`, `eligibility_warning.dart`, `graduation_outcome.dart` (sealed: `GraduationReviewed`, `GraduationCannotAudit`, `GraduationUnsupported`), `graduation_result.dart`, `graduation_conclusion.dart`, `graduation_credits.dart`, `graduation_shortfall.dart`, `shortfall_category.dart`, `graduation_warning.dart`, `elective_group_progress.dart`, `knowledge_block_progress.dart` NEW

**Shape**: Equatable classes with exactly the "Modeled as" columns of §2b; enums with a `static X parse(String wire)` that throws `ContractException('Giá trị $wire không hợp lệ cho …')` (D9).
```dart
enum CourseState { passed, passedEquivalent, inProgress, failed, notTaken;
  static CourseState parse(String wire) => switch (wire) {
    'PASSED' => passed, 'PASSED_EQUIVALENT' => passedEquivalent, 'IN_PROGRESS' => inProgress,
    'FAILED' => failed, 'NOT_TAKEN' => notTaken, _ => throw ContractException('Trạng thái học phần không hợp lệ: $wire') };
}
```
**Gotchas**: `ContractException` lives in `core/network` but domain must stay Flutter-free — it is pure Dart, so importing core is fine; no `package:flutter` in domain.
**Verify**: T-01 parse tests for every enum, including an unknown value.
**Depends on**: C-03

### P-02 — Portal repository interface and use cases

**Files**: `lib/features/portal/domain/repository/portal_repository.dart`, `lib/features/portal/domain/use_case/portal_use_cases.dart` NEW

**Shape**
```dart
abstract class PortalRepository {
  Future<List<Semester>> startedSemesters();                  // startDate != null, sorted by startDate desc
  Future<PortalOverview> overview({String? semesterId});
  Future<Curriculum> curriculum(PortalContext context);
  Future<List<Plo>> plos(PortalContext context);
  Future<Syllabus> syllabus(PortalContext context, String itemId);
  Future<String> downloadAttachment(PortalContext context, String itemId, SyllabusAttachment attachment); // local path
  Future<ResultPage> results(PortalContext context, {required int page});
  Future<EligibilityReport> eligibility(PortalContext context);
  Future<GraduationOutcome> graduation(PortalContext context);
}
@injectable class PortalUseCases { /* one method per repository call; aggregator per rule §4 */ }
```
**Depends on**: P-01

### P-03 — Portal data layer

**Files**: `lib/features/portal/data/remote/portal_api.dart`, `lib/features/portal/data/remote/dto/*.dart` (one DTO per wire class in §2b: `semester_dto`, `portal_me_dto`, `portal_student_dto`, `portal_program_dto`, `portal_semester_dto`, `portal_curriculum_dto`, `portal_term_dto`, `portal_course_dto`, `portal_plo_dto`, `portal_syllabus_dto`, `portal_clo_dto`, `portal_week_dto`, `portal_assessment_dto`, `portal_attachment_dto`, `course_ref_dto`, `academic_result_dto`, `academic_result_page_dto`, `registration_eligibility_dto`, `eligibility_item_dto`, `eligibility_reason_dto`, `eligibility_warning_dto`, `graduation_outcome_dto`, `graduation_result_dto`, `graduation_context_dto`, `graduation_shortfall_dto`, `graduation_warning_dto`, `graduation_credits_dto`, `graduation_group_progress_dto`, `graduation_block_progress_dto`, `graduation_diagnostic_dto`), `lib/features/portal/data/portal_repository_impl.dart` NEW

**Shape**: `PortalApi` (`@singleton`, takes `Dio`) — one method per endpoint, query params `programId`/`semesterId` from `PortalContext`; results with `page` and `pageSize: ApiConfig.resultsPageSize`; attachment via `dio.download(path, savePath, queryParameters: …)` to `getTemporaryDirectory()`. DTOs use `@JsonSerializable()` with only modeled fields; each has `toDomain()`. `GraduationShortfallDto` is one class with all optional variant fields + `code`, `category`, `message`, mapping `title` from the code label key. `GraduationOutcomeDto.toDomain()` → `GraduationUnsupported` when `result.schemaVersion != 1`; `RegistrationEligibilityDto` with `contractVersion != 1` → `ContractException(unsupported)`. Every Dio error converted with `ApiException.fromDio`.
**Gotchas**: decimal fields are strings — type them `String`, never `double`. `checked: true` in `build.yaml` turns a missing/mistyped field into a readable `CheckedFromJsonException`; map it to `ContractException`. Eligibility `items` with `completed == true` are kept in data; filtering is presentation (web rule).
**Verify**: `build_runner` succeeds; T-01 parses one synthetic JSON fixture per endpoint (fixtures written by hand from §2b, **no copied production data**).
**Depends on**: P-02, C-04

### P-04 — Portal context cubit

**Files**: `lib/features/portal/presentation/context/{portal_context_cubit,portal_context_state}.dart` NEW

**Shape**
```dart
class PortalContextState extends Equatable {
  const PortalContextState({this.isLoading = true, this.semesters = const [], this.overview, this.selectedProgramId, this.errorMessage});
  final bool isLoading; final List<Semester> semesters; final PortalOverview? overview; final String? selectedProgramId; final String? errorMessage;
  PortalContext? get context; // null when student, semester or program missing
  PortalProgram? get selectedProgram;
}
@injectable class PortalContextCubit extends Cubit<PortalContextState> {
  Future<void> load();                         // semesters + overview(default semester); program = programs.first
  Future<void> selectSemester(String id);      // overview(semesterId) ; program reset to first (web rule)
  void selectProgram(String programId);
}
```
**Gotchas**: two calls in `load` — if semesters fails, still surface the error (no partial silent state).
**Verify**: T-02: semester change resets program; null student keeps `context == null`.
**Depends on**: P-03

### P-05 — Curriculum overview screen

**Files**: `lib/features/portal/presentation/overview/portal_overview_screen.dart`, `lib/features/portal/presentation/components/{student_summary_card,program_switch,semester_picker,portal_menu_list,no_context_panel}.dart` NEW

**Shape**: AppBar "Chương trình đào tạo". `StudentSummaryCard` (name, code, cohort, major, status chip). `SemesterPicker` (dropdown of started semesters, label "Học kỳ xem"). `ProgramSwitch` — `SegmentedButton` when 2 programs (labels "Ngành chính"/"Ngành thứ hai"), otherwise a read-only line; under it program name, code, version `versionNumber ?? 'Chưa có'`, decision `decisionNumber ?? 'Chưa có số quyết định'`. `PortalMenuList`: Chương trình của tôi, Chuẩn đầu ra (PLO), Tiến độ và kết quả, Đăng ký học phần, Xét tốt nghiệp. `NoContextPanel` for no student (`noStudentLinked`) or no program (`noProgram`).
**Verify**: manual with `demo.sinhvien`; staff `demo` shows `noStudentLinked`.
**Depends on**: P-04, C-06

### P-06 — My curriculum screen

**Files**: `lib/features/portal/presentation/curriculum/{curriculum_cubit,curriculum_state,curriculum_screen}.dart`, `lib/features/portal/presentation/components/{term_section,course_row,course_state_chip}.dart` NEW

**Shape**: `CurriculumCubit(@factoryParam PortalContext)` → `load()`. Screen: summary line (program, version, total credits), filter chips by state (Tất cả / Đã đạt / Đang học / Chưa đạt / Chưa học — client-side), `ExpansionTile` per term "Học kỳ {n} · {credits} TC" (current/next term expanded), `CourseRow` code, name, credits, "Tự chọn · {groupName}" when elective, `CourseStateChip`, score `score10 / letterGrade` when present, "Học {attemptCount} lần" when > 1; tap → syllabus when `hasSyllabus`, else trailing "Chưa có đề cương".
**Verify**: T-02 cubit; manual states match web for the same account.
**Depends on**: P-05

### P-07 — Syllabus screen and attachments

**Files**: `lib/features/portal/presentation/syllabus/{syllabus_cubit,syllabus_state,syllabus_screen}.dart`, `lib/features/portal/presentation/components/{html_section,clo_list,week_list,assessment_table,attachment_tile}.dart` NEW

**Shape**: header (code, name, credits, "Lần sửa {n}", published date). Sections in web order: Mô tả học phần, Mục tiêu, CLO, Phương pháp giảng dạy, Kế hoạch theo tuần, Đánh giá (table: component, form, weight %), Phương pháp đánh giá, Tài liệu tham khảo, Tài liệu đính kèm. `AttachmentTile` (kind label, name, size, download progress state). Cubit `openAttachment(attachment)` → `downloadAttachment` → `OpenFilex.open(path)`; non-`done` result → `errorMessage = result.message`.
**Gotchas**: 404 `PORTAL_SYLLABUS_NOT_ISSUED` shows the server message in `ErrorPanel`, not a generic error. HTML via `HtmlWidget` (D11).
**Verify**: manual — open a PDF attachment on the emulator.
**Depends on**: P-06

### P-08 — PLO screen

**Files**: `lib/features/portal/presentation/plos/{plos_cubit,plos_state,plos_screen}.dart` NEW

**Shape**: list grouped by `competencyGroup` (null → "Khác"), each `code` bold + `description`. Empty → `EmptyPanel("Chương trình chưa có PLO.")`.
**Depends on**: P-05

### P-09 — Progress and results screen

**Files**: `lib/features/portal/presentation/progress/{progress_cubit,progress_state,progress_screen}.dart`, `lib/features/portal/presentation/components/{credit_progress_card,result_row}.dart` NEW

**Shape**: `ProgressCubit` loads graduation outcome and results page 1 in parallel (`Future.wait`, each error kept separately so one failing does not hide the other); `loadMore()` until `items.length == total`. `CreditProgressCard`: when `GraduationReviewed` → `LinearProgressIndicator(recognized/required)`, "{recognized}/{required} tín chỉ", rows bắt buộc/tự chọn/tự do; when `CannotAudit` → warning panel with server message (web `PortalProgressPage.tsx`). Results list: semester code, course code + name, score10, score4, letter, status chip.
**Depends on**: P-05

### P-10 — Registration eligibility screen

**Files**: `lib/features/portal/presentation/registration/{registration_cubit,registration_state,registration_screen}.dart`, `lib/features/portal/presentation/components/{eligibility_item_card,eligibility_chip}.dart` NEW

**Shape**: header "Học kỳ {semesterCode}", evaluated time. Open items = `!completed`; two sections "Có thể đăng ký" (`eligibility != INELIGIBLE`) and "Chưa đăng ký được" (`INELIGIBLE`) — web `PortalRegistrationPage.tsx:69-70`. `EligibilityItemCard`: code, name, credits, "HK {plannedSemester}", eligibility chip, catalog status tag when not ACTIVE, `statusText`, reasons as bullets (`message`), "Phải học cùng: …" from `requiredConcurrentCourses`. Warnings in a panel at the top.
**Depends on**: P-05

### P-11 — Graduation screen

**Files**: `lib/features/portal/presentation/graduation/{graduation_cubit,graduation_state,graduation_screen}.dart`, `lib/features/portal/presentation/components/{conclusion_banner,shortfall_group,elective_group_row,knowledge_block_row}.dart` NEW

**Shape**: info banner `graduationInfo`; `ConclusionBanner` (chip + context lines: program, cohort, semester, version, evaluated time); credits rows "Tổng tín chỉ yêu cầu / công nhận / còn thiếu"; shortfalls grouped in the four categories in web order (`GraduationShortfalls.tsx:11-14`), each item title from code label + server message; warnings; elective groups ("Không quy định" for null); knowledge blocks under "Tham khảo, không phải điều kiện xét riêng". `CannotAudit` → `ErrorPanel(message)`; `Unsupported` → `unsupportedResultVersion`.
**Depends on**: P-05

### T-01 — Unit tests: network, DTOs, enums

**Files**: `test/core/network/api_exception_test.dart`, `test/core/network/interceptors_test.dart`, `test/features/auth/data/me_dto_test.dart`, `test/features/portal/data/*_dto_test.dart`, `test/features/portal/domain/enum_parse_test.dart`, `test/fixtures/*.json` NEW

**Shape**: hand-written synthetic fixtures per §2b (codes like `SYN101`, names like "Học phần mẫu"); one test per endpoint fixture; unknown enum → `ContractException`; graduation `CANNOT_AUDIT` and `schemaVersion: 2` paths; 401 on `/auth/login` does not fire `SessionEvents`.
**Verify**: `flutter test` green.
**Depends on**: P-03, A-02

### T-02 — Cubit tests

**Files**: `test/features/auth/presentation/{session_cubit,login_cubit,change_password_cubit}_test.dart`, `test/features/portal/presentation/{portal_context_cubit,curriculum_cubit,syllabus_cubit,progress_cubit,registration_cubit,graduation_cubit}_test.dart` NEW

**Shape**: `bloc_test` + `mocktail` mocks of use-case aggregators; for every cubit both success and failure paths (rule §13: error message equals the thrown message).
**Depends on**: P-11, A-06

### T-03 — Widget tests

**Files**: `test/features/shell/home_screen_test.dart`, `test/features/auth/login_screen_test.dart`, `test/common/routes/app_router_test.dart` NEW

**Shape**: pump with `AppLocalizations.localizationsDelegates`; home shows 11 tiles with "Chương trình đào tạo" first; login button opens the sheet; router redirect cases.
**Depends on**: S-05, A-05

### T-04 — Docs and implement report

**Files**: `docs/architecture/*.md`, `docs/technical/technical_reference.md`, `docs/progress/*.md` MODIFY; `docs/implement-report/f-28-ddut-replica-curriculum-app-implement-report.md` NEW (appended as each deliverable lands, ai-rules Rule 14); this plan's Status line MODIFY.
**Depends on**: every deliverable

## 6. Sequencing

```
E-01 ─┐
E-02 ─┼─ C-01 ─ C-02 ─ C-06 ─┐
      └─ C-03 ─ C-04 ─ C-05 ─┼─ A-01 ─ A-02 ─ A-03 ─ A-04 ─ A-05 ─ A-06
                             │                         │
                             │                         └─ S-01 ─ S-02 ─ S-03 ─ S-04 ─ S-05   ◆ pause 1
                             └─ P-01 ─ P-02 ─ P-03 ─ P-04 ─ P-05 ─ P-06 ─ P-07                ◆ pause 2
                                                              └─ P-08, P-09, P-10, P-11       ◆ pause 3
                                                                   └─ T-01 ─ T-02 ─ T-03 ─ T-04
```

Build order: E-01, E-02, C-01..C-06, A-01..A-06, S-01..S-05, **pause 1** (login + shell + placeholders demoable on emulator against local backend), P-01..P-07, **pause 2** (overview, curriculum, syllabus demoable), P-08..P-11, **pause 3** (full parity), T-01..T-04. Codegen runs (`dart run build_runner build --force-jit`, `flutter gen-l10n`) after C-02, C-05, A-02, P-03 and before each pause.

Backend prerequisite: companion plan S-01/S-02 (demo student) before pause 1's manual login check.

## 7. Verification strategy

- Build gate after each group: `flutter analyze` (0 issues), `flutter test`.
- Unit: T-01 (contracts), T-02 (every cubit, success + failure). Widget: T-03.
- Manual on Android emulator, backend local (`pnpm start:dev` in `source/backend`, `ctdt_real`, demo student seeded): `.env` set to `API_BASE_URL=http://10.0.2.2:3000/api`, then `flutter run --dart-define-from-file=.env`. Walk: login → home → each placeholder → curriculum overview → switch semester → my curriculum → syllabus + open attachment → PLO → progress → registration → graduation → profile → change password → logout. Compare each portal screen with the web portal for the same account.
- Deployed backend: `.env` set to `API_BASE_URL=https://ctdt.oguri-lab.io.vn/api` (the `.env.example` value), after the user seeds the demo student there.
- iOS: `flutter build ios --no-codesign` not available on Windows — recorded as unverified.

## 8. Risks and open items

| Risk | Impact | Mitigation |
|---|---|---|
| Graduation `CANNOT_AUDIT` for the demo program (Faculty input C4 missing) | Progress/graduation show a diagnostic, not numbers | Same as web; choose another program via the seed's env |
| Session idles out after 60 minutes | Mid-demo redirect to login | Expiry notice; cookie persisted so relaunch within the window stays logged in |
| Package APIs differ from the shapes above (versions not pinned, D13) | Build friction | Executor adapts to the resolved version and logs a Deviation in the implement report |
| `gen-l10n` and `json_serializable`/`injectable` both generate code | Stale generated files | Codegen as explicit steps (§6) |
| Codex execution outside the curriculum-management workspace may need permission for `E:\PBL6\dut_curriculum_app` | Run blocked | Grant the folder when prompted; no git writes in either repo |
| iOS untested | iOS build may fail | Config written; flagged in README |
| Demo site lacks the demo student | Login fails on the public build | User runs `pnpm db:demo-student` on the VM |
