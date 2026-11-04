import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  @override
  List<Object?> get props => [isSubmitting, isSuccess, errorMessage];
}
