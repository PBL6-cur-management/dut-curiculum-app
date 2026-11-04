import 'package:equatable/equatable.dart';

import '../../domain/model/session_user.dart';

enum SessionStatus { unknown, unauthenticated, authenticated }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.unknown,
    this.user,
    this.notice,
    this.errorMessage,
    this.isSigningOut = false,
  });

  static const expiredNotice = 'sessionExpired';

  final SessionStatus status;
  final SessionUser? user;
  final String? notice;
  final String? errorMessage;
  final bool isSigningOut;

  SessionState copyWith({
    SessionUser? user,
    bool? isSigningOut,
    bool clearNotice = false,
  }) => SessionState(
    status: status,
    user: user ?? this.user,
    notice: clearNotice ? null : notice,
    errorMessage: clearNotice ? null : errorMessage,
    isSigningOut: isSigningOut ?? this.isSigningOut,
  );

  @override
  List<Object?> get props => [status, user, notice, errorMessage, isSigningOut];
}
