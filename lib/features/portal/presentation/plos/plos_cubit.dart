import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/model/portal_context.dart';
import '../../domain/use_case/portal_use_cases.dart';
import 'plos_state.dart';

@injectable
class PlosCubit extends Cubit<PlosState> {
  PlosCubit(this._portal, @factoryParam this.context)
    : super(const PlosState());

  final PortalUseCases _portal;
  final PortalContext context;
  int _revision = 0;

  Future<void> load() async {
    final revision = ++_revision;
    emit(const PlosState());
    try {
      final items = await _portal.plos(context);
      if (!isClosed && revision == _revision) {
        emit(PlosState(isLoading: false, items: List.unmodifiable(items)));
      }
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(PlosState(isLoading: false, errorMessage: error.toString()));
      }
    }
  }
}
