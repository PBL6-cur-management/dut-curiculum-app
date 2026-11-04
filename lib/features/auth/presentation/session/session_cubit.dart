import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/session/session_events.dart';
import '../../domain/model/session_user.dart';
import '../../domain/use_case/auth_use_cases.dart';
import 'session_state.dart';

@singleton
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._auth, SessionEvents events) : super(const SessionState()) {
    _subscription = events.expired.listen((_) => _expire());
  }

  final AuthUseCases _auth;
  late final StreamSubscription<void> _subscription;
  int _revision = 0;

  Future<void> restore() async {
    final revision = ++_revision;
    try {
      final user = await _auth.currentUser();
      if (isClosed || revision != _revision) {
        return;
      }
      emit(
        SessionState(
          status: user == null
              ? SessionStatus.unauthenticated
              : SessionStatus.authenticated,
          user: user,
        ),
      );
    } catch (error) {
      if (isClosed || revision != _revision) {
        return;
      }
      emit(
        SessionState(
          status: SessionStatus.unauthenticated,
          notice: error.toString(),
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void signedIn(SessionUser user) {
    ++_revision;
    emit(SessionState(status: SessionStatus.authenticated, user: user));
  }

  void passwordChanged() {
    final user = state.user;
    if (state.status != SessionStatus.authenticated || user == null) {
      return;
    }
    emit(state.copyWith(user: user.copyWith(mustChangePassword: false)));
  }

  Future<void> logout() async {
    if (state.isSigningOut) {
      return;
    }
    final revision = ++_revision;
    emit(state.copyWith(isSigningOut: true, clearNotice: true));
    String? errorMessage;
    try {
      await _auth.logout();
    } catch (error) {
      errorMessage = error.toString();
    }
    if (isClosed || revision != _revision) {
      return;
    }
    emit(
      SessionState(
        status: SessionStatus.unauthenticated,
        notice: errorMessage,
        errorMessage: errorMessage,
      ),
    );
  }

  void _expire() {
    if (state.status != SessionStatus.authenticated || state.isSigningOut) {
      return;
    }
    ++_revision;
    emit(
      const SessionState(
        status: SessionStatus.unauthenticated,
        notice: SessionState.expiredNotice,
      ),
    );
  }

  void clearNotice() => emit(state.copyWith(clearNotice: true));

  @override
  @disposeMethod
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
