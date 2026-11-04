import 'package:equatable/equatable.dart';

class SyllabusClo extends Equatable {
  const SyllabusClo({required this.code, required this.description});

  final String code;
  final String description;

  @override
  List<Object?> get props => [code, description];
}
