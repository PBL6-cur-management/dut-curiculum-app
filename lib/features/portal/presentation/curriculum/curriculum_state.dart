import 'package:equatable/equatable.dart';

import '../../domain/model/course_state.dart';
import '../../domain/model/course_ref.dart';
import '../../domain/model/curriculum.dart';
import '../../domain/model/curriculum_course.dart';
import '../../domain/model/curriculum_term.dart';

class CurriculumState extends Equatable {
  const CurriculumState({
    this.isLoading = true,
    this.data,
    this.filter,
    this.errorMessage,
    this.equivalentCourses = const {},
    this.equivalentLoaded = false,
    this.isLoadingEquivalent = false,
    this.equivalentError,
  });

  final bool isLoading;
  final Curriculum? data;
  final CourseState? filter;
  final String? errorMessage;
  final Map<String, CourseRef> equivalentCourses;
  final bool equivalentLoaded;
  final bool isLoadingEquivalent;
  final String? equivalentError;

  CurriculumState copyWith({
    bool? isLoading,
    Curriculum? data,
    CourseState? filter,
    String? errorMessage,
    bool clearFilter = false,
    bool clearError = false,
    Map<String, CourseRef>? equivalentCourses,
    bool? equivalentLoaded,
    bool? isLoadingEquivalent,
    String? equivalentError,
    bool clearEquivalentError = false,
  }) => CurriculumState(
    isLoading: isLoading ?? this.isLoading,
    data: data ?? this.data,
    filter: clearFilter ? null : filter ?? this.filter,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    equivalentCourses: equivalentCourses ?? this.equivalentCourses,
    equivalentLoaded: equivalentLoaded ?? this.equivalentLoaded,
    isLoadingEquivalent: isLoadingEquivalent ?? this.isLoadingEquivalent,
    equivalentError: clearEquivalentError
        ? null
        : equivalentError ?? this.equivalentError,
  );

  List<CurriculumTerm> get terms => [
    for (final term in data?.terms ?? const <CurriculumTerm>[])
      if (filter == null || term.courses.any(_matches))
        CurriculumTerm(
          plannedSemester: term.plannedSemester,
          credits: term.credits,
          courses: List.unmodifiable(term.courses.where(_matches)),
        ),
  ];

  bool _matches(CurriculumCourse course) => _inState(course, filter);

  static bool _inState(CurriculumCourse course, CourseState? state) =>
      state == null ||
      course.state == state ||
      (state == CourseState.passed &&
          course.state == CourseState.passedEquivalent);

  Iterable<CurriculumCourse> get _allCourses => [
    for (final term in data?.terms ?? const <CurriculumTerm>[]) ...term.courses,
  ];

  int countFor(CourseState? state) =>
      _allCourses.where((course) => _inState(course, state)).length;

  double get earnedCredits => _allCourses
      .where((course) => _inState(course, CourseState.passed))
      .fold(0, (sum, course) => sum + (double.tryParse(course.credits) ?? 0));

  Set<int> get expandedTerms {
    final all = data?.terms ?? const <CurriculumTerm>[];
    final current = all
        .where(
          (term) => term.courses.any(
            (course) => course.state == CourseState.inProgress,
          ),
        )
        .map((term) => term.plannedSemester)
        .toSet();
    final candidates = all.where(
      (term) =>
          current.isEmpty ||
          term.plannedSemester >
              current.reduce((left, right) => left > right ? left : right),
    );
    final next = candidates
        .where(
          (term) => term.courses.any(
            (course) => course.state == CourseState.notTaken,
          ),
        )
        .firstOrNull;
    return {...current, if (next != null) next.plannedSemester};
  }

  @override
  List<Object?> get props => [
    isLoading,
    data,
    filter,
    errorMessage,
    equivalentCourses,
    equivalentLoaded,
    isLoadingEquivalent,
    equivalentError,
  ];
}
