import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/model/course_state.dart';
import '../../domain/model/portal_context.dart';
import '../../domain/use_case/portal_use_cases.dart';
import 'curriculum_state.dart';

@injectable
class CurriculumCubit extends Cubit<CurriculumState> {
  CurriculumCubit(this._portal, @factoryParam this.context)
    : super(const CurriculumState());

  final PortalUseCases _portal;
  final PortalContext context;
  int _revision = 0;

  Future<void> load() async {
    final revision = ++_revision;
    emit(const CurriculumState());
    try {
      final data = await _portal.curriculum(context);
      if (!isClosed && revision == _revision) {
        emit(CurriculumState(isLoading: false, data: data));
      }
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(CurriculumState(isLoading: false, errorMessage: error.toString()));
      }
    }
  }

  Future<void> loadEquivalentCourses({bool force = false}) async {
    if (state.data == null ||
        state.isLoadingEquivalent ||
        (state.equivalentLoaded && !force))
      return;
    final revision = _revision;
    emit(state.copyWith(isLoadingEquivalent: true, clearEquivalentError: true));
    try {
      final report = await _portal.eligibility(context);
      if (isClosed || revision != _revision) return;
      final equivalentIds = {
        for (final term in state.data!.terms)
          for (final course in term.courses)
            if (course.state == CourseState.passedEquivalent) course.itemId,
      };
      emit(
        state.copyWith(
          isLoadingEquivalent: false,
          equivalentLoaded: true,
          equivalentCourses: Map.unmodifiable({
            for (final item in report.items)
              if (equivalentIds.contains(item.itemId))
                if (item.equivalentCourse case final source?)
                  item.itemId: source,
          }),
        ),
      );
    } catch (error) {
      if (isClosed || revision != _revision) return;
      emit(
        state.copyWith(
          isLoadingEquivalent: false,
          equivalentError: error.toString(),
        ),
      );
    }
  }

  void setFilter(CourseState? filter) =>
      emit(state.copyWith(filter: filter, clearFilter: filter == null));
}
