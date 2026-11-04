import 'package:equatable/equatable.dart';

import '../../domain/model/session_user.dart';

class LoginState extends Equatable {
  const LoginState({this.isSubmitting = false, this.user, this.errorMessage});

  final bool isSubmitting;
  final SessionUser? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [isSubmitting, user, errorMessage];
}
