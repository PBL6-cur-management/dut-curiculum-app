import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/utils/credit_fraction.dart';
import '../../../../core/network/contract_exception.dart';
import '../../domain/model/graduation_outcome.dart';
import '../../domain/model/portal_context.dart';
import '../../domain/use_case/portal_use_cases.dart';
import 'progress_state.dart';

@injectable
class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._portal, @factoryParam this.context)
    : super(const ProgressState());

  final PortalUseCases _portal;
  final PortalContext context;
  int _revision = 0;

  Future<void> load() async {
    final revision = ++_revision;
    emit(const ProgressState());
    await Future.wait<void>([
      _loadGraduation(revision),
      _loadResults(revision, state.nextPage),
    ]);
    if (!isClosed && revision == _revision) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _loadGraduation(int revision) async {
    try {
      final outcome = await _portal.graduation(context);
      final fraction = outcome is GraduationReviewed
          ? creditFraction(
              outcome.result.credits.recognizedTotal,
              outcome.result.credits.requiredTotal,
            )
          : 0.0;
      if (!isClosed && revision == _revision) {
        emit(state.copyWith(graduation: outcome, fraction: fraction));
      }
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(state.copyWith(graduationError: error.toString()));
      }
    }
  }

  Future<void> _loadResults(int revision, int page) async {
    try {
      final result = await _portal.results(context, page: page);
      if (isClosed || revision != _revision) {
        return;
      }
      if (result.page != page ||
          result.total < 0 ||
          result.pageSize <= 0 ||
          (result.items.isEmpty && state.results.length < result.total)) {
        throw ContractException(result.toString());
      }
      emit(
        state.copyWith(
          resultsLoaded: true,
          results: List.unmodifiable([...state.results, ...result.items]),
          total: result.total,
          nextPage: page + 1,
          clearResultsError: true,
        ),
      );
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(state.copyWith(resultsError: error.toString()));
      }
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    final revision = _revision;
    emit(state.copyWith(isLoadingMore: true, clearResultsError: true));
    await _loadResults(revision, state.nextPage);
    if (!isClosed && revision == _revision) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
