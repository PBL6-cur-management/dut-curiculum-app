import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/model/portal_overview.dart';
import '../../domain/model/semester.dart';
import '../../domain/use_case/portal_use_cases.dart';
import 'portal_context_state.dart';

@injectable
class PortalContextCubit extends Cubit<PortalContextState> {
  PortalContextCubit(this._portal) : super(const PortalContextState());

  final PortalUseCases _portal;
  int _revision = 0;

  Future<void> load() async {
    final revision = ++_revision;
    emit(const PortalContextState());
    try {
      final values = await Future.wait<Object>([
        _portal.startedSemesters(),
        _portal.overview(),
      ]);
      if (isClosed || revision != _revision) {
        return;
      }
      _loaded(values[0] as List<Semester>, values[1] as PortalOverview);
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(
          PortalContextState(isLoading: false, errorMessage: error.toString()),
        );
      }
    }
  }

  Future<void> selectSemester(String id) async {
    final revision = ++_revision;
    final semesters = state.semesters;
    emit(PortalContextState(semesters: semesters));
    try {
      final overview = await _portal.overview(semesterId: id);
      if (!isClosed && revision == _revision) {
        _loaded(semesters, overview);
      }
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(
          PortalContextState(
            isLoading: false,
            semesters: semesters,
            errorMessage: error.toString(),
          ),
        );
      }
    }
  }

  void selectProgram(String id) {
    final programs = state.overview?.programs;
    if (state.isLoading || programs == null) {
      return;
    }
    try {
      programs.firstWhere((program) => program.programId == id);
      emit(
        PortalContextState(
          isLoading: false,
          semesters: state.semesters,
          overview: state.overview,
          selectedProgramId: id,
        ),
      );
    } catch (error) {
      emit(
        PortalContextState(
          isLoading: false,
          semesters: state.semesters,
          overview: state.overview,
          selectedProgramId: state.selectedProgramId,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _loaded(List<Semester> semesters, PortalOverview overview) {
    emit(
      PortalContextState(
        isLoading: false,
        semesters: List.unmodifiable(semesters),
        overview: overview,
        selectedProgramId: overview.programs.firstOrNull?.programId,
      ),
    );
  }
}
