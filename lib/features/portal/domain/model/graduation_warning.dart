import 'package:equatable/equatable.dart';

class GraduationWarning extends Equatable {
  const GraduationWarning({required this.code, required this.message});

  final String code;
  final String message;

  @override
  List<Object?> get props => [code, message];
}
