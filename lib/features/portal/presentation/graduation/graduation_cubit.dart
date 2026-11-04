import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/utils/credit_fraction.dart';
import '../../domain/model/graduation_outcome.dart';
import '../../domain/model/portal_context.dart';
import '../../domain/use_case/portal_use_cases.dart';
import 'graduation_state.dart';

@injectable
class GraduationCubit extends Cubit<GraduationState> {
  GraduationCubit(this._portal, @factoryParam this.context)
    : super(const GraduationState());

  final PortalUseCases _portal;
  final PortalContext context;
  int _revision = 0;

  Future<void> load() async {
    final revision = ++_revision;
    emit(const GraduationState());
    try {
      final outcome = await _portal.graduation(context);
      final fraction = outcome is GraduationReviewed
          ? creditFraction(
              outcome.result.credits.recognizedTotal,
              outcome.result.credits.requiredTotal,
            )
          : 0.0;
      if (!isClosed && revision == _revision) {
        emit(
          GraduationState(
            isLoading: false,
            outcome: outcome,
            fraction: fraction,
          ),
        );
      }
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(GraduationState(isLoading: false, errorMessage: error.toString()));
      }
    }
  }
}
