import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/model/portal_context.dart';
import '../../domain/use_case/portal_use_cases.dart';
import 'registration_state.dart';

@injectable
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit(this._portal, @factoryParam this.context)
    : super(const RegistrationState());

  final PortalUseCases _portal;
  final PortalContext context;
  int _revision = 0;

  Future<void> load() async {
    final revision = ++_revision;
    emit(const RegistrationState());
    try {
      final report = await _portal.eligibility(context);
      if (!isClosed && revision == _revision) {
        emit(RegistrationState(isLoading: false, report: report));
      }
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(
          RegistrationState(isLoading: false, errorMessage: error.toString()),
        );
      }
    }
  }
}
